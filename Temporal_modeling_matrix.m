function Temporal_modeling_matrix(cell_list, M_init)
    import M.*
    import Constants.*

    if nargin < 2
        M_cells = M(cell_list);
        assignin("base","M_init",M_cells)
    else
        M_cells = M_init;
    end
    "Done copying datas from cell_list"
    M_cells = initialization(M_cells);
    
    for t = [2:Constants.t_size]
        t
        M_cells = get_Gsyn(M_cells,t);
        M_cells = update_V_m(M_cells,t);
    end

    assignin("base","M_cells",M_cells)   
end

function M_cells = initialization(M_cells)
    M_cells.V_m = zeros(M_cells.N_cells, Constants.t_size*Constants.time_coeff);
    M_cells.V_m(:,1:Constants.time_coeff) = randn(M_cells.N_cells,Constants.time_coeff)*(-100e-3);
end

function M_cells = get_Gsyn(M_cells,t)
    M_cells = M_cells.update_V_pre(t);
    X1 = (M_cells.V_pre - M_cells.V_502(:,:,:,1))./M_cells.beta2(:,:,:,1);
    X2 = (M_cells.V_pre - M_cells.V_502(:,:,:,2))./M_cells.beta2(:,:,:,2);
    I = ones(size(X1));
    M_cells.g_syn2(:,:,:,1) = M_cells.g_min2(:,:,:,1) + (M_cells.g_max2(:,:,:,1) - M_cells.g_min2(:,:,:,1)).*(I-I./(I+exp(X1)));
    M_cells.g_syn2(:,:,:,2) = M_cells.g_min2(:,:,:,2) + (M_cells.g_max2(:,:,:,2) - M_cells.g_min2(:,:,:,2)).*(I./(I+exp(X2)));
    M_cells.g_syn(:,:,:,t) = M_cells.g_syn2(:,:,:,1) + M_cells.g_syn2(:,:,:,2);
    
    W = sum(exp(-M_cells.D ./ M_cells.sigma),3);
    I = ones(size(W));
    M_cells.Gsyn(:,:,t) = I./W .* sum(M_cells.g_syn(:,:,:,t) .* exp(-M_cells.D ./ M_cells.sigma),3);

end

function M_cells = update_V_m(M_cells,t)

    G_tot = M_cells.G_m + sum(M_cells.Gsyn(:,:,t),2);
    I = ones(M_cells.N_cells,1);
    V_s = I ./ G_tot .* (M_cells.G_m .* M_cells.E_rest + M_cells.Delta_Ve(:,t) .* M_cells.G_m + sum(M_cells.Gsyn(:,:,t) .* M_cells.E_syn,2));
    M_cells.V_m(:,t) = (- repmat(Constants.tau_syn,M_cells.N_cells,1)./M_cells.tau_rest).*M_cells.V_m(:,t-1) + (repmat(Constants.tau_syn,M_cells.N_cells,1)./M_cells.tau_rest).*V_s;

end