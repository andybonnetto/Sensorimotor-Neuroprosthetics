function Script()
    import Cell.*
    import Constants.*

    %Time modeling
    %Sould be already defined
        %Cell_list,Delta_Ve on each cell, hierarchy
    Cell1 = Cell("HRZ",[1,1,1]);
    Cell2 = Cell("HRZ", [0,1,0]);
    Cell3 = Cell("HRZ", [0,0,3]);

    Cell1.pre_syn_subset = [2,3];
    Cell1.post_syn_subset = [2];
    Cell2.post_syn_subset = [1];
    Cell2.pre_syn_subset = [1];
    Cell3.post_syn_subset = [1];
    
    cell_list = [Cell1,Cell2,Cell3];

    for cell = cell_list
        cell.Delta_Ve = 0; 
    end

    %Initialization at time t=0
    cell_list = initialization(cell_list);
    double t;
    %TIME LOOP
    for i = [2:Constants.t_size]
%         Update Gsyns at time t=tau syn
        for cell = cell_list
            for syn = 1:length(cell.pre_syn_subset)
                cell.Gsyn(syn,i) = get_Gsyn(cell,cell_list,i, syn);
            end
        end
        %Update V_m at time tau_syn
        for cell = cell_list
            start = i*Constants.time_coeff-(Constants.time_coeff-1);
            stop = start + Constants.time_coeff - 1;
            cell.V_m(start:stop) = update_V_m(cell_list,cell,i);
        end
    end
% plot(cell_list(1).Gsyn(1,2:end))

% plot(cell_list(1).Gsyn(1,:))
plot(cell_list(1).V_m)
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


function d = euclidian_distance(p,po)
    d = sqrt(sum((p - po) .^ 2));
end

function Gsyn = calculate_Gsyn_light(Source,cell)
    L = Source.get_itensity(cell.x,cell.y);
    Gsyn = cell.g_min + (cell.g_max - cell.g_min)*(Source.L_max-L); 
end


function Gsyn = get_Gsyn(cell, cell_list, i, syn)
    i= double(i);
    D = 100e-6;
    W = exp(-D/cell.sigma);
    pre_syn = cell_list(cell.pre_syn_subset(syn));
    
    if pre_syn.type == "D"
        g_syn = cell.g_min + (cell.g_max - cell.g_min)*(1-1/((1+exp(pre_syn.V_m(i*Constants.time_coeff-(Constants.time_coeff-1)-1)-cell.V_50))/cell.beta));
    elseif pre_syn.type == "I"
        g_syn = cell.g_min + (cell.g_max - cell.g_min)/((1+exp(pre_syn.V_m(i*Constants.time_coeff-(Constants.time_coeff-1)-1)-cell.V_50))/cell.beta);
    end
    Gsyn = 1/W*g_syn*exp(-D/cell.sigma);
end

function V = update_V_m(cell_list,Cell,i)
    syms V_m(k)
    l = 1;
    tot = 0;
    for j = Cell.pre_syn_subset
        tot = tot + cell_list(j).E_syn*Cell.Gsyn(l,i);
        l = l+1;
    end
    ode = diff(V_m,k) == -V_m(k) + (Cell.G_m *(Cell.E_rest +1/2*Cell.Delta_Ve)+tot)/Cell.C_m;
    i = double(i);
    t = double(i*Constants.time_step-Constants.tau_syn);
    cond = V_m(t) == Cell.V_m(i*Constants.time_coeff-(Constants.time_coeff-1)-1);
    sol = dsolve(ode,cond);
    V = zeros(1,Constants.time_coeff);
    for m = 1:Constants.time_coeff
        k0 = double(i*Constants.time_step+(m-1)*Constants.tau_syn);
        V(m) = double(subs(sol,k,k0));
    end
end

function cell_list = initialization(cell_list)
    for cell = cell_list
        cell.V_m = ones(1,Constants.t_size*Constants.time_coeff)*rand*(-100e-3);
        cell.Gsyn = zeros(length(cell.pre_syn_subset),Constants.t_size);
    end
end

