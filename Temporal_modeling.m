function Temporal_modeling(cell_list_s)
% Temporal modeling runs the time loop while updating membrane potentials
% of each cells in cell_list. The firing rate is also calculated at each
% time step for Ganglion cells.
% Simulation duration and time constants are stored in Constants.m
% Cell object definition are declared in Cell.m

    import Cell.*
    import Constants.*

    %Defined in FEM and Spatial_modeling
        %Cell list generation
%     Cell1 = Cell("GL_off",[0,0,0]);
%     Cell2 = Cell("BP_on", [0,0,0]);
%     Cell3 = Cell("AM_NF_on", [0,0,0]);
% 
%     Cell1.pre_syn_subset = [2,3];
%     Cell1.post_syn_subset = [2];
%     Cell2.post_syn_subset = [1];
%     Cell2.pre_syn_subset = [1];
%     Cell3.post_syn_subset = [1];
%     Cell3.pre_syn_subset = [];
%     cell_list = [Cell1,Cell2,Cell3];

%     cell_list = loadobj("cell_list.mat");
%     cell_list(1)
        % Extracelullar voltage generation
        cell_list = cell_list_s;
    for cell = cell_list
        cell.Delta_Ve = 0; 
    end

    %Initialization at time t=0
    cell_list = initialization(cell_list); %Random values of V_m for each cell
    double t;
    %Time loop
        for i = [2:Constants.t_size]
            %Update Gsyns at time t=tau syn
            for cell = cell_list
                for syn = 1:length(cell.pre_syn_subset)
                    cell.Gsyn(syn,i) = get_Gsyn(cell,cell_list,i, syn);
                end
            end
            %Update V_m at time t=tau_syn
            p = 0;
            for cell = cell_list
%                 p
%                 length(cell_list)
%                 cell.name
                start = i*Constants.time_coeff-(Constants.time_coeff-1);
                stop = start + Constants.time_coeff - 1;
                cell.V_m(start:stop) = update_V_m(cell_list,cell,i);
                p = p +1;
                
            end
            i
%             length(cell_list)
        end

    save_cell_list(cell_list)
    %Visualization
        %G_syn visualization
    f1 = figure();
    t = linspace(Constants.tau_syn,Constants.simulation_duration,Constants.t_size);
    plot(t(2:end),cell_list(6338).Gsyn(1,2:end))
        %V_m visualization
    t = linspace(0,Constants.simulation_duration,Constants.t_size*Constants.time_coeff);
    f2 = figure();
    plot(t,cell_list(3548).V_m)
    hold on 
    plot(t,cell_list(6338).V_m)
    hold on
    plot(t,cell_list(9908).V_m)
    title("Membrane potential")
    xlabel("Time [seconds]")
    ylabel("Voltage [V]")
    legend({cell_list(3548).name,cell_list(6338).name,cell_list(9908).name})


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
% Update Gsyn value of given cell based on presynaptic inputs at time
% t-tau_syn.
% Inputs :  cell : Cell obj investigated
%           cell_list : List of Cell obj
%           i : current time index
%           syn: syn index with respect to pre_syn_subset of given cell
% Outputs : Gsyn = unsigned scalar value -> must be assigned to cell.Gsyn
    
    % Initialization
    i= double(i);
    D = cell.dist_pre_syn_subset(syn);
    W = exp(-D/cell.sigma);
    pre_syn = cell_list(cell.pre_syn_subset(syn));
    
    % Get excitatory or inhibitory index
    ind = get_syn_ind(cell,pre_syn);
    
    % Calculation of g_syn
    if cell.type(ind) == "D"
        g_syn = cell.g_min(ind) + (cell.g_max(ind) - cell.g_min(ind))*(1-1/((1+exp(pre_syn.V_m(i*Constants.time_coeff-(Constants.time_coeff-1)-1)-cell.V_50(ind)))/cell.beta(ind)));
    elseif cell.type(ind) == "I"
        g_syn = cell.g_min(ind) + (cell.g_max(ind) - cell.g_min(ind))/((1+exp(pre_syn.V_m(i*Constants.time_coeff-(Constants.time_coeff-1)-1)-cell.V_50(ind)))/cell.beta(ind));
    end

    % Calculation of Gsyn 
    Gsyn = 1/W*g_syn*exp(-D/cell.sigma);
end

function ind = get_syn_ind(cell,pre_syn)
% Get excitatory or Inhibitory index : 1 : Excitatory; 2 : Inhibitory
% Used to reach the right values in Cell object depending on Synapses
% Inputs :  cell : Cell obj investigated
%           pre_syn : Cell obj, presynaptic neuron of cell
% Outputs : ind : 1 or 2 for Excitatory or Inhibitory respectively, ind 3
% is for special case from AM_NF_on to GL_off inhibitory connection.

% Only CR, GL and BP_on cells have inhibitory inputs
    ind = 1;
    if cell.name == "CR"
        ind = 2;
    elseif cell.name == "GL_on" || cell.name == "GL_off"
        if cell.name == "GL_off" && pre_syn.name == "AM_NF_on"
            ind = 3;
        elseif pre_syn.name == "AM_WF_off" || pre_syn.name == "AM_WF_on" || pre_syn.name == "AM_NF_on"
            ind = 2;
        end
    end
end

function V = update_V_m(cell_list,Cell,i)
% Update membrane potential of given cell using first order differential
% equation. Results are calculated at every tau_syn in time_steps and given
% in a list of scalars.
% Inputs :   cell_list : list of cell obj
%            Cell : cell obj invastigated
%            i : current time index
% Outputs :  V : List of Constants.time_coeff unsigned scalar elements
    
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
% Initialization of membrane potential and synaptic conductances
% Must be later change to initial values 
    for cell = cell_list
        cell.V_m = (ones(1,Constants.t_size*Constants.time_coeff)*rand*(-100e-3));
        cell.Gsyn = (zeros(length(cell.pre_syn_subset),Constants.t_size));
    end
end

function S = get_firing_rate(cell,i)
% Calculate firing rate of ganglion cells base on their membrane potential
    delta_V0 = 5e-3;
    delta_V = max(0,(cell.V_m(i)-cell.E_T));
    n = 2 + (0.1*delta_V)^2;
    S = (delta_V^n)/(delta_V^n + delta_V0^n);
end

function save_cell_list(cell_list)
    save('Temporal_model_cell_list','cell_list','-mat')
    assignin("base","temp_cell_list",cell_list)
end

