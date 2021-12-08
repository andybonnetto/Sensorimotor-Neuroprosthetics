clear variables; clc; close all
recycle on
disp("Spatial modeling automatized...")
Ma = 1;
cell_list = Spatial_modeling_automatized(1,Ma,[1,1,1,1,1,1,1,1,1],[1,0,0,0,0,0,0,0,0]);

%%
disp("Declare 0.5 light protocol...")
modes = ["full-0"];
% Declare one big pulse of 0 intensity light for initialization
p_duration = Constants.simulation_duration;
p_spacing = 0;
pp = [p_duration;p_spacing];
L = light_to_cells(mat3D,n_CR,modes,pp,0);
disp("Initial values and initial matrice generation...")
M_cells = Temporal_modeling_matrix(cell_list,{[],[]},L,Ma);

%% 
disp("Declare Light protocol...")
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
M_cells = Temporal_modeling_matrix(cell_list,{M_init,V_m_init},L,Ma);
%%
d = 100e-6;
x_center = 0;
y_center = 0;
theta = linspace(0,2*pi);
x = 0.5*d*cos(theta) + x_center;
y = 0.5*d*sin(theta) + y_center;

figure()
names = ["CR","HRZ","BP_on","BP_off","AM_WF_on","AM_WF_off","AM_NF_on","GL_on","GL_off"];
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
%%
% 
% figure()
% d = M_cells.names == "GL_on";
% plot(linspace(0,Constants.simulation_duration,Constants.t_size+1), M_cells.V_m(d,:)*1e3)
% %%
% % figure()
% d = M_cells.names == "GL_on";
% sub1 = M_cells.V_m(d,end) == M_cells.V_m(9568,end);
% sub2 = not(M_cells.V_m(d,end) == M_cells.V_m(9568,end));
% disp(sparse(sub2))
% % disp(sum(sparse(sub1)))
% % plot(linspace(0,Constants.simulation_duration,Constants.t_size+1), M_cells.V_m(sub2,:)*1e3)
% 
% 

%%

