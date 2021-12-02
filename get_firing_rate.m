function S = get_firing_rate(M_cells)
% Calculate ganglion cells firing rates at time t based on V_m([t]
    names = ["GL_on", "GL_off"];
    DV_0 = 5e-3;
    S = {zeros(size(M_cells.V_m(names(1),:))),zeros(size(M_cells.V_m(names(2),:)))};
    i = 1;
    for name = names 
        ganglions = M_cells.names == name;
        E_T = Cell(name, [0,0,0]).E_T;
        DV_t = max(zeros(size(M_cells.V_m(ganglions))),M_cells.V_m(ganglions,:)- E_T);
        n  = 2 + (0.1*DV_t).^2;
        S{i} = DV_t.^n./(DV_t.^n+DV_0.^n);
        i = i +1;
    end
end