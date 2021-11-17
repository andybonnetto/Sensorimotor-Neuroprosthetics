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

    E_syn2
    g_min2
    g_max2
    V_502
    beta2
    g_syn2

    types
    Gsyn
    V_m
    Delta_Ve
    sigma
    IorD
    V_pre
    D


    N_types
    N_cells
    N_syn
    indices

    end
   
    methods
        function M = M(cell_list)
            import Constants.*

            M.types = ["Light-CR","CR-HRZ","HRZ-CR","CR-BP_on","CR-BP_off", "BP_on-AM_WF_on", "BP_off-AM_WF_off", "BP_on-AM_NF_on", "AM_WF_on-GL_on", "AM_WF_off*-GL_off", "AM_NF_off-GL_on","BP_on-GL_on","BP_off-GL_off"];
            M.IorD = [repmat("I", 1, size(M.types,2))];
            M.IorD(1) = "D"; M.IorD(4) = "D";
            M.indices = [2,1,2,1,1,1,1,1,2,2,2,1,1];
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
            M.V_m = zeros(M.N_cells);

            M.g_min = zeros(M.N_cells,M.N_types,M.N_syn);
            M.g_max = zeros(M.N_cells,M.N_types,M.N_syn);
            M.g_syn =  zeros(M.N_cells,M.N_types,M.N_syn);
            M.V_50 = zeros(M.N_cells, M.N_types, M.N_syn);
            M.beta = zeros(M.N_cells, M.N_types, M.N_syn);
            M.Gsyn = zeros(M.N_cells, M.N_types);
            M.V_pre = zeros(M.N_cells, M.N_types, M.N_syn);
            M.D = zeros(M.N_cells, M.N_types, M.N_syn);
            M.sigma = zeros(M.N_cells, M.N_types, M.N_syn);
            M.Delta_Ve = zeros(M.N_cells,Constants.t_size);

            M.g_min2 = zeros(M.N_cells,M.N_types,M.N_syn,2);
            M.E_syn2 = zeros(M.N_cells,M.N_types,2);
            M.g_max2 = zeros(M.N_cells,M.N_types,M.N_syn,2);
            M.g_syn2 =  zeros(M.N_cells,M.N_types,M.N_syn);
            M.V_502 = zeros(M.N_cells, M.N_types, M.N_syn,2);
            M.beta2 = ones(M.N_cells, M.N_types, M.N_syn,2);
            M = M.fill_with_cell_list(cell_list);
            M.E_syn =  sparse(M.E_syn2(:,:,1) + M.E_syn2(:,:,2));
            
        end
            

            
        function M = fill_with_cell_list(M, cell_list)
            % Fill matrices with values from cell_list
            i = 1;
            for cell = cell_list
                M.names(i) = cell.name;
                M.C_m(i) = cell.C_m;
                M.G_m(i) = cell.G_m;
                M.tau_rest(i) = cell.tau_rest;
                M.E_rest(i) = cell.E_rest;
                M.sigma(i,:,:) = repmat(cell.sigma, M.N_types, M.N_syn);
                
                j = 1;
                N_s = size(cell.pre_syn_subset,2);
                for type = M.types
                    post_syn_type = split(type, "-");
                    if cell.name == post_syn_type(2)
                        if M.IorD(j) == "I"
                            if cell.type(M.indices(j)) == "I"
                                M.E_syn2(i,j,1)= cell.E_syn(M.indices(j));

                                M.g_min2(i,j,1:N_s,1) = cell.g_min(M.indices(j))*ones(1,N_s);
                                M.g_max2(i,j,1:N_s,1) = cell.g_max(M.indices(j))*ones(1,N_s);
                                M.V_502(i,j,1:N_s,1) = cell.V_50(M.indices(j))*ones(1,N_s);
                                M.beta2(i,j,1:N_s,1) = cell.beta(M.indices(j))*ones(1,N_s);
                            end
        
                        else
                            if cell.type(M.indices(j)) == "D"
                                M.E_syn2(i,j,2) = cell.E_syn(M.indices(j));
        
                                M.g_min2(i,j,1:N_s,2) = cell.g_min(M.indices(j))*ones(1,N_s);
                                M.g_max2(i,j,1:N_s,2) = cell.g_min(M.indices(j))*ones(1,N_s);
                                M.V_502(i,j,1:N_s,2) = cell.V_50(M.indices(j))*ones(1,N_s);
                                M.beta2(i,j,1:N_s,2) = cell.beta(M.indices(j))*ones(1,N_s);
                            end
                        end
                        k = 1;
                        for pre_syn = cell.pre_syn_subset
                            if cell_list(pre_syn).name == post_syn_type(1)
                                M.D(i,j,k) = cell.dist_pre_syn_subset(k);
                                k = k +1;
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
            M.Gsyn(cones) = gmin*ones(1,sum(cones)) + (gmax-gmin)*(L_max - L(cones)) ;
        end

        function M = update_V_pre(M)
            M.V_pre(:,:,:) = repmat(M.V_m(:),1,M.N_types,M.N_syn);
        end
    end
end