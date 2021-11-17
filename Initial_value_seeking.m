function M_cells = Initial_value_seeking(cell_list,L,M_init,pfile)
    import Temporal_modeling_matrix.*
    n_sim = 50;
    V_m_init = zeros(size(cell_list,2),n_sim);
    V_m_init_0 = zeros(size(cell_list,2),n_sim);
%     target_cell = 11000;
    for i = 1:n_sim
        disp(strcat("simulation ",num2str(i)));
        if nargin >= 3
            [M_cells,V_0] = Temporal_modeling_matrix(cell_list,{M_init,[]},L,pfile);
        else
            [M_cells,V_0] = Temporal_modeling_matrix(cell_list,{[],[]},L,pfile);              
        end
        V_m_init_0(:,i) = V_0;
        V_m_init(:,i) = M_cells.V_m(:);
    end

    assignin("base","V_m_init_0",V_m_init_0)
    assignin("base","V_m_init",V_m_init)
end