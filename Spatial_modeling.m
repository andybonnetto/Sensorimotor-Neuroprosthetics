function Spatial_modeling(vis)
    import Cell.*
    % Spatial Modeling

    % Parameters
    um = 1e-6;
    lambda = [2.5,7,3.85,3.85,8,8,6,6,6].*um;
     %1;
%     sigma = [2.5,10.5,3.85,3.85,24,24,6,6,6].*um;
    sigma = [2.5,10.5,3.85,3.85,24,24,6,6,6].*um;
    noise = zeros(size(sigma)); %lambda/3/um;
    z_min = [170,100,100,100,80,80,80,25,25].*um;
    z_max = [205,128,128,128,101,101,101,39,39].*um;
    n = [4105,537,1741,1741,391,391,721,721,721];
    
    % Attribute one position to each cell and visualize the layers
    cell_pos = create_pos(noise,lambda,sigma,z_min,z_max,n,um,vis);
    
    %Save cell_pos in a mat file
    save_pos(cell_pos)

    % Redefine the number of cells for each population
    n = [4225,529,1681,1681,361,361,729,729,729];
    assignin("base","n_CR",n(1));

    % Create a list with each cell properties and xyz position
    cell_list = create_list(cell_pos,n);

    % Connect the population of cells through synapses and visualize the
    % connections
    cell_list = connection_syn(cell_list,cell_pos,sigma,n,um);

    % Visualize one cell with its connections
%     visualize_connection_syn_all_pop(cell_list,um);
    
    %Save cell_list in a MAT-file 
    save_cell_list(cell_list)
end

%%%%% Function lattice_generation %%%%%
function p = lattice_generation(size, spacing, sigma, noise)
    K = [];
    N = [];
    for i = size
        for j = size
            param = [i,j];
            n = noise*normrnd([0,0],sigma/3);
            K = vertcat(K, param);
            N = vertcat(N,n);
        end
    end
    M = [1, sqrt(3);1, -sqrt(3)]*spacing;
    p = K*M + N;
end

%%%%% Function cell_pos %%%%%
function cell_pos = create_pos(noise,lambda,sigma,z_min,z_max,n,um,vis)

    % CR cells matrix
    CR_pos = unique_pos(noise,lambda,sigma,z_min,z_max,n,1);

    % HRZ cells matrix
    HRZ_pos = unique_pos(noise,lambda,sigma,z_min,z_max,n,2);

    % BP_on cells matrix
    BP_on_pos = unique_pos(noise,lambda,sigma,z_min,z_max,n,3);

    % BP_off cells matrix
    BP_off_pos = unique_pos(noise,lambda,sigma,z_min,z_max,n,4);

    % AM_WF_on cells matrix
    AM_WF_on_pos = unique_pos(noise,lambda,sigma,z_min,z_max,n,5);

    % AM_WF_off cells matrix
    AM_WF_off_pos = unique_pos(noise,lambda,sigma,z_min,z_max,n,6);

    % AM_NF_on cells matrix
    AM_NF_on_pos = unique_pos(noise,lambda,sigma,z_min,z_max,n,7);

    % GL_on cells matrix
    GL_on_pos = unique_pos(noise,lambda,sigma,z_min,z_max,n,8);

    % GL_off cells matrix
    GL_off_pos = unique_pos(noise,lambda,sigma,z_min,z_max,n,9);
    
    cell_pos = vertcat(CR_pos,HRZ_pos,BP_on_pos,BP_off_pos,AM_WF_on_pos,AM_WF_off_pos,AM_NF_on_pos,GL_on_pos,GL_off_pos);
    if vis
        plot_layers(sigma,cell_pos,CR_pos,HRZ_pos,BP_on_pos,BP_off_pos,AM_WF_on_pos,AM_WF_off_pos,AM_NF_on_pos,GL_on_pos,GL_off_pos,um);
    end
end

%%%%% Function position %%%%%
function position = unique_pos(noise,lambda,sigma,z_min,z_max,n,i)

    size_matrix = sqrt(n(i));
    index = -floor(size_matrix/2):floor(size_matrix/2);
    xy = lattice_generation(index,lambda(i),sigma(i),noise(i));
    n_matrix = size(index,2)^2;
    z = z_min(i) + (z_max(i)-z_min(i)).*rand(n_matrix,1);
    position = horzcat(xy,z);

end

%%%%% Function visualization_pos %%%%%
function plot_layers(sigma,cell_pos,CR_pos,HRZ_pos,BP_on_pos,BP_off_pos,AM_WF_on_pos,AM_WF_off_pos,AM_NF_on_pos,GL_on_pos,GL_off_pos,um)
    ALL_pos = {CR_pos,HRZ_pos,BP_on_pos,BP_off_pos,AM_WF_on_pos,AM_WF_off_pos,AM_NF_on_pos,GL_on_pos, GL_off_pos};
    figure()
    xlim([-200*um 200*um])
    ylim([-400*um 400*um])
    zlim([0*um 210*um])
    plot3(CR_pos(:,1)/um,CR_pos(:,2)/um,CR_pos(:,3)/um,'.','Color','k');                         % CR = BLACK
    hold on
    plot3(HRZ_pos(:,1)/um,HRZ_pos(:,2)/um,HRZ_pos(:,3)/um,'.','Color','r');                      % HRZ = RED
    hold on
    plot3(BP_on_pos(:,1)/um,BP_on_pos(:,2)/um,BP_on_pos(:,3)/um,'.','Color','b');                % BP = BLUE
    hold on
    plot3(BP_off_pos(:,1)/um,BP_off_pos(:,2)/um,BP_off_pos(:,3)/um,'.','Color','b');
    hold on
    plot3(AM_WF_on_pos(:,1)/um,AM_WF_on_pos(:,2)/um,AM_WF_on_pos(:,3)/um,'.','Color','g');       % AM = GREEN
    hold on
    plot3(AM_WF_off_pos(:,1)/um,AM_WF_off_pos(:,2)/um,AM_WF_off_pos(:,3)/um,'.','Color','g');
    hold on
    plot3(AM_NF_on_pos(:,1)/um,AM_NF_on_pos(:,2)/um,AM_NF_on_pos(:,3)/um,'.','Color','g');
    hold on
    plot3(GL_on_pos(:,1)/um,GL_on_pos(:,2)/um,GL_on_pos(:,3)/um,'.','Color','y');                % GL = YELLOW
    hold on
    plot3(GL_off_pos(:,1)/um,GL_off_pos(:,2)/um,GL_off_pos(:,3)/um,'.','Color','y');
    xlabel('x-axis [µm]')
    ylabel('y-axis [µm]')
    zlabel('z-axis [µm]')
    legend('CR', 'HRZ', 'BP', 'AM', 'GL')

    names = ["CR","HRZ","BP_on","BP_off","AM_WF_on","AM_WF_off","AM_NF_on","GL_on","GL_off"];
    
    figure()
    k = 1;
    for name = names
        subplot(3, 3, k)
        viscircles(ALL_pos{k}(:,1:2), ones(size(ALL_pos{k},1),1) * sigma(k), 'LineWidth', 0.5, 'Color', 'k');
        xlim([-100e-6, 100e-6])
        ylim([-100e-6, 100e-6])
        title(name)
        axis equal
        k = k+1;
    end
end

%%%%% Function cell_list %%%%%
function cell_list = create_list(cell_pos,n)

    cell_list = [];

    for i=1:n(1)
        cell(i)=Cell('CR',[cell_pos(i,1),cell_pos(i,2),cell_pos(i,3)]);
        cell_list = [cell_list,cell(i)];
    end

    for i=1:n(2)
        k = i+n(1);
        cell(k)=Cell('HRZ',[cell_pos(k,1),cell_pos(k,2),cell_pos(k,3)]);
        cell_list = [cell_list,cell(k)];
    end

    for i=1:n(3)
        k = i+n(1)+n(2);
        cell(k)=Cell('BP_on',[cell_pos(k,1),cell_pos(k,2),cell_pos(k,3)]);
        cell_list = [cell_list,cell(k)];
    end
    
    for i=1:n(4)
        k = i+n(1)+n(2)+n(3);
        cell(k)=Cell('BP_off',[cell_pos(k,1),cell_pos(k,2),cell_pos(k,3)]);
        cell_list = [cell_list,cell(k)];
    end

    for i=1:n(5)
        k = i+n(1)+n(2)+n(3)+n(4);
        cell(k)=Cell('AM_WF_on',[cell_pos(k,1),cell_pos(k,2),cell_pos(k,3)]);
        cell_list = [cell_list,cell(k)];
    end

    for i=1:n(6)
        k = i+n(1)+n(2)+n(3)+n(4)+n(5);
        cell(k)=Cell('AM_WF_off',[cell_pos(k,1),cell_pos(k,2),cell_pos(k,3)]);
        cell_list = [cell_list,cell(k)];
    end

    for i=1:n(7)
        k = i+n(1)+n(2)+n(3)+n(4)+n(5)+n(6);
        cell(k)=Cell('AM_NF_on',[cell_pos(k,1),cell_pos(k,2),cell_pos(k,3)]);
        cell_list = [cell_list,cell(k)];
    end

    for i=1:n(8)
        k = i+n(1)+n(2)+n(3)+n(4)+n(5)+n(6)+n(7);
        cell(k)=Cell('GL_on',[cell_pos(k,1),cell_pos(k,2),cell_pos(k,3)]);
        cell_list = [cell_list,cell(k)];
    end

    for i=1:n(9)
        k = i+n(1)+n(2)+n(3)+n(4)+n(5)+n(6)+n(7)+n(8);
        cell(k)=Cell('GL_off',[cell_pos(k,1),cell_pos(k,2),cell_pos(k,3)]);
        cell_list = [cell_list,cell(k)];
    end
end

%%%%% Function euclidian_distance %%%%%
function d = euclidian_distance(p,p0)

    d = sqrt(sum((p - p0) .^ 2));

end

%%%%% Function connection_syn %%%%%
function cell_list = connection_syn(cell_list,cell_pos,sigma,n,um)

    n_tot = n(1)+n(2)+n(3)+n(4)+n(5)+n(6)+n(7)+n(8)+n(9);
    z_extent = 105*um;

% Connection between CR ...
    for i=1:n(1)
        % ... and HRZ, BP_on, BP_off
        k=1;
        for j=(n(1)+1):(n(1)+n(2)+n(3)+n(4))
            xy0 = [cell_pos(i,1),cell_pos(i,2)];
            xy = [cell_pos(j,1),cell_pos(j,2)];
            dist_xy = euclidian_distance(xy,xy0);
            z0 = cell_pos(i,3);
            z = cell_pos(j,3);
            dist_z = euclidian_distance(z,z0);
            if dist_xy<sigma(1)*3 && dist_z<z_extent
                cell_list(i).post_syn_subset(k) = j;
                p0 = [xy0,z0];
                p = [xy,z];
                dist_tot = euclidian_distance(p,p0);
                cell_list(i).dist_post_syn_subset(k) = dist_tot;
                k=k+1;
            end
        end
    end

    % Connection between HRZ ...
    for i=(n(1)+1):(n(1)+n(2))
        % ... and CR
        k=1;
        for j=1:n(1)
            xy0 = [cell_pos(i,1),cell_pos(i,2)];
            xy = [cell_pos(j,1),cell_pos(j,2)];
            dist_xy = euclidian_distance(xy,xy0);
            z0 = cell_pos(i,3);
            z = cell_pos(j,3);
            dist_z = abs(z0-z);
            if dist_xy<sigma(2)*3 && dist_z<z_extent
                cell_list(i).pre_syn_subset(k) = j;
                p0 = [xy0,z0];
                p = [xy,z];
                dist_tot = euclidian_distance(p,p0);
                cell_list(i).dist_pre_syn_subset(k) = dist_tot;
                k=k+1;
            end
        end
    end

    % Connection between BP_on ...
    for i=(n(1)+n(2)+1):(n(1)+n(2)+n(3))
        % ... and CR
        k=1;
        for j=1:n(1)
            xy0 = [cell_pos(i,1),cell_pos(i,2)];
            xy = [cell_pos(j,1),cell_pos(j,2)];
            dist_xy = euclidian_distance(xy,xy0);
            z0 = cell_pos(i,3);
            z = cell_pos(j,3);
            dist_z = abs(z0-z);
            if dist_xy<sigma(3)*3 && dist_z<z_extent
                cell_list(i).pre_syn_subset(k) = j;
                p0 = [xy0,z0];
                p = [xy,z];
                dist_tot = euclidian_distance(p,p0);
                cell_list(i).dist_pre_syn_subset(k) = dist_tot;
                k=k+1;
            end
        end
        % ... and AM_WF_on
        k=1;
        for j=(n(1)+n(2)+n(3)+n(4)+1):(n(1)+n(2)+n(3)+n(4)+n(5))
            xy0 = [cell_pos(i,1),cell_pos(i,2)];
            xy = [cell_pos(j,1),cell_pos(j,2)];
            dist_xy = euclidian_distance(xy,xy0);
            z0 = cell_pos(i,3);
            z = cell_pos(j,3);
            dist_z = abs(z0-z);
            if dist_xy<sigma(3)*3 && dist_z<z_extent
                cell_list(i).post_syn_subset(k) = j;
                p0 = [xy0,z0];
                p = [xy,z];
                dist_tot = euclidian_distance(p,p0);
                cell_list(i).dist_post_syn_subset(k) = dist_tot;
                k=k+1;
            end
        end
        % ... and AM_NF_on
        for j=(n(1)+n(2)+n(3)+n(4)+n(5)+n(6)+1):(n(1)+n(2)+n(3)+n(4)+n(5)+n(6)+n(7))
            xy0 = [cell_pos(i,1),cell_pos(i,2)];
            xy = [cell_pos(j,1),cell_pos(j,2)];
            dist_xy = euclidian_distance(xy,xy0);
            z0 = cell_pos(i,3);
            z = cell_pos(j,3);
            dist_z = abs(z0-z);
            if dist_xy<sigma(3)*3 && dist_z<z_extent
                cell_list(i).post_syn_subset(k) = j;
                p0 = [xy0,z0];
                p = [xy,z];
                dist_tot = euclidian_distance(p,p0);
                cell_list(i).dist_post_syn_subset(k) = dist_tot;
                k=k+1;
            end
        end
        ... and GL_on
        for j=(n(1)+n(2)+n(3)+n(4)+n(5)+n(6)+n(7)+1):(n(1)+n(2)+n(3)+n(4)+n(5)+n(6)+n(7)+n(8))
            xy0 = [cell_pos(i,1),cell_pos(i,2)];
            xy = [cell_pos(j,1),cell_pos(j,2)];
            dist_xy = euclidian_distance(xy,xy0);
            z0 = cell_pos(i,3);
            z = cell_pos(j,3);
            dist_z = abs(z0-z);
            if dist_xy<sigma(3)*3 && dist_z<z_extent
                cell_list(i).post_syn_subset(k) = j;
                p0 = [xy0,z0];
                p = [xy,z];
                dist_tot = euclidian_distance(p,p0);
                cell_list(i).dist_post_syn_subset(k) = dist_tot;
                k=k+1;
            end
        end
    end

    % Connection between BP_off ...
    for i=(n(1)+n(2)+n(3)+1):(n(1)+n(2)+n(3)+n(4))
        % ... and CR
        k=1;
        for j=1:n(1)
            xy0 = [cell_pos(i,1),cell_pos(i,2)];
            xy = [cell_pos(j,1),cell_pos(j,2)];
            dist_xy = euclidian_distance(xy,xy0);
            z0 = cell_pos(i,3);
            z = cell_pos(j,3);
            dist_z = abs(z0-z);
            if dist_xy<sigma(4)*3 && dist_z<z_extent
                cell_list(i).pre_syn_subset(k) = j;
                p0 = [xy0,z0];
                p = [xy,z];
                dist_tot = euclidian_distance(p,p0);
                cell_list(i).dist_pre_syn_subset(k) = dist_tot;
                k=k+1;
            end
        end
        % ... and AM_WF_off
        k=1;
        for j=(n(1)+n(2)+n(3)+n(4)+n(5)+1):(n(1)+n(2)+n(3)+n(4)+n(5)+n(6))
            xy0 = [cell_pos(i,1),cell_pos(i,2)];
            xy = [cell_pos(j,1),cell_pos(j,2)];
            dist_xy = euclidian_distance(xy,xy0);
            z0 = cell_pos(i,3);
            z = cell_pos(j,3);
            dist_z = abs(z0-z);
            if dist_xy<sigma(4)*3 && dist_z<z_extent
                cell_list(i).post_syn_subset(k) = j;
                p0 = [xy0,z0];
                p = [xy,z];
                dist_tot = euclidian_distance(p,p0);
                cell_list(i).dist_post_syn_subset(k) = dist_tot;
                k=k+1;
            end
        end
        % ... and GL_off
        k=1;
        for j=(n(1)+n(2)+n(3)+n(4)+n(5)+n(6)+n(7)+n(8)+1):(n(1)+n(2)+n(3)+n(4)+n(5)+n(6)+n(7)+n(8)+n(9))
            xy0 = [cell_pos(i,1),cell_pos(i,2)];
            xy = [cell_pos(j,1),cell_pos(j,2)];
            dist_xy = euclidian_distance(xy,xy0);
            z0 = cell_pos(i,3);
            z = cell_pos(j,3);
            dist_z = abs(z0-z);
            if dist_xy<sigma(4)*3 && dist_z<z_extent
                cell_list(i).post_syn_subset(k) = j;
                p0 = [xy0,z0];
                p = [xy,z];
                dist_tot = euclidian_distance(p,p0);
                cell_list(i).dist_post_syn_subset(k) = dist_tot;
                k=k+1;
            end
        end
    end

    % Connection between AM_WF_on ...
    for i=(n(1)+n(2)+n(3)+n(4)+1):(n(1)+n(2)+n(3)+n(4)+n(5))
        % ... and BP_on
        k=1;
        for j=(n(1)+n(2)+1):(n(1)+n(2)+n(3))
            xy0 = [cell_pos(i,1),cell_pos(i,2)];
            xy = [cell_pos(j,1),cell_pos(j,2)];
            dist_xy = euclidian_distance(xy,xy0);
            z0 = cell_pos(i,3);
            z = cell_pos(j,3);
            dist_z = abs(z0-z);
            if dist_xy<sigma(5)*3 && dist_z<z_extent
                cell_list(i).pre_syn_subset(k) = j;
                p0 = [xy0,z0];
                p = [xy,z];
                dist_tot = euclidian_distance(p,p0);
                cell_list(i).dist_pre_syn_subset(k) = dist_tot;
                k=k+1;
            end
        end
        % ... and GL_on
        k=1;
        for j=(n(1)+n(2)+n(3)+n(4)+n(5)+n(6)+n(7)+1):(n(1)+n(2)+n(3)+n(4)+n(5)+n(6)+n(7)+n(8))
            xy0 = [cell_pos(i,1),cell_pos(i,2)];
            xy = [cell_pos(j,1),cell_pos(j,2)];
            dist_xy = euclidian_distance(xy,xy0);
            z0 = cell_pos(i,3);
            z = cell_pos(j,3);
            dist_z = abs(z0-z);
            if dist_xy<sigma(5)*3 && dist_z<z_extent
                cell_list(i).post_syn_subset(k) = j;
                p0 = [xy0,z0];
                p = [xy,z];
                dist_tot = euclidian_distance(p,p0);
                cell_list(i).dist_post_syn_subset(k) = dist_tot;
                k=k+1;
            end
        end
    end

    % Connection between AM_WF_off ...
    for i=(n(1)+n(2)+n(3)+n(4)+n(5)+1):(n(1)+n(2)+n(3)+n(4)+n(5)+n(6))
        % ... and BP_off
        k=1;
        for j=(n(1)+n(2)+n(3)+1):(n(1)+n(2)+n(3)+n(4))
            xy0 = [cell_pos(i,1),cell_pos(i,2)];
            xy = [cell_pos(j,1),cell_pos(j,2)];
            dist_xy = euclidian_distance(xy,xy0);
            z0 = cell_pos(i,3);
            z = cell_pos(j,3);
            dist_z = abs(z0-z);
            if dist_xy<sigma(6)*3 && dist_z<z_extent
                cell_list(i).pre_syn_subset(k) = j;
                p0 = [xy0,z0];
                p = [xy,z];
                dist_tot = euclidian_distance(p,p0);
                cell_list(i).dist_pre_syn_subset(k) = dist_tot;
                k=k+1;
            end
        end
        % ... and GL_off
        k=1;
        for j=(n(1)+n(2)+n(3)+n(4)+n(5)+n(6)+n(7)+n(8)+1):(n(1)+n(2)+n(3)+n(4)+n(5)+n(6)+n(7)+n(8)+n(9))
            xy0 = [cell_pos(i,1),cell_pos(i,2)];
            xy = [cell_pos(j,1),cell_pos(j,2)];
            dist_xy = euclidian_distance(xy,xy0);
            z0 = cell_pos(i,3);
            z = cell_pos(j,3);
            dist_z = abs(z0-z);
            if dist_xy<sigma(6)*3 && dist_z<z_extent
                cell_list(i).post_syn_subset(k) = j;
                p0 = [xy0,z0];
                p = [xy,z];
                dist_tot = euclidian_distance(p,p0);
                cell_list(i).dist_post_syn_subset(k) = dist_tot;
                k=k+1;
            end
        end
    end

    % Connection between AM_NF_on ...
    for i=(n(1)+n(2)+n(3)+n(4)+n(5)+n(6)+1):(n(1)+n(2)+n(3)+n(4)+n(5)+n(6)+n(7))
        % ... and BP_on
        k=1;
        for j=(n(1)+n(2)+1):(n(1)+n(2)+n(3))
            xy0 = [cell_pos(i,1),cell_pos(i,2)];
            xy = [cell_pos(j,1),cell_pos(j,2)];
            dist_xy = euclidian_distance(xy,xy0);
            z0 = cell_pos(i,3);
            z = cell_pos(j,3);
            dist_z = abs(z0-z);
            if dist_xy<sigma(7)*3 && dist_z<z_extent
                cell_list(i).pre_syn_subset(k) = j;
                p0 = [xy0,z0];
                p = [xy,z];
                dist_tot = euclidian_distance(p,p0);
                cell_list(i).dist_pre_syn_subset(k) = dist_tot;
                k=k+1;
            end
        end
        % ... and GL_off
        k=1;
        for j=(n(1)+n(2)+n(3)+n(4)+n(5)+n(6)+n(7)+n(8)+1):(n(1)+n(2)+n(3)+n(4)+n(5)+n(6)+n(7)+n(8)+n(9))
            xy0 = [cell_pos(i,1),cell_pos(i,2)];
            xy = [cell_pos(j,1),cell_pos(j,2)];
            dist_xy = euclidian_distance(xy,xy0);
            z0 = cell_pos(i,3);
            z = cell_pos(j,3);
            dist_z = abs(z0-z);
            if dist_xy<sigma(7)*3 && dist_z<z_extent
                cell_list(i).post_syn_subset(k) = j;
                p0 = [xy0,z0];
                p = [xy,z];
                dist_tot = euclidian_distance(p,p0);
                cell_list(i).dist_post_syn_subset(k) = dist_tot;
                k=k+1;
            end
        end
    end

    % Connection between GL_on ...
    for i=(n(1)+n(2)+n(3)+n(4)+n(5)+n(6)+n(7)+1):(n(1)+n(2)+n(3)+n(4)+n(5)+n(6)+n(7)+n(8))
        % ... and BP_on
        k=1;
        for j=(n(1)+n(2)+1):(n(1)+n(2)+n(3))
            xy0 = [cell_pos(i,1),cell_pos(i,2)];
            xy = [cell_pos(j,1),cell_pos(j,2)];
            dist_xy = euclidian_distance(xy,xy0);
            z0 = cell_pos(i,3);
            z = cell_pos(j,3);
            dist_z = abs(z0-z);
            if dist_xy<sigma(8)*3 && dist_z<z_extent
                cell_list(i).pre_syn_subset(k) = j;
                p0 = [xy0,z0];
                p = [xy,z];
                dist_tot = euclidian_distance(p,p0);
                cell_list(i).dist_pre_syn_subset(k) = dist_tot;
                k=k+1;
            end
        end
        % ... and AM_WF_on
        for j=(n(1)+n(2)+n(3)+n(4)+1):(n(1)+n(2)+n(3)+n(4)+n(5))
            xy0 = [cell_pos(i,1),cell_pos(i,2)];
            xy = [cell_pos(j,1),cell_pos(j,2)];
            dist_xy = euclidian_distance(xy,xy0);
            z0 = cell_pos(i,3);
            z = cell_pos(j,3);
            dist_z = abs(z0-z);
            if dist_xy<sigma(8)*3.5 && dist_z<z_extent
                cell_list(i).pre_syn_subset(k) = j;
                p0 = [xy0,z0];
                p = [xy,z];
                dist_tot = euclidian_distance(p,p0);
                cell_list(i).dist_pre_syn_subset(k) = dist_tot;
                k=k+1;
            end
        end
    end

    % Connection between GL_off ...
    for i=(n(1)+n(2)+n(3)+n(4)+n(5)+n(6)+n(7)+n(8)+1):(n(1)+n(2)+n(3)+n(4)+n(5)+n(6)+n(7)+n(8)+n(9))
        % ... and BP_off
        k=1;
        for j=(n(1)+n(2)+n(3)+1):(n(1)+n(2)+n(3)+n(4))
            xy0 = [cell_pos(i,1),cell_pos(i,2)];
            xy = [cell_pos(j,1),cell_pos(j,2)];
            dist_xy = euclidian_distance(xy,xy0);
            z0 = cell_pos(i,3);
            z = cell_pos(j,3);
            dist_z = abs(z0-z);
            if dist_xy<sigma(9)*3 && dist_z<z_extent
                cell_list(i).pre_syn_subset(k) = j;
                p0 = [xy0,z0];
                p = [xy,z];
                dist_tot = euclidian_distance(p,p0);
                cell_list(i).dist_pre_syn_subset(k) = dist_tot;
                k=k+1;
            end
        end
        % ... and AM_WF_off
        for j=(n(1)+n(2)+n(3)+n(4)+n(5)+1):(n(1)+n(2)+n(3)+n(4)+n(5)+n(6))
            xy0 = [cell_pos(i,1),cell_pos(i,2)];
            xy = [cell_pos(j,1),cell_pos(j,2)];
            dist_xy = euclidian_distance(xy,xy0);
            z0 = cell_pos(i,3);
            z = cell_pos(j,3);
            dist_z = abs(z0-z);
            if dist_xy<sigma(9)*3 && dist_z<z_extent
                cell_list(i).pre_syn_subset(k) = j;
                p0 = [xy0,z0];
                p = [xy,z];
                dist_tot = euclidian_distance(p,p0);
                cell_list(i).dist_pre_syn_subset(k) = dist_tot;
                k=k+1;
            end
        end
        % ... and AM_NF_on
        for j=(n(1)+n(2)+n(3)+n(4)+n(5)+n(6)+1):(n(1)+n(2)+n(3)+n(4)+n(5)+n(6)+n(7))
            xy0 = [cell_pos(i,1),cell_pos(i,2)];
            xy = [cell_pos(j,1),cell_pos(j,2)];
            dist_xy = euclidian_distance(xy,xy0);
            z0 = cell_pos(i,3);
            z = cell_pos(j,3);
            dist_z = abs(z0-z);
            if dist_xy<sigma(9)*3 && dist_z<z_extent
                cell_list(i).pre_syn_subset(k) = j;
                p0 = [xy0,z0];
                p = [xy,z];
                dist_tot = euclidian_distance(p,p0);
                cell_list(i).dist_pre_syn_subset(k) = dist_tot;
                k=k+1;
            end
        end
    end
end


%%%%% Function visualize_connection_syn_all_pop %%%%%
function visualize_connection_syn_all_pop(cell_list,um)
        
        visualize_connection_syn(cell_list,um,3523);
        visualize_connection_syn(cell_list,um,4447);
        visualize_connection_syn(cell_list,um,6402); 
        visualize_connection_syn(cell_list,um,6442);
        visualize_connection_syn(cell_list,um,8310);
        visualize_connection_syn(cell_list,um,8742);
        visualize_connection_syn(cell_list,um,9300);
        visualize_connection_syn(cell_list,um,9732);
        visualize_connection_syn(cell_list,um,10700);

 end

%%%%% Function visualize_connection_syn %%%%%
function visualize_connection_syn(cell_list,um,index)

    idx = index;

    if length(cell_list(idx).pre_syn_subset) >= 1 && length(cell_list(idx).post_syn_subset) >= 1
        figure
        xlim([-200*um 200*um])
        ylim([-400*um 400*um])
        zlim([0*um 210*um])
        plot3(cell_list(idx).x,cell_list(idx).y,cell_list(idx).z,'o','Color',cell_list(idx).color);
        hold on
        for j=1:length(cell_list(idx).pre_syn_subset)
            plot3(cell_list(cell_list(idx).pre_syn_subset(j)).x,cell_list(cell_list(idx).pre_syn_subset(j)).y,cell_list(cell_list(idx).pre_syn_subset(j)).z,'.','Color',cell_list(cell_list(idx).pre_syn_subset(j)).color);
            hold on
        end
        for j=1:length(cell_list(idx).post_syn_subset)
            plot3(cell_list(cell_list(idx).post_syn_subset(j)).x,cell_list(cell_list(idx).post_syn_subset(j)).y,cell_list(cell_list(idx).post_syn_subset(j)).z,'.','Color',cell_list(cell_list(idx).post_syn_subset(j)).color);
            hold on
        end
        xlabel('x')
        ylabel('y')
        zlabel('z')
    elseif length(cell_list(idx).pre_syn_subset) >= 1
        figure
        xlim([-200*um 200*um])
        ylim([-400*um 400*um])
        zlim([0*um 210*um])
        plot3(cell_list(idx).x,cell_list(idx).y,cell_list(idx).z,'o','Color',cell_list(idx).color);
        hold on
        for j=1:length(cell_list(idx).pre_syn_subset)
            plot3(cell_list(cell_list(idx).pre_syn_subset(j)).x,cell_list(cell_list(idx).pre_syn_subset(j)).y,cell_list(cell_list(idx).pre_syn_subset(j)).z,'.','Color',cell_list(cell_list(idx).pre_syn_subset(j)).color);
            hold on
        end
        xlabel('x')
        ylabel('y')
        zlabel('z')
    elseif length(cell_list(idx).post_syn_subset) >= 1
        figure
        xlim([-200*um 200*um])
        ylim([-400*um 400*um])
        zlim([0*um 210*um])
        plot3(cell_list(idx).x,cell_list(idx).y,cell_list(idx).z,'o','Color',cell_list(idx).color);
        hold on
        for j=1:length(cell_list(idx).post_syn_subset)
            plot3(cell_list(cell_list(idx).post_syn_subset(j)).x,cell_list(cell_list(idx).post_syn_subset(j)).y,cell_list(cell_list(idx).post_syn_subset(j)).z,'.','Color',cell_list(cell_list(idx).post_syn_subset(j)).color);
            hold on
        end
        xlabel('x')
        ylabel('y')
        zlabel('z')
    end
end

function save_cell_list(cell_list)
%     save('Spatial_model_cell_list','cell_list')
    assignin("base","cell_list",cell_list)
end

function save_pos(mat)
%     save("3Dpos","mat")
    assignin("base", "mat3D", mat);
end
