%% compute model
clear all
clc

addpath('function')  

%import com.comsol.model.*
%import com.comsol.model.util.*

%general param
wid                 = 5000*10^-6;    %[m]
len                 = 5000*10^-6;    %[m]
z_pos               = 20;           %[um]
injected_current    = 0.5;          %[A]
mesh_size           = 4;            % between 1 et 9, 1 is the smallest


%table of electrodes

%creation electrode
%electrode array is e_array
%e_array = [ x, y, z, rad, type]
X       = [-150 ;   0 ;     150 ;   100 ]*10^-6;
Y       = [-100;    200;    -100;   100 ]*10^-6;
Z       = [ z_pos;  z_pos;  z_pos;  180 ]*10^-6;
rad     = [ 100;    100;    100;    100 ]*10^-6;
type    = ['inj';   'ret';  'ret';  'inj' ];

%e_table = table( X, Y, Z, rad, type )

x = -1000*10^-6;
y = -1000*10^-6;

d = 250*10^-6;

r = 100*10^-6;

zinj = 0;
zret = 0;

Mtype=randi([0, 1], [12,12]); % Matrix of k*l electrodes types

e_table = create_rectangle(x, y, d, r, zinj, zret, Mtype)

model  = model(e_table, wid, len, injected_current, mesh_size)

"Done"
%mphviewselection(model1, 'geom1', idx_ret, 'boundary' )

% Datasets

cpl_tag1 = cpldefinition(model, 'xy', '0[um]' );
cpl_tag2 = cpldefinition(model, 'xy', '30[um]' );
cpl_tag3 = cpldefinition(model, 'pn', '0', '0', '-10[um]', 0, 0, -1);
cpl_tag4 = cpldefinition(model, 'pn', '0', '0', '0', -1, 1, 0 );
cpl_tag5 = cpldefinition(model, 'yz', '30[um]' );

cln_tag1 = clndefinition(model, '-1', '-1', '-10[um]', '1', '1', '-10[um]');
cln_tag2 = clndefinition(model, '-1', '-1', '0[um]', '1', '1', '0[um]');
cln_tag3 = clndefinition(model, '-1', '-1', '10[um]', '1', '1', '10[um]');
cln_tag4 = clndefinition(model, '-2[mm]', '0[mm]', '-10[um]', '2[mm]', '0[mm]', '-10[um]');
cln_tag5 = clndefinition(model, '-2[mm]', '0[mm]', '0[um]', '2[mm]', '0[mm]', '0[um]');
cln_tag6 = clndefinition(model, '-2[mm]', '0[mm]', '10[um]', '2[mm]', '0[mm]', '10[um]');
% Plot 

"Plotting..."
pg_tag1 = buildmslc(model); %,'60[um]','50[um]','100[um]');
pg_tag2 = buildcpl(model, cpl_tag1, cpl_tag3);
pg_tag3 = buildcpl(model, cpl_tag5, cpl_tag5);
pg_tag4 = buildcln(model, cln_tag1, cln_tag2, cln_tag3);
pg_tag5 = buildcln(model, cln_tag4, cln_tag5, cln_tag6);
%pg_tag5 = buildcpl(model, cpl_tag5);


% model.result(pg_tag1).set("savedatainmodel", true);
% model.result(pg_tag2).set("savedatainmodel", true);
% model.result(pg_tag3).set("savedatainmodel", true);
% model.result(pg_tag4).set("savedatainmodel", true);
"Plotting OK."

% Plot Test 
figure
mphplot(model);
%figure
%pg4 = mphplot(model, 'pg4', 'createplot', 'off');
%figure
%mphplot(model, 'pg4');

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
info = mphsolinfo(model);
info2 = mphsolutioninfo(model);

%% Extract solution Vector

U = mphgetu(model, 'soltag', 'sol1');

%%
mphplot(model, 'pg1')

