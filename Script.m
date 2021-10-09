function Script()
    import Cell.*
    import Constants.*

    %Time modeling
    %Sould be already defined
        %Cell_list,Delta_Ve on each cell, hierarchy
    Cell1 = Cell("BP_on",[1,1,1]);
    Cell2 = Cell("BP_off", [0,1,0]);
    
    Cell1.pre_syn_subset = [2];
    Cell2.post_syn_subset = [1];
    Cell2.pre_syn_subset = [1];
    Cell1.post_syn_subset = [2];
    cell_list = [Cell1,Cell2];

    for cell = cell_list
        cell.Delta_Ve = 0; 
    end

    %Initialization at time t=0
    cell_list = initialization(cell_list);
    double t;
    %TIME LOOP
    for t = [Constants.time_step:Constants.time_step:Constants.simulation_duration-Constants.time_step]
        %Update Gsyns at time t=tau syn
        for cell = cell_list
            cell.Gsyn(t/Constants.time_step+1) = get_Gsyn(cell,cell_list,t);
        end
        %Update V_m at time tau_syn
        for cell = cell_list
            cell.V_m(t/Constants.time_step+1) = update_V_m(cell,t);
        end
        cell_list(1)
    end

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


function Gsyn = get_Gsyn(cell, cell_list, t)
    D = 50e-6;
    W = exp(-D/cell.sigma);
    g_syn = cell.g_min + (cell.g_max - cell.g_min)/(1+exp((cell_list(cell.pre_syn_subset).V_m((t-Constants.time_step)/Constants.time_step+1)-cell.V_50)/cell.beta));
    Gsyn = 1/W*g_syn*exp(-D/cell.sigma);
end

function V = update_V_m(Cell,t)
    syms V_m(k)
    b = (Cell.G_m *(Cell.E_rest +1/2*Cell.Delta_Ve)+Cell.Gsyn(t/Constants.time_step+1)*Cell.E_syn)/Cell.C_m;
    ode = diff(V_m,k) == -V_m(k) + b;
    cond = V_m(t-Constants.time_step) == Cell.V_m((t-Constants.time_step)/Constants.time_step+1);
    sol = dsolve(ode,cond);
    k = t;
    V = subs(sol);
end

function cell_list = initialization(cell_list)
    for cell = cell_list
        cell.V_m = ones(1,Constants.t_size)*rand*1e-3;
        cell.Gsyn = zeros(1,Constants.t_size);
    end
end

