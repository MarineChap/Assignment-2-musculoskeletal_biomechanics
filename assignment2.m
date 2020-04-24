% Marine Chaput - 2019/2020
%% Assignement 2: Rigidity analysis of femora based on computed tomography

%% Mirels classification 
%
% The Mirels score is based on a scoring system with four characteristics each graded from 1 to 3: 
% 
% *	Site of lesion
% *	Nature of lesion = blastic, mixed and lytic
% *	Size of lesion = fraction of the cortical thickness 
% *	Pain = mild, moderate, functional. It is the only subjective variable
% 
% Based on the overall score, a recommendation in favor (>= 9) or against (<= 7) prophylactic fixation of a lesion is given. This score can also be associated with a fracture probability. Example: a score of 9 corresponded with 15% of probability while a score of 10 corresponds to a probability of 72%. 
% This score has been investigated in multiple studies and has been proved as reproductible, valid and more sensitive than clinical judgment (intramurally by Mirels (78 lesions) and extramurally by Damron et al. (12 lesions)). For this last study, an analysis of the reproducibility between 53 practiciens showing a statistically significant concordance in the resultat across all examiners. Validy has been study by analyzing the data on a pool of 7 patients with no prophylactic femur stabilization.  
% However, this rating method has been criticized for poor specificity. This a lot of due to a treatment dilemma at the borderline score (8). With a strict application of the Mirel?s recommendation, unnecessary prophylactic fixation is recommended for 2/3 of the patients.
% Also, these criterions are not generalizing very well to other bones than the femur with an important sensitivity decrease.  
% In conclusion, the Mirels classification rating is a valid screening tool reasonably reproductible only for metastatic lesions in long bones. It has been independently proving as superior to the clinical judgement but let room for improvements. 
% 
% Interesting discussion of the pros or cons of the Mirel's classification: 
% <https://journals.lww.com/clinorthop/fulltext/2010/10000/In_Brief__Classifications_in_Brief__Mirels_.40.aspx Reference>
% 
%% CTRA criterion 
% The criterion proposed in the paper Kistler and Damron is a reduction of 35%
% or greater of the axial, bending or torsional rigidity of the weakest cross 
% section through the bone compared with the intact contralateral side or to 
% a matched bone (if the first one is not available). 

%% Identify the cross-section with lowest rigidity
clear
clc
close all

% The lesion is a simulated lytic lesion in the proximal femur. Therefore,
% it can be found almost at the end of the cross-section dataset. 

% Bone 6L
CTRA_compare("6L", [], 'yes', 'yes');

% Bone 10L
CTRA_compare("10L", [], 'yes',  'yes');

%%
%
% The lowest rigidity is also found at the proximal side of the bone. But
% we cannot conclude that it indicates the lesion in particular. More the
% cross-section will get smaller and smaller (at extremety of the bone) more
% the rigidity will go to zero. 
% Futhermore, the cross-section through the affected bone that had the lowest rigidity is
% assumed to govern the failure behavior of the entire bone. 
% However, this does not mean that CTRA can predict the exact failure load 
% the exact location of a future fracture. 
% On the contrary, CTRA seeks to determine a fracture risk threshold by
% comparing with a health bone. 



%% Compare the bone before and after the damage

CTRA_compare("10L", "10L","yes");
%%
% The bending rigidity EIx is around 5% lower between the femur with lesion and
% without

%% Compare the defect bone with its contralateral intact bone
% To assess how much lower the defect curve is against the intact curve, we
% are taking the abs(1 - ratio)*100

CTRA_compare("8L", "8R", "yes");

%%
% The CTRA could be able to identify the lesion by using the bending
% rigidity EIy. However, the bending rigidity EIx give confusing result
% because of the huge difference between intact and defect rigidy along the
% bone


dataset = ["3" "6" "9" "10"];
for file = dataset
    CTRA_compare(strcat(file, "L"), strcat(file, "R"), "yes");
end

%% 
% The result is mitigated. It can be due to an error in the code, but it is
% useful to note that this type of analysis will have worse results to the
% extremity (proximal and distal) of the bone because of the stresses at
% the extremes of the beam not uniform when near to where the load is
% applied. 
% We can use finite element analysis to determine in detail the effect of 
% the non uniform stress.
%
% Thanks to Pable De Lucca to raise this interesting point in the
% Discussion board. 

%% Part 6: Conclusion
% I would recommend to use this technique in combination with other as
% finite element analysis and Mirel's classification. I would also
% recommend to slightly improve the algorithm (develop here) by adding
% normalization to avoid the decrease of the rigity due to the decrease of
% the cross-section size. 