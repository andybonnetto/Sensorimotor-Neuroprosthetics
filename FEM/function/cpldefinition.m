function cpldefinition(model, type, cpltag, varargin )
%CPLDEFINITION defines one cut plane using the given definition type 
%   type : 'xy' : plane defined by the height z e.g varargin = '10[um]'
%          'pn' : point and normal e.g varargin = px, py, pz, nx, ny, nz
%                                               = '0', '0', '-10[um]', 0, 0, -1
% px, py, pz are char, nx, ny, nz are numbers


% Cut plane definition
model.result.dataset.create(cpltag, 'CutPlane');

% Plane definition depends on type variable
switch type
    case 'xy' % Plane defined by 1 variable : the height z 
        height = varargin{1};
        % model.result.dataset(cpltag).set('quickz', [append(height,'[') native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm]']);
        model.result.dataset(cpltag).set('quickplane', 'xy');
        model.result.dataset(cpltag).set('quickz', '10[um]');
        model.result.dataset(cpltag).set('spacevars', {'cpl3x' 'cpl3y'});
        model.result.dataset(cpltag).set('normal', {'cpl3nx' 'cpl3ny' 'cpl3nz'});

    case 'pn' % Plane defined by 6 variables : point and normal
        px = varargin{1} ; py = varargin{2}; pz = varargin{3};
        nx = varargin{4} ; ny = varargin{5}; nz = varargin{6};

        {px py pz}
        [nx ny nz]

        model.result.dataset(cpltag).set('planetype', 'general');
        model.result.dataset(cpltag).set('genmethod', 'pointnormal');
        model.result.dataset(cpltag).set('genpnpoint', {px py pz});
        model.result.dataset(cpltag).set('genpnvec', [nx ny nz]);
        
    otherwise
        "Non valid cut plane type"
        return
end


end
