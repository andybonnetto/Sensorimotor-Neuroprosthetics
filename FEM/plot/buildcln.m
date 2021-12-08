function pgtag = buildcln(model, varargin)
%UNTITLED Summary of this function goes here
%   varargin must be the 'cln1', ..., 'clnn' that we want to plot

nb_plot = (nargin-1); % Number of line graphs to create

pgtag = char(model.result.uniquetag('pg'));

% Create plot group
pg = model.result.create(pgtag, 'PlotGroup1D');

%results.set('xlabel', 'x/0.7 (m)');
pg.set('xlabel', 'Arc length');
pg.set('ylabel', 'Electric potential (V)');
pg.set('xlabelactive', false);
pg.set('ylabelactive', false);

for i = 1:nb_plot

    lnrtag_i = append('lnr',num2str(i));
    clntag_i = varargin{i};
    
    % Create 'LineGraph' plot 
    pg.create(lnrtag_i, 'LineGraph');
    %pg.feature(lnrtag_i).set('xdata', 'expr');

    % Assign one cut line to the graph
    pg.feature(lnrtag_i).set('data', clntag_i);
    %pg.feature(lnrtag_i).set('xdataexpr', 'x/0.7');
    %pg.feature(lnrtag_i).set('xdataunit', 'm');
    %pg.feature(lnrtag_i).set('xdatadescr', 'x/0.7');

    pg.feature(lnrtag_i).set('legend', true);
    pg.feature(lnrtag_i).set('legendmethod', 'manual');
    pg.feature(lnrtag_i).set('legends', {clntag_i});
    pg.feature(lnrtag_i).set('resolution', 'normal');

end

% model.result('pg7').feature('lngr1').set('data', 'cln9');
% model.result('pg7').feature('lngr1').set('legend', true);
% model.result('pg7').feature('lngr1').set('legendmethod', 'manual');
% model.result('pg7').feature('lngr1').set('legends', {'10[um] E e sor,jgf'});
% model.result('pg7').feature('lngr1').set('resolution', 'normal');
% 
% model.result('pg7').feature('lngr2').set('data', 'cln8');
% model.result('pg7').feature('lngr2').set('legend', true);
% model.result('pg7').feature('lngr2').set('legendmethod', 'manual');
% model.result('pg7').feature('lngr2').set('legends', {'0[um] ui ui 2e legende ui'});
% model.result('pg7').feature('lngr2').set('resolution', 'normal');




end

