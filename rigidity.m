% Marine Chaput - 2019/2020
function [EA, EIx, EIy] = rigidity(dicomfile, plot)

if ~exist('plot','var')
    plot="no";
end

%Scaling parameters for CT to HU
slopeCT     = 1;
interceptCT = -1024; %originally: 1024

%Scaling parameters for HU to rho
slopeRho        =  0.0012635;
interceptRho    = -0.0068565;

rho_min         = 0.01;
gauss_sigma     = 1;

CTscan = double(dicomread(dicomfile));

CTinfo = dicominfo(dicomfile);


%Convert CT data to HU values
HU    = CTscan * slopeCT + interceptCT;

%apply smoothing
HU_smooth    = imgaussfilt(HU, gauss_sigma);

%Convert HU data to density [g/cm^3]
rho    = HU_smooth * slopeRho + interceptRho;
rho(rho < 0) = 0;
rho(HU_smooth > 0 & rho < rho_min) = rho_min; % to prevent a negative density

%Convert density to modulus E
E = zeros(size(rho));

for i=1:size(rho,1)
    for j=1:size(rho,2)
        if rho(i,j) == 0
            E(i,j) = 0;
        elseif rho(i,j) <= 1.1
            E(i,j) = 0.82*rho(i,j) + 0.07;
            
        else
            E(i,j) = 21.91*rho(i,j) - 23.51;
        end
    end
end

dx = CTinfo.PixelSpacing(1);
dy = CTinfo.PixelSpacing(2);
da = dx*dy; % the area of one pixels
w = CTinfo.Width;
h = CTinfo.Height;

%Determine the location of the neutral axis

na_x = 0;
na_y = 0;

for k=1:h
    for l= 1:w
        na_y = na_y + E(k,l)*k*da;
        na_x = na_x + E(k,l)*l*da;
    end
end

na_x=na_x/(sum(E, 'all')*da);
na_y=na_y/(sum(E, 'all')*da);

%na_x = 203;
%na_y = 106;
%quantify axial rigidity (EA):
% for all pixels: EA = summation of E(x,y)*da
EA = sum(E, 'all')*da;
%quantify the bending rigidity
% for each pixel, calculate the moment of inertia (Ixx) as
% Ixx = Ixx_pixel + Ixx_parallel-axis-theorem
EIx = 0;
EIy = 0;
Ixx = zeros(h,w);
Iyy = zeros(h,w);
for k=1:h
    for l=1:w
        Ixx(k,l) = 1/12*(dx*dy^3) + da*(double(l - na_x)^2);
        
        % Iyy = Iyy_pixel + Iyy_parallel-axis-theorem
        
        Iyy(k,l) = 1/12*(dy*dx^3) + da*(double(k - na_y)^2);
        % ... your code
    end
    
            % for all pixels: EIx = summation of E(x,y)*Ixx(x,y)
    EIx = sum(E.*Ixx, 'all');
    
    % for all pixels: EIy = summation of E(x,y)*Iyy(x,y)
    EIy = sum(E.*Iyy, 'all');
end

if plot == "yes"

    %display some data
    subplot(2,2,1)
    hold on
    imshow(CTscan, []);  
    colorbar
    scatter(na_x, na_y, '*g');
    hold off
    title('CT image');

    subplot(2,2,2)
    imshow(HU, [-1000 2000], 'Colormap', hot);
    colorbar
    title('HU');

    subplot(2,2,3)
    imshow(rho, [0 2], 'Colormap', hot);
    colorbar
    title('rho');

    subplot(2,2,4)
    imshow(E, [0 20], 'Colormap', hot);  % Display image.
    colorbar
    title('E');

    drawnow;
end
end



