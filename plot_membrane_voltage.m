function plot_membrane_voltage(M_cells,mat3D)
    import Constants.*
    figure()
    k = 1;
    names = ["CR","HRZ","BP_on","BP_off","AM_WF_on","AM_WF_off","AM_NF_on","GL_on","GL_off"];
    for name = names
        subplot(3,3,k);
        type = M_cells.names == name;
        x = mat3D(type,1);
        y = mat3D(type,2);
%         pcolor(x,y,M_cells.V_m(type,:))

        k = k+1;
    end

    figure()
    k=1;
    for name = names
        subplot(3,3,k);
        type = M_cells.names == name;
        x = mat3D(type,1);
        y = mat3D(type,2);
        z = mat3D(type,3);
        t = linspace(0,Constants.time_steps,Constants.t_size+1);
        pcolor(x,t,M_cells.V_m(type,:))
    end
end