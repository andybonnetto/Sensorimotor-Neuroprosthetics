function S = get_firing_rate(M_cells,vis,path_to_folder,new_threshold,subset)
% Calculate ganglion cells firing rates at time t based on V_m([t]
    names = ["GL_on", "GL_off"];
    name_ind{1} = M_cells.names == names(1);
    name_ind{2} = M_cells.names == names(2);
    DV_0 = 5e-3;
    S = {zeros(size(M_cells.V_m(name_ind{1},:))),zeros(size(M_cells.V_m(name_ind{2},:)))};
    i = 1;
    for name = names 
        ganglions = M_cells.names == name;
        E_T = Cell(name, [0,0,0]).E_T;
        if nargin > 3
            E_T = new_threshold(i);
        end
        DV_t = max(zeros(size(M_cells.V_m(ganglions,:))),M_cells.V_m(ganglions,:)- E_T);
        n  = 2 + (0.1*DV_t).^2;
        S{i} = DV_t.^n./(DV_t.^n+DV_0.^n);
        i = i +1;
    end
%     S = {sum(S{1},1)/size(S{1},1),sum(S{2},1)/size(S{2},1)};
    
    if vis == 1
        if not(isempty(subset))
            figure()
            subplot(1,2,1)
            plot(linspace(0,Constants.simulation_duration,Constants.t_size+1),S{1}(subset(name_ind{1}),:))
            ylim([0 1])
            xlabel('Time ')
            ylabel('Average firing rate')
            title('Average firing rate of GL_on')
    
            subplot(1,2,2)
            plot(linspace(0,Constants.simulation_duration,Constants.t_size+1),S{2}(subset(name_ind{2}),:))
            ylim([0 1])
            xlabel('Time ')
            ylabel('Average firing rate')
            title('Average firing rate of GL_off')
            
            file = "Firing rate";
            saveas(gcf,strcat(path_to_folder,file))

        else
            figure()
            subplot(1,2,1)
            plot(linspace(0,Constants.simulation_duration,Constants.t_size+1),S{1})
            ylim([0 1])
            xlabel('Time ')
            ylabel('Average firing rate')
            title('Average firing rate of GL_on')
    
            subplot(1,2,2)
            plot(linspace(0,Constants.simulation_duration,Constants.t_size+1),S{2})
            ylim([0 1])
            xlabel('Time ')
            ylabel('Average firing rate')
            title('Average firing rate of GL_off')
            
            file = "Firing rate";
            saveas(gcf,strcat(path_to_folder,file))
        end
    end
    
end