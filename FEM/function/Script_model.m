%%
clear all
close all
clc

%% Load the model 
model = modele_retine;
"Done"

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