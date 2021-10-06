function Script()
    import Cell.*
    import Electrode.*
    % Spatial Modeling
    size = -5:5;
    spacing = 2.5e-6;
    sigma = 1e-6;

    %Hexagonal lattice generation
    p = lattice_generation(size,spacing,sigma);
    scatter(p(:,1),p(:,2), '.')

    cell1 = Cell("HRZ",[1,1,1]);
    cell2 = Cell("BP_off", [0,1,0]);
    cell_list = [cell1,cell2];
    source = Electrode(50e-6,[2,2,2]);
    initialization(source,cell_list)
    cell1.Gsyn
    cell2.Gsyn
end

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
end

function initialization(Source,cell_list)            
    for cell = cell_list
        if Source.name == "light"
            cell.Gsyn = calculate_Gsyn_light(Source,cell);
        elseif Source.name == "electrode"
            vm_field = get_vmfield(cell,Source);
            cell.Gsyn = calculate_Gsyn(vm_field,cell);
        end
    end
end

function vm_field = get_vmfield(cell,Source)
    r = sqrt((cell.x-Source.x)^2 + (cell.y - Source.y)^2);
    d = cell.z - Source.z;
    Ve = 2*Source.Vo/(2*pi)*asin(2*Source.alpha/(sqrt((r+Source.alpha))^2+d^2) + sqrt((r-Source.alpha)^2+d^2));
%     Ask for the initial value
    vm_field = Ve; %Its wrong but we will see later how to calculate vm

end

function Gsyn = calculate_Gsyn(vm_field,cell)
    total = 0;
    for idx = cell.pre_syn_subset
        presyn = cell_list(idx);
        d = euclidian_distance([cell.x,cell.y,cell.z],[presyn.x,presyn.y,presyn.z]);
        %FIND A WAY to get gsyn with respect to Vm
        total = total + presyn.g_syn*exp(-d/cell.sigma);
    end

    
end

function d = euclidian_distance(p,po)
    d = sqrt(sum((p - po) .^ 2));
end

function Gsyn = calculate_Gsyn_light(Source,cell)
    L = Source.get_itensity(cell.x,cell.y);
    Gsyn = cell.g_min + (cell.g_max - cell.g_min)*(Source.L_max-L); 
end
