function pgtag = buildmslc(model, x_plane_coord, y_plane_coord, z_plane_coord)
% Multislice 3D plot creation  
%   Detailed explanation goes here

% Default function, with default planes placement
if nargin == 1
    x_plane_coord = '0[um]';
    y_plane_coord = '0[um]';
    z_plane_coord = '0[um]';
end

% Plot group creation
pgtag = char( model.result.uniquetag('pg'));
pg = model.result.create(pgtag, 'PlotGroup3D'); 

% Create a multislice plot
pg.create('mslc1', 'Multislice');
% Create dataset for multisclice plot
pg.feature('mslc1').set('data', 'dset1');

% Create 3D plot frame
model.result(pgtag).label('Electric Potential (ec)');
model.result(pgtag).set('frametype', 'spatial');

model.result(pgtag).feature('mslc1').set('multiplanexmethod', 'coord');
model.result(pgtag).feature('mslc1').set('xcoord', x_plane_coord);
model.result(pgtag).feature('mslc1').set('ycoord', y_plane_coord);
model.result(pgtag).feature('mslc1').set('ycoord', z_plane_coord);

model.result(pgtag).feature('mslc1').set('resolution', 'normal');

end
