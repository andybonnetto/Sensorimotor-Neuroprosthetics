function Script()
    import Cell.*
    import Constants.*

    %Time modeling
    %Sould be already defined
        %Cell_list,Delta_Ve on each cell, hierarchy
    Cell1 = Cell("CR",[1,1,1]);
    Cell2 = Cell("BP_on", [0,1,0]);
    Cell3 = Cell("HRZ", [0,0,3]);

    Cell1.pre_syn_subset = [2,3];
    Cell1.post_syn_subset = [2];
    Cell2.post_syn_subset = [1];
    Cell2.pre_syn_subset = [1];
    Cell3.post_syn_subset = [1];
    Cell3.pre_syn_subset = [];
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
    hold on 
    plot(cell_list(2).V_m)
    hold on
    plot(cell_list(3).V_m)

%     Ganglion Cell pseudo sigmoid tests
%     GCell = Cell("GL_on", [1,1,1]);
%     array = zeros(1,50);
%     j = 1;
%     for i = linspace(-55e-3,-30e-3,50)
%         GCell.V_m = [i];
%         S = get_firing_rate(GCell,1);
%         array(j)= S;
%         j = j+ 1;
%     end
%     plot(linspace(-55e-3,-30e-3,50), array)
%     end
%     
%     function Gsyn = calculate_Gsyn_light(Source,cell)
%         L = Source.get_itensity(cell.x,cell.y);
%         Gsyn = cell.g_min + (cell.g_max - cell.g_min)*(Source.L_max-L); 
    end


function Gsyn = get_Gsyn(cell, cell_list, i, syn)
    i= double(i);
    D = 100e-6;
    W = exp(-D/cell.sigma);
    pre_syn = cell_list(cell.pre_syn_subset(syn));
    
    ind = get_syn_ind(cell,pre_syn);

    if cell.type(ind) == "D"
        g_syn = cell.g_min(ind) + (cell.g_max(ind) - cell.g_min(ind))*(1-1/((1+exp(pre_syn.V_m(i*Constants.time_coeff-(Constants.time_coeff-1)-1)-cell.V_50(ind)))/cell.beta(ind)));
    elseif cell.type(ind) == "I"
        g_syn = cell.g_min(ind) + (cell.g_max(ind) - cell.g_min(ind))/((1+exp(pre_syn.V_m(i*Constants.time_coeff-(Constants.time_coeff-1)-1)-cell.V_50(ind)))/cell.beta(ind));
    end
    Gsyn = 1/W*g_syn*exp(-D/cell.sigma);
    
    if ind == 2
        Gsyn = -Gsyn;
    end
end

function ind = get_syn_ind(cell,pre_syn)
     if cell.name == "CR"
        ind = 2;
    elseif cell.name == "GL_on" || cell.name == "GL_off"
        if pre_syn.name == "AM_WF_off" || pre_syn.name == "AM_WF_on" || pre_syn.name == "AM_NF_on"
            ind = 2;
        end
    elseif cell.name == "BP_on"
        ind = 2;
    else
        ind = 1;
     end
end

function V = update_V_m(cell_list,Cell,i)
    syms V_m(k)
    l = 1;
    tot = 0;
    for j = Cell.pre_syn_subset
        ind = get_syn_ind(Cell,cell_list(j));
        tot = tot + Cell.E_syn(ind)*Cell.Gsyn(l,i);
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
        cell.V_m = ones(1,Constants.t_size*Constants.time_coeff)*rand*(-0.7);
        cell.Gsyn = zeros(length(cell.pre_syn_subset),Constants.t_size);
    end
end

function S = get_firing_rate(cell,i)
    delta_V0 = 5e-3;
    delta_V = max(0,(cell.V_m(i)-cell.E_T));
    delta_V
    n = 2 + (0.1*delta_V)^2;
    S = (delta_V^n)/(delta_V^n + delta_V0^n);
end

