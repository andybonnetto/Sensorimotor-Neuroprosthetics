clear variables; clc; close all
recycle on

% Parameters
Ma = 1; % Magnification coefficient (reflect density of cells)
Pop_represented = [0,0,1,1,1,1,1,1,1]; %Column par type: [0,0,1,1,1,1,1,1,1] removes cones and horizontals
Pop_degen = [0,0,0.5,0.5,0,0,0,0,0]; % if different than 0, value will be used as percentage of cells degenerated in given populations, Go inside spatial_modeling for further parameter changes
dVe = load("av_delta_v.mat");
Light_or_Electrode = 0; % 1 for Light and 0 for 
folder_path = "..\..\Results\10.12.2021\Light_Degen_0.7\";
if not(exist(folder_path))
    error("Folder not found")
end

disp("Spatial modeling automatized...")
[cell_list,fp_indices] = Spatial_modeling_automatized(1,Ma,Pop_represented,Pop_degen,folder_path);
size(fp_indices)

disp("Calculate resting potentials") %Get M_init and V_init
modes = ["full-0"];
% Declare one big pulse of 0 intensity light for initialization
p_duration = Constants.simulation_duration;
p_spacing = 0;
pp = [p_duration;p_spacing];
L = light_to_cells(mat3D,n_CR,modes,pp,0);
disp("Initial values and initial matrice generation...")
M_cells = Temporal_modeling_matrix(cell_list,{[],[]},L,Ma);

if Light_or_Electrode 
    disp("Declare light protocol...")
    n_tot = size(cell_list,2);
    modes = ["disk-plus-100","disk-plus-40","disk-minus-40", "disk-minus-100"];
    p_duration = 29e-3;
    p_spacing = 157e-3;
    pp = zeros(2,size(modes,2));
    for i = 1:size(modes,2)
        pp(:,i)= [(i-1)*p_spacing;p_duration];
    end
    L = light_to_cells(mat3D,n_CR,modes,pp,1);
    disp("Pulsed light Stimulation")
    Delta_Ve = zeros(M_cells.N_cells,Constants.t_size);
    M_cells = Temporal_modeling_matrix(cell_list,{M_init,V_m_init},L,Ma, Delta_Ve);
else
    disp("Electrical stimulation")
    vis_pulse = 0;
    Delta_Ve = generate_electrical_pulse(dVe.Delta_Ve,cell_list,vis_pulse,fp_indices);
    M_cells = Temporal_modeling_matrix(cell_list,{M_init,V_m_init},L,Ma,Delta_Ve);
end

% Visualization and Save plots
disp("VM plots")
figure()
name_list = ["CR","HRZ","BP_on","BP_off","AM_WF_on","AM_WF_off","AM_NF_on","GL_on","GL_off"];
names = name_list(logical(Pop_represented));

k=1;
for name = names
    subplot(3,3,k)
    d = M_cells.names == name;
    plot(linspace(0,Constants.simulation_duration,Constants.t_size+1), M_cells.V_m(d,:)*1e3)
    title(name)
    xlabel("Time [s]")
    ylabel("Voltage [mV]")
    k = k +1;
end
saveas(gcf, strcat(folder_path,"V_m subplots"))

if Light_or_Electrode
    norm_V = 9e-3;
else
    norm_V = 15e-3;
end
% Color plots
plot_membrane_voltage(M_cells,mat3D,Pop_represented,norm_V,folder_path)

% Calculate Firing rate
S = get_firing_rate(M_cells,1,folder_path);


%% Section to replot after simulation
k=1;
for name = names
    subplot(3,3,k)
    d = M_cells.names == name;
    plot(linspace(0,Constants.simulation_duration,Constants.t_size+1), M_cells.V_m(d,:)*1e3)
    title(name)
    xlabel("Time [s]")
    ylabel("Voltage [mV]")
    k = k +1;
end

plot_membrane_voltage(M_cells,mat3D,Pop_represented,norm_V,folder_path)
%%
% Calculate Firing rate
new_thresholds = [-60e-3,-53.4e-3];
S = get_firing_rate(M_cells,1,folder_path,new_thresholds);