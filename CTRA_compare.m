% Marine Chaput - 2019/2020
function [EA_compare, EIx_compare, EIy_compare] = CTRA_compare(defect_file, intact_file, plot_fig, plot_value)

if ~exist('intact_file','var') || isempty(intact_file)
  intact_file = "no_file";
end

if ~exist('plot_fig','var') || isempty(plot_fig)
  plot_fig="no";
end


if ~exist('plot_value','var') || isempty(plot_fig)
  plot_value="no";
end

index = 1; 
img_dir   = "../Data_set"; 

if intact_file == "no_file"
    dataset = strcat(img_dir, "/Defect/D_",defect_file);
else
    dataset =  [strcat(img_dir, "/Defect/D_",defect_file),strcat(img_dir, "/Intact/I_",intact_file)];
end

for bone_set = dataset
    dicomlist = dir(fullfile(bone_set, '*.dcm'));
    EA = zeros(1,numel(dicomlist));
    EIx = zeros(1,numel(dicomlist));
    EIy = zeros(1,numel(dicomlist));
    
    if plot_value == "yes"
        if index == 1 
            fprintf(1,'--- Defect bone %s --- \n', defect_file);
        else
            fprintf(1,'--- Intact bone %s ---  \n', intact_file)
        end
    end
    
    for cnt = 1 : numel(dicomlist)
        dicomfile = fullfile(bone_set, dicomlist(cnt).name);
        [EA(cnt), EIx(cnt), EIy(cnt)] = rigidity(dicomfile);
        if plot_value == "yes"
           fprintf(1,'EA, EIx, EIy: %10.1f %10.1f %10.1f\n', EA(cnt), EIx(cnt), EIy(cnt));
       end
    end
    
    if index == 1
        EA_compare = zeros(size(dataset,1), size(EA, 2));
        EIx_compare = zeros(size(dataset,1), size(EIx, 2));
        EIy_compare = zeros(size(dataset,1), size(EIy, 2));
    end
    
    EA_compare(index, :) = EA;
    EIx_compare(index, :) = EIx;
    EIy_compare(index, :) = EIy;
    index = index+1;
    

end 

if intact_file ~= "no_file"
    diff_percentage_EA = 100*abs(1- abs(EA_compare(2, :)./EA_compare(1, :)));
    diff_percentage_EIx = 100*abs(1- abs(EIx_compare(2, :)./EIx_compare(1, :)));
    diff_percentage_EIy = 100*abs(1 - abs(EIy_compare(2, :)./EIy_compare(1, :)));
end

if plot_fig == "yes"
    figure()
    
    subplot(1,3,1)
    hold on;
    if intact_file ~= "no_file"
        yyaxis left
        plot(EA_compare(2, :), "b-");
    end
    plot(EA_compare(1, :), "y-"); 
    xlabel("Slice number")
    ylabel("Axial rigidity")
    if intact_file ~= "no_file"
        yyaxis right
        plot(ones(size(diff_percentage_EA))*35, 'k')
        plot(diff_percentage_EA, 'r')
        hold off
        ylim([0,100])
        legend("Defect bone", "Intact bone")
        ylabel("difference %")
    end

    title('EA')
    subplot(1,3,2)
    hold on;
    if intact_file ~= "no_file"
        yyaxis left
        plot(EIx_compare(2, :), "b-");
    end
    plot(EIx_compare(1, :), "y-");
    xlabel("Slice number")
    ylabel("Bending rigidity")
    if intact_file ~= "no_file"
        yyaxis right
        plot(ones(size(diff_percentage_EA))*35, 'k')
        plot(diff_percentage_EIx, 'r')
        ylim([0,100])
        ylabel("difference %")
        hold off
        legend("Defect bone", "Intact bone")
    end

    title('EIx')


    subplot(1,3,3)
    hold on;
    if intact_file ~= "no_file"
        yyaxis left
        plot(EIy_compare(2, :), "b-"); 
    end
    plot(EIy_compare(1, :), "y-");
    xlabel("Slice number")
    ylabel("Bending rigidity")
    if intact_file ~= "no_file"
        yyaxis right
        plot(ones(size(diff_percentage_EA))*35, 'k')
        plot(diff_percentage_EIy, 'r')
        ylim([0,100])
        hold off
        legend("Defect bone", "Intact bone")
        ylabel("Difference %")
    end
    title('EIy')

    if intact_file ~= "no_file"
        suptitle(strcat('Compare defect  ', defect_file,' bone against intact  ',intact_file,' bone'))
    else 
        suptitle(strcat('Bone ', defect_file,' with lesion in the proximal femur'))
    end
end
end

