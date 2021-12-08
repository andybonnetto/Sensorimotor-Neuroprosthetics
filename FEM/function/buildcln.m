function buildcln(model, pgtag, varargin)
%UNTITLED Summary of this function goes here
%   varargin must be the 'cln1', ..., 'clnn' that we want to plot

nb_plot = (nargin-2); % Number of line graphs to create

% Create plot group
pg = model.result.create(pgtag, 'PlotGroup1D');

pg.set('data', 'cpl3');

pg.set('xlabel', 'x/0.7 (m)');
pg.set('ylabel', 'Electric potential (V)');

for i = 1:nb_plot

    lnrtag_i = append('lnr',num2str(i));
    clntag_i = varargin{i};
    
    % Create 'LineGraph' plot 
    pg.create(lnrtag_i, 'LineGraph');
    pg.feature(lnrtag_i).set('xdata', 'expr');

    % Assign one cut line to the graph
    pg.feature(lnrtag_i).set('data', clntag_i);
    pg.feature(lnrtag_i).set('xdataexpr', 'x/0.7');
    pg.feature(lnrtag_i).set('xdataunit', 'm');
    pg.feature(lnrtag_i).set('xdatadescr', 'x/0.7');
    pg.feature(lnrtag_i).set('legend', true);
    pg.feature(lnrtag_i).set('legendmethod', 'manual');
    pg.feature(lnrtag_i).set('legends', {append('potential at ',clntag_i)});
    pg.feature(lnrtag_i).set('resolution', 'normal');

end






end

