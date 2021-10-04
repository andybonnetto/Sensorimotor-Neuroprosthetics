function Script()
    import Cell.*
    % Spatial Modeling
    size = -5:5;
    spacing = 2.5e-6;
    sigma = 1e-6;

    %Hexagonal lattice generation
    p = lattice_generation(size,spacing,sigma);
    scatter(p(:,1),p(:,2), '.')


function p = lattice_generation(size, spacing, sigma)
    K = [];
    N = [];
    for i = size
        for j = size
            param = [i,j];
            n = normrnd([0,0],sigma);
            K = vertcat(K, param);
            N = vertcat(N,n);
        end
    end
    M = [1, sqrt(3);1, -sqrt(3)]*spacing;
    p = K*M + N;
            
    