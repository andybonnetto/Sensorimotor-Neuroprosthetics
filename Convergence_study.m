% Convergence study
clear variables; clc; close all
recycle on
names = ["CR","HRZ","BP_on","BP_off","AM_WF_on","AM_WF_off","AM_NF_on","GL_on","GL_off"];
disp("Declare 0.5 light protocol...")
modes = ["full-0"];
% Declare one big pulse of 0 intensity light for initialization
p_duration = Constants.simulation_duration;
p_spacing = 0;
pp = [p_duration;p_spacing];
interval = 1:-0.2:0.2;
V_s_conv = zeros(length(names),length(interval));

i = 1;
for Ma = interval
    disp("Spatial modeling automatized...")
    cell_list = Spatial_modeling_automatized(Ma,1,[1,1,1,1,1,1,1,1,1],[0,0,0,0,0,0,0,0,0]);
    L = light_to_cells(mat3D,n_CR,modes,pp,0);
    disp("Initial values and initial matrice generation...")
    M_cells = Temporal_modeling_matrix(cell_list,{[],[]},L,Ma);
    for k=1:length(names)
        type = M_cells.name == names(k);
        V_s = M_cells.V_S(type,:);
        V_s_conv(k,i) = V_s(1,end);
    end
    i = i+1;
end

%%
figure()
k = 1;
for name = names
    subplot(3, 3, k)
    plot(inteval,V_s_conv(k))
    title(name)
    xlabel("Magnification")
    ylabel("V_S [mV]")
    k = k+1;
end