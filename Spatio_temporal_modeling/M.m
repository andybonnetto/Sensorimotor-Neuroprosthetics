classdef M < handle
    properties
    names
    C_m
    G_m
    tau_rest
    E_rest

    E_syn
    g_min
    g_max
    V_50
    beta
    g_syn

    types
    Gsyn
    V_m
    Delta_Ve
    sigma
    IorD
    V_pre
    V_S
    D
    pre_syn_mat


    N_types
    N_cells
    N_syn
    indices

    end
   
    methods
        function M = M(cell_list)
            import Constants.*

            M.types = ["Light-CR","CR-HRZ","HRZ-CR","CR-BP_on","CR-BP_off", "BP_on-AM_WF_on", "BP_off-AM_WF_off", "BP_on-AM_NF_on", "AM_WF_on-GL_on", "AM_WF_off-GL_off", "AM_NF_on-GL_off","BP_on-GL_on","BP_off-GL_off"];
            M.IorD = [repmat("I", 1, size(M.types,2))];
            M.IorD(1) = "D"; M.IorD(4) = "D";
            M.indices = [1,1,2,1,1,1,1,1,2,2,3,1,1];
            M.indices = gpuArray(M.indices);
            
            M.N_types = size(M.types,2);
%             M.N_syn = 100; %Maximum estimation of number of synapses
            M.N_syn = 0;
            for cell = cell_list
                if size(cell.pre_syn_subset,2) > M.N_syn
                    M.N_syn = size(cell.pre_syn_subset,2);
                end
            end
            M.N_cells = size(cell_list,2);
            M.names = [repmat("", 1, M.N_cells)];
            M.C_m = sparse(M.N_cells,1);
            M.G_m = sparse(M.N_cells,1);
            M.tau_rest = sparse(M.N_cells,1);
            M.E_rest = sparse(M.N_cells,1);
            M.V_m = zeros(M.N_cells,Constants.t_size);
            M.V_S = zeros(M.N_cells,Constants.t_size);

            M.g_syn =  zeros(M.N_cells, M.N_types, M.N_syn);
            M.V_50 = zeros(M.N_types,1);
            M.beta = zeros(M.N_types,1);
            M.g_min = zeros(M.N_types,1);
            M.g_max = zeros(M.N_types,1);
            M.Gsyn = sparse(M.N_cells, M.N_types);
            M.V_pre = zeros(M.N_cells, M.N_types, M.N_syn);
            M.D = Inf(M.N_cells, M.N_types, M.N_syn);
            M.sigma = zeros(M.N_cells, M.N_types, M.N_syn);
            M.Delta_Ve = zeros(M.N_cells,Constants.t_size);

            M.pre_syn_mat = zeros(M.N_cells,M.N_types,M.N_syn);
            M.E_syn = zeros(M.N_types,1);

            M = M.fill_with_cell_list(cell_list);
            
        end
            

            
        function M = fill_with_cell_list(M, cell_list)
            % Fill matrices with values from cell_list
            import Cell.*
            
            j = 1;
            for type = M.types
                post_syn_type = split(type, "-");
                post_syn_cell = Cell(post_syn_type(2),[0,0,0]);
                M.g_min(j) = post_syn_cell.g_min(M.indices(j));
                M.g_max(j) = post_syn_cell.g_max(M.indices(j));
                M.V_50(j) = post_syn_cell.V_50(M.indices(j));
                M.beta(j) = post_syn_cell.beta(M.indices(j));
                M.E_syn(j) = post_syn_cell.E_syn(M.indices(j));
                j = j+1;
            end
            i = 1;
            for cell = cell_list
%                 disp(num2str(i))
                M.names(i) = cell.name;
                M.C_m(i) = cell.C_m;
                M.G_m(i) = cell.G_m;
                M.tau_rest(i) = cell.tau_rest;
                M.E_rest(i) = cell.E_rest;
                M.sigma(i,:,:) = repmat(cell.sigma, M.N_types, M.N_syn);
                
                j = 1;
                for type = M.types
                    post_syn_type = split(type, "-");
                    if cell.name == post_syn_type(2)
                        k = 1;
                        for pre_syn = cell.pre_syn_subset
                            if pre_syn < length(cell_list)
                                if cell_list(pre_syn).name == post_syn_type(1)
                                    M.D(i,j,k) = cell.dist_pre_syn_subset(k);
                                    M.pre_syn_mat(i,j,k) = cell.pre_syn_subset(k);
                                    k = k +1;
                                end 
                            end
                        end
                    end 
                j = j+1;
                end
            i = i + 1;
            end    
        end

        function M = add_light_syn(M,L)
            % L of size N_cells (Constant image)
            % Import L(t) from file to be consistant with t sized matrices
            import Cell.*
            cones = M.names == "CR";
            gmax = Cell("CR",[0,0,0]).g_max(1);
            gmin = Cell("CR",[0,0,0]).g_min(1);
            L_max = 1;
            M.g_syn(cones,1,:) = repmat(gmin*(1-(L_max - L)) + gmax*(L_max - L),1,M.N_syn);
            M.D(cones,1,:) = 0;
        end

        function M = update_V_pre(M,t)
            if t-Constants.time_coeff < 1
                t = Constants.time_coeff+1;
            end
            not_zero = not(M.pre_syn_mat == 0);
            M.V_pre = -Inf(M.N_cells, M.N_types, M.N_syn);
            M.V_pre(not_zero) = M.V_m(M.pre_syn_mat(not_zero),t-Constants.time_coeff);
        end
    end
end