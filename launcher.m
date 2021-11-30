clear variables; clc; close all
recycle on
k = 1;
disp("Spatial modeling...")
Spatial_modeling(1)

%%
disp("Declare 0.5 light protocol...")
modes = ["full-0"];
p_duration = 500e-3;
p_spacing = 0;
pp = [p_duration;p_spacing];
L = light_to_cells(mat3D,n_CR,modes,pp,0);
disp("Initial values and initial matrice generation...")
M_cells = Temporal_modeling_matrix(cell_list,{[],[]},L);

%%
c = 15;
k = 1;
f = figure(k);
plot(linspace(0,Constants.simulation_duration,Constants.t_size+1), M_cells.V_m(c,:)*1e3)
title(strcat("Cell ", num2str(c)))
xlabel("Time")
ylabel("V_m (mV)")

%% 
disp("Declare Light protocol...")
n_tot = size(cell_list,2);
modes = ["full-1","full-0","full-1", "full-0"];
p_duration = 30e-3;
p_spacing = 125e-3;
pp = zeros(2,size(modes,2));
for i = 1:size(modes,2)
    pp(:,i)= [(i-1)*p_spacing;p_duration];
end
L = light_to_cells(mat3D,n_CR,modes,pp,0);

disp("Sanitity check and initial matrice generation...")
M_cells = Temporal_modeling_matrix(cell_list,{M_init,V_m_init},L);
%%
d = 100e-6;
x_center = 0;
y_center = 0;
theta = linspace(0,2*pi);
x = 0.5*d*cos(theta) + x_center;
y = 0.5*d*sin(theta) + y_center;

c = sqrt(mat3D(:,1).^2+mat3D(:,2).^2) <= 0.5*d;
k = 1;
figure();
a = M_cells.V_m(c,:)*1e3;
a = a(909:end,:);
for i = 1:size(a,1)
    plot(linspace(0,Constants.simulation_duration,Constants.t_size+1), a(i,:))
    hold on
end
figure()

for d = 10398:11025
    plot(linspace(0,Constants.simulation_duration,Constants.t_size+1), M_cells.V_m(d,:)*1e3)
    hold on
end
xlabel("Time")
ylabel("V_m (mV)")

figure()
names = ["CR","HRZ","BP_on","BP_off","AM_WF_on","AM_WF_off","AM_NF_on","GL_on","GL_off"];
k=1;
for name = names
    subplot(3,3,k)
    d = M_cells.names == name;
    plot(linspace(0,Constants.simulation_duration,Constants.t_size+1), M_cells.V_m(d,:)*1e3)
    title(name)
    k = k +1;
end

%% 
disp("Find initial value for V_m...")
n_sim = 1;
Initial_value_seeking(cell_list,L,n_sim, M_init);

%% 

cell_vis = [randi([1,4225],1),randi([4225,4754],1),randi([4754,6435],1),randi([6435,8116],1),randi([8116,8477],1), randi([8477,8838],1), randi([8838,9567],1),randi([9567,10296],1), randi([10296,11025],1)];
k = k+1;
for c = cell_vis
    f = figure(k);
    for i = 1:n_sim   
        plot([V_m_init_0(c,i), V_m_init(c,i)])
        hold on
    end
    legend("Simulations #")
    title(strcat("Convergence for cell ", num2str(c)))
    set(gca,'xtick', [1,2],'xticklabel',["Initial value", "Final value"])
    ylabel("V_m (V)")
    saveas(gcf,strcat("C:\Users\andyb\OneDrive\EPFL\MA3\Sensorymotor neuroprosthetics\Results\","Convergence_cell_",num2str(c),"sim",num2str(n_sim),".png"))
    k = k+1;
end
% %% 
% k = k+1;
% figure(k);
% n_sim = size(V_m_init,2);
% for i = 1:n_sim
%     scatter(1:1:M_cells.N_cells,V_m_init(:,i),'.')
%     title("Final membrane potential for all cells")
%     hold on
% end
% xlabel('Cell index')
% ylabel('V_m [V]')
% % legend(string(1:n_sim))
% %% 
% disp("Control test with initial values")
% pfile = strcat(pfolder,"test_control.txt");
% Temporal_modeling_matrix(cell_list,{M_init,V_m_init(:,1)},L,pfile)
% Read_V_m_file(pfile,outputstr,n_tot)
% k = k+1;
% for c = cell_vis
%     f = figure(k);
%         plot([V_m(c,:), V_m(c,:)])
%     title(strcat("Control for cell ", num2str(c)))
%     xlabel("Time (ms)")
%     ylabel("V_m (V)")
%     saveas(gcf,strcat("C:\Users\andyb\OneDrive\EPFL\MA3\Sensorymotor neuroprosthetics\Results\","Control_cell_",num2str(c),".png"))
%     k = k+1;
% end
% %% 
% disp("Visualization of Light modes")
% mode_list = ["full-0", "full-1", "disk-plus-40", "disk-plus-100", "disk-minus-40", "disk-minus-100"];
% for mode = mode_list
%     k = k+2;
%     L = light_to_cells(mat3D,n_CR,n_tot,mode,k);
% end 
% 
% 
% %% 
% disp("Test with different light modes")
% 
% k = k+1;
% figure(k);
% for mode = mode_list
%     L = light_to_cells(mat3D,n_CR,n_tot,mode,0);
%     pfile = strcat(pfolder,"test_",mode,".txt");
%     Temporal_modeling_matrix(cell_list,{M_init,V_m_init(:,1)},L,pfile);
%     Read_V_m_file(pfile,outputstr,n_tot);
%     n_sim = size(V_m_init,2);
%     scatter(1:1:M_cells.N_cells,V_m(:,end),'.')
%     hold on
% end
% title("Final membrane potential for all cells with different modes")
% xlabel('Cell index')
% ylabel('V_m [V]')
% legend(mode_list)




