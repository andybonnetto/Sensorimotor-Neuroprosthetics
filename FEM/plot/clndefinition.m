function clntag = clndefinition(model, x1, y1, z1, x2, y2, z2)
% CLNDEFINTION creates one cut line defined by the start and end points
% clntag : cut line number. e.g 'cln1'
% x1, y1, z1 : point 1 coordinate e.g  :  '-1', '-1', '-10[um]'
% x2, y2, z2 : point 2 coordinate e.g  :  '1', '1', '-10[um]'

clntag = char( model.result.dataset.uniquetag('cln'));
model.result.dataset.create(clntag ,'CutLine3D');
model.result.dataset(clntag).set('genpoints', {x1 y1 z1 ; x2 y2 z2} );
%model.result.dataset(clntag).set('spacevars', {'cln1x'});

end

