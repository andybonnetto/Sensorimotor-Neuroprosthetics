%% SECTION 1 : compute model for 1 electrode
clc
clear all

addpath('function')  
addpath('plot')

%%
%general param
wid                     = 1000 *10^-6;    %[m]   1000 is okay for having 0V on edge
%len                    = 1000*10^-6;    %[m]
z_pos                   = 20;           %[um]
injected_current        = 0.5;          %[A]
mesh_size               = 4;            % between 1 et 9, 1 is the smallest


%table of electrodes

%creation electrode
%electrode array is e_array
%e_array = [ x, y, z, rad, type]

X       = [0]*10^-6;
Y       = [0]*10^-6;
Z       = [0]*10^-6;
rad     = [ 100 ]*10^-6;
type    = ['inj'];

e_table = table( X, Y, Z, rad, type )  %only one injecting electrode placed in the center


%offset = 300*10^-6;
%x = 0;
%y = 0;
%y = - len/2+offset;
%d = 250*10^-6;
%r = 100*10^-6;
%zinj = 0;
%zret = 0;
%Mtype=randi([0, 1], [1,1]); % Matrix of k*l electrodes types
%e_table = create_rectangle(x, y, d, r, zinj, zret, Mtype)

model  = model(e_table, wid, wid, injected_current, mesh_size)

%% SECTION 1.1 : plot V at comsol mesh node ( for 1 electrode )
vv = mpheval(model,'V')
figure
scatter3(vv.p(1,:),vv.p(2,:),vv.p(3,:),2,vv.d1)

%% SECTION 2 : obtaining Delta_Ve with 6pts around each cell

data_struct     = load('data/mat3D.mat');      %coordinates of cell  N*3
name_struct     = load('data/matstring.mat');  %name of cell  N*1

%coord_mat = [-100 0 0; 100 0 0; 0 0 100  ] *10^-6;
%name_mat  = ["AM_NF_on"; "AM_NF_on"; "AM_NF_on" ]
%scatter3(coord_mat(1,:),coord_mat(2,:),coord_mat(3,:), 10)

%coordinate extended to 6pts around each cell
coord_extended  = compute_extended_pts(data_struct.mat3D, name_struct.matstring);

%voltage interpolation on extended pts
V_extended          = mphinterp(model,'V','coord', coord_extended);

opposite_pts        = reshape( V_extended,[2 length(V_extended)/2])';
diff_opposite_pts   = abs(opposite_pts(:,1)- opposite_pts(:,2));

%Reshape to average
%Delta_Ve = sum(reshape(diff_opposite_pts,[3 size(data_struct.mat3D,1)]),1)
%Plot of the Ve
%figure;
%scatter3(data_struct.mat3D(:,1),data_struct.mat3D(:,2),data_struct.mat3D(:,3), 5, Delta_Ve)

%Reshape to max
Delta_Ve = max(reshape(diff_opposite_pts,[3 size(data_struct.mat3D,1)])); %We keep only the max of all diametral difference for each cell

%Plot of the Ve
figure;
scatter3(data_struct.mat3D(:,1),data_struct.mat3D(:,2),data_struct.mat3D(:,3), 5, Delta_Ve)

%% SECTION 3 : create superposition for multiple electrodes

%electrode number ( bug if number of e to big compared to retina size)
nb_e_x = 13;
nb_e_y = 15;

%random current array
current_array = rand(nb_e_x*nb_e_y,1);

V_out = create_superposition(model, wid, current_array, nb_e_x, nb_e_y) ;

%mphviewselection(model1, 'geom1', idx_ret, 'boundary' )

%plot_slice(V_out, dim, slice_offset, contour_plot)
plot_slice(V_out, 'z', 20*10^-6,1)
plot_slice(V_out, 'z', 400*10^-6,1)
plot_slice(V_out, 'x', 000*10^-6)


%% SECTION 4 : previous version without suppeposition
%% Plot Test 
figure
mphplot(model);
%figure
%mphplot(model, 'pg1');
%figure
%mphplot(model, 'pg3');

  %% Display geometry
figure;
mphgeom(model, 'geom1', 'view', 'auto');
figure;
mphgeom(model,'geom1','facelabels','on','facelabelscolor','r');
%mphgeom(model, 'geom1', 'entity', 'boundary', 'selection', 6);

figure;
mphmesh(model, 'mesh1', 'view', 'auto')
%[stats,data] = mphmeshstats(model, 'mesh1');


%% Compute solution 
info    = mphsolinfo(model);
info2   = mphsolutioninfo(model);

%% Extract solution Vector

U = mphgetu(model, 'soltag', 'sol1');

%%
mphplot(model, 'pg1')

