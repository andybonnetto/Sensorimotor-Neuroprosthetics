function pgtag = buildcpl(model, cpltag, cpltag_line)
% BUILDCPL Builds a cut plane plot (2D plot goup). One surface plot by plot
% group is drawn.
% You can choose to have a line plot at the background by providing the
% cpltag_line parameter


% Plot group creation
pgtag = char(model.result.uniquetag('pg'));
pg = model.result.create(pgtag, 'PlotGroup2D');

% Integration of cut planes into surface plot
surftag = model.result.uniquetag('surf');
pg.create(surftag, 'Surface');

% If we want a line graph at the background
 if nargin == 3
     pg.set('data', cpltag_line);
 end

pg.feature(surftag).label( append('Surface, ' , cpltag) );
pg.feature(surftag).set('data', cpltag);
pg.feature(surftag).set('resolution', 'fine');


end



% for i = 1:(nargin-2)
%     
%     Integration of surface into plot group
%     pg.create( append('surf',char(i)) , 'Surface');
% 
%     pg.feature( append('surf',char(i))).label(append('Surface 4 ',varargin{i}) );
%     pg.feature( append('surf',char(i))).set('data', varargin{i});
%     pg.feature( append('surf',char(i))).set('resolution', 'normal');
% 
% end



