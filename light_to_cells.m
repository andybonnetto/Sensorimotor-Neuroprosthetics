function L = light_to_cells(mat,n_CR,n_tot,mode,vis)
    list_of_modes = ["full-0", "full-1", "disk-plus-40", "disk-plus-100", "disk-minus-40", "disk-minus-100"];
    CR_mat = zeros(n_CR,3);
    um = 1e-6;
    L = zeros(1,n_tot);
    for i=1:n_CR
            CR_mat(i,:) = mat(i,:);
    end
    x_window = [-150*um 150*um];
    y_window = [-150*um 150*um];
    
    % 3 images -> Full 0, full 1, disk
    
    x = [-150*um, -150*um, 150*um, 150*um, -150*um];
    y = [-150*um, 150*um, 150*um, -150*um, -150*um];
    
    mode_names = split(mode,"-");
    if mode_names(1) == "full"
        ind = str2num(mode_names(2));
        color = ['k','w'];
        if vis
                % Figure
                figure(vis)
                line(x,y);
                hold on;
                fill(x,y,color(ind+1));
                xlabel('x [um]')
                ylabel('y [um]')
                title(mode)
        end

        % Stimulated cells
        if ind
            square_ind = (CR_mat(:,1)>=(-150*um))&(CR_mat(:,1)<=(150*um))&(CR_mat(:,2)>=(-150*um))&(CR_mat(:,2)<=(150*um));
            L(square_ind) = 1;
        end
        if vis
            % Figure
            figure(vis+1)
            for i=1:n_CR
                if L(i)==1
                    plot(CR_mat(i,1),CR_mat(i,2),'.','Color','k');
                    hold on;
                end
            end
            hold off;
            xlim(x_window)
            ylim(y_window)
            xlabel('x [um]')
            ylabel('y [um]')
            title(strcat('Stimulated cells for ', mode))
        end
    elseif mode_names(1) == "disk"
        val = 0.5;
        a = 1;
        if mode_names(2) == "minus"
            a = a*(-1); 
        end
        ind = str2num(mode_names(3));
        val = val + a*ind/200;

        % Disk of diameter 80 um            
            % Stimulation
            d_stim = 80*um;
            r_stim = d_stim/2;
            x_center = 0;
            y_center = 0;
            theta = linspace(0,2*pi);
            x = r_stim*cos(theta) + x_center;
            y = r_stim*sin(theta) + y_center;
            if vis
                % Figure
                figure(vis)
                set(gca,'Color',[0.5 0.5 0.5])
                xlim(x_window)
                ylim(y_window)
                line(x,y,'Color',[val, val, val]);
                hold on;
                fill(x,y,[val, val, val]);
                axis square
                xlabel('x [um]')
                ylabel('y [um]')
                title(strcat('Disk stimulation (Contrast = ',string(a*ind),'%)'))
            end
            % Stimulated cells

            disk_ind = sqrt(CR_mat(:,1).^2+CR_mat(:,2).^2) <= r_stim;
            L(disk_ind) = val;
            
            % L matrix containing light intensity for all cells and the four
            if vis
                % Figure
                figure(vis+1)
                for i=1:n_CR
                    if sqrt(CR_mat(i,1)^2+CR_mat(i,2)^2)<=r_stim
                        plot(CR_mat(i,1),CR_mat(i,2),'.','Color',[val, val, val]);
                        hold on;
                    end
                end
                hold off;
                set(gca,'Color',[0.5 0.5 0.5])
                xlim(x_window)
                ylim(y_window)
                axis square
                xlabel('x [um]')
                ylabel('y [um]')
                title(strcat('Stimulated cells for disk stimulation (Contrast = ', string(a*ind), '%)'))
            end
    else
        error(strcat("Mode not recognized, mode must be : ",list_of_modes))
    end
    assignin("base","L",L)
end


