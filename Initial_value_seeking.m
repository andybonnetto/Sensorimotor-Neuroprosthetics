function M_cells = Initial_value_seeking(cell_list,L,n_sim,M_init)
    import Temporal_modeling_matrix.*
    V_m_init = zeros(size(cell_list,2),n_sim);
    V_m_init_0 = zeros(size(cell_list,2),n_sim);
%     target_cell = 11000;
    for i = 1:n_sim
        disp(strcat("simulation ",num2str(i)));
        if nargin > 3
            M_cells = Temporal_modeling_matrix(cell_list,{M_init,[]},L);
        else
            M_cells = Temporal_modeling_matrix(cell_list,{[],[]},L);              
        end
        V_m_init_0(:,i) = M_cells.V_m(:,1);
        V_m_init(:,i) = M_cells.V_S(:,end);
    end

    assignin("base","V_m_init_0",V_m_init_0)
    assignin("base","V_m_init",V_m_init)
end