function out = model(e_table, wid, len, injected_current,mesh_size)
%
% Untitled2.m
%
% Model exported on Nov 23 2021, 15:52 by COMSOL 5.3.1.201.

addpath('function')  

import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('Model');
model.modelPath('C:\Users\raph\Desktop\cours11\automated_model1');
comp1 = model.component.create('comp1', true);
geom1 = comp1.geom.create('geom1', 3);
comp1.mesh.create('mesh1');


%create retinal layer geometrie
create_retinal_geom( model, wid, len )

%add material
create_retine_material( model, wid, len )

%create electrode geometrie
[idx_inj, idx_ret] = create_electrodes_geom( model, e_table);


%create physics
create_physics( model, wid, len, idx_inj, idx_ret, injected_current )

% mesh size 
% between 1 and 9,  1 beeing the smaller
comp1.mesh('mesh1').autoMeshSize(mesh_size);


%create study and result
model.study.create('std1');
model.study('std1').create('stat', 'Stationary');

%create result
create_result(model)


out = model;
