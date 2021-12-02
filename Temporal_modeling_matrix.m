function M_cells = Temporal_modeling_matrix(cell_list,init,L)
% Run the temporal modeling of cells in cell_list by converting into
% matrix of class M and running differential equations from Cottaris 2005.
% Simulation parameters are stored in Constants.m structure.
% Input : cell_list : struct of cell classes with spatial informations
%         init : {[M_init,V_m_init]}, if cell_list to matrice conversion
%         already done, can skip initial steps by using M_init; If resting
%         voltage already known, can use V_init
% Output : M_cells :  struc of matrices with temporal variables such as
% membrane potential V_m(t) or Firing rate of ganglion cells S(t)

    import M.*
    import Constants.*

    if nargin < 2
        M_init = [];
        V_m_init = [];
    else
        M_init = init{1};
        V_m_init = init{2};
    end

    if isempty(M_init)
        M_cells = M(cell_list);
        assignin("base","M_init",M_cells)
        disp("Done copying datas from cell_list")
    else
        M_cells = M_init;
    end

    if isempty(V_m_init)
        M_cells = initialization(M_cells);
    else
        M_cells = initialization(M_cells,V_m_init);
    end
    w = waitbar(0, "Please wait...");
    for t = 1:Constants.t_size
        waitbar(double(t)/double(Constants.t_size),w,"Update your V_m...")
        if t == 40
            disp("hey")
        end
        M_cells = get_Gsyn(M_cells,L,t);
        M_cells = update_V_m(M_cells,t);
    end
    if isempty(V_m_init)
        V_m_init = M_cells.V_S(:,end);
    end
    close(w);
    assignin("base","V_m_init",V_m_init)
    assignin("base","M_cells",M_cells)

end

function M_cells = initialization(M_cells,V_m_init)
% Membrane potential initialization for t = 0, if initial values not
% specied, generates random values.
    if nargin < 2
        M_cells.V_m = ones(M_cells.N_cells,Constants.t_size)*(-30e-3);
%         M_cells.V_m = rand(M_cells.N_cells, Constants.t_size)*(-100e-3);
    else
        M_cells.V_m(:,1) = V_m_init;
    end

%     M_cells.Delta_Ve = ones(M_cells.N_cells,Constants.t_size)*(100e-3);
end

function M_cells = get_Gsyn(M_cells,L,t)
% Compute Gsyn at time t for light protocol L.
   
    M_cells = M_cells.update_V_pre(t);
    M_cells = M_cells.add_light_syn(L(:,t));
    i = 2;
    for type = M_cells.types(2:end)

        syns = split(type, '-');
        population = M_cells.names == syns(2);

        E = 1./(1+exp((M_cells.V_pre(population,i,:)-M_cells.V_50(i))/(M_cells.beta(i))));
        if M_cells.IorD(i) == "I"
            M_cells.g_syn(population,i,:) = M_cells.g_min(i)*(E)+ M_cells.g_max(i)*(1-E);
        else
            M_cells.g_syn(population,i,:) = M_cells.g_min(i)*(1-E) + M_cells.g_max(i)*E;
        end
        i = i+1;
    end
%     cones = M_cells.names == "CR";
    W = sum(exp(-M_cells.D ./ M_cells.sigma),3);
    not_zero = not(W==0);
    S = sum(M_cells.g_syn.* exp(-M_cells.D ./ M_cells.sigma),3);
    M_cells.Gsyn(not_zero) = (1./W(not_zero)) .* S(not_zero);
%     M_cells.Gsyn(cones,:) = sum(M_cells.g_syn(cones,:,:),3);
end

function M_cells = update_V_m(M_cells,t)
% Update membrane potential V_m[t+1] from Gsyn and V_m at time t
    G_tot = M_cells.G_m + sum(M_cells.Gsyn,2);
    tau_m = M_cells.C_m ./ G_tot;
    dt = Constants.time_step;
    diag_E_syn = diag(M_cells.E_syn,0);
    M_cells.V_S(:,t) = (1 ./ G_tot) .* (M_cells.G_m .* M_cells.E_rest + 0.5*M_cells.Delta_Ve(:,t) .* M_cells.G_m + sum(M_cells.Gsyn*diag_E_syn,2));
    dV = (-dt./tau_m).*M_cells.V_m(:,t) + (dt./tau_m).*M_cells.V_S(:,t);
    M_cells.V_m(:,t+1) =  dV + M_cells.V_m(:,t) ;
end

