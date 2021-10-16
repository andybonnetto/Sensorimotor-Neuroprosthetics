function Spatial_modeling()
    import Cell.*
    % Spatial Modeling
    
%     cell_pos = create_pos();
%     cell_list = create_list();

    noise = 0;
    um = 1e-6;
    
    %%%%% Function cell_pos %%%%%

    name_list = ["CR", "HRZ", "BP_on", "BP_off", "AM_WF_on","AM_WF_off", "AM_NF_on", "GL_on", "GL_off" ];
    cell_pos = zeros(1,3);
    i = 1;
    n_list = ones(1,length(name_list)+1);
    cell_list = [];
    for name = name_list
        [pos_mat,n] = create_pos(name, noise);
        length(pos_mat(:,1))
        cell_pos = vertcat(cell_pos,pos_mat);
        if i == 1
            cell_pos(1,:) = [];
        end
        n_list(i+1) = n;
        for k = n_list(i):n_list(i+1)
            cell = Cell(name, [cell_pos(k,1), cell_pos(k,2), cell_pos(k,3)]);
            cell_list = [cell_list,cell];
        end
        i = i+1;
    end
   
    figure
    color_list = ['b','k','r','r', 'y', 'y', 'y','g','g' ];
    current_ind = 0;
    for i = 1:length(name_list)
        current_ind = current_ind + n_list(i)
        plot3(cell_pos(current_ind:current_ind + n_list(i+1),1),cell_pos(current_ind:current_ind + n_list(i+1),2),cell_pos(current_ind:current_ind + n_list(i+1),3),'.','Color',color_list(i));
        hold on
    end
    figure
    plot3(cell_pos(:,1),cell_pos(:,2),cell_pos(:,3), '.')

    figure
    plot(cell_pos(:,1),cell_pos(:,3),'.');
    figure
    plot(cell_pos(:,2),cell_pos(:,3),'.');
    
    %%%%% Function electrical_coupling %%%%%

%     % One xy spatial extent for each type of cell, and one z spatial extent
%     % for each type of cell as well
% 
%     z_extent = 105*um;
% 
%     % Connection between CR cells and HRZ/BP_on/BP_off cells
%     for i=1:n_CR_matrix
%         % With HRZ, BP_on, BP_off
%         k=1;
%         for j=n_CR_matrix:n_HRZ_matrix+n_BP_on_matrix+n_BP_off_matrix
%             if i~=j
%                 xy0 = [cell_pos(i,1),cell_pos(i,2)];
%                 xy = [cell_pos(j,1),cell_pos(j,2)];
%                 dist_xy = euclidian_distance(xy,xy0);
%                 z0 = cell_pos(i,3);
%                 z = cell_pos(j,3);
%                 dist_z = abs(z0-z);
%                 if dist_xy<sigma_CR && dist_z<z_extent
%                     cell_list(i).post_syn_subset(k) = j;
%                     p0 = [xy0,z0];
%                     p = [xy,z];
%                     dist_tot = euclidian_distance(p,p0);
%                     cell_list(i).distance_post_syn(k) = dist_tot;
%                     k=k+1;
%                 end
%             end
%         end
%     end
% 
%     % Connection between HRZ cells and CR cells
%     for i=n_CR_matrix:n_CR_matrix+n_HRZ_matrix
%         % With CR
%         k=1;
%         for j=1:n_CR_matrix
%             if i~=j
%                 xy0 = [cell_pos(i,1),cell_pos(i,2)];
%                 xy = [cell_pos(j,1),cell_pos(j,2)];
%                 dist_xy = euclidian_distance(xy,xy0);
%                 z0 = cell_pos(i,3);
%                 z = cell_pos(j,3);
%                 dist_z = abs(z0-z);
%                 if dist_xy<sigma_CR && dist_z<z_extent
%                     cell_list(i).pre_syn_subset(k) = j;
%                     p0 = [xy0,z0];
%                     p = [xy,z];
%                     dist_tot = euclidian_distance(p,p0);
%                     cell_list(i).distance_pre_syn(k) = dist_tot;
%                     k=k+1;
%                 end
%             end
%         end
%     end
% 
%     % Connection between BP_on cells and CR/AM_WF_on/AM_NF_on/GL_on cells
%     for i=n_CR_matrix+n_HRZ_matrix:n_CR_matrix+n_HRZ_matrix+n_BP_on_matrix
%         % With CR
%         k=1;
%         for j=1:n_CR_matrix
%             if i~=j
%                 xy0 = [cell_pos(i,1),cell_pos(i,2)];
%                 xy = [cell_pos(j,1),cell_pos(j,2)];
%                 dist_xy = euclidian_distance(xy,xy0);
%                 z0 = cell_pos(i,3);
%                 z = cell_pos(j,3);
%                 dist_z = abs(z0-z);
%                 if dist_xy<sigma_BP && dist_z<z_extent
%                     cell_list(i).pre_syn_subset(k) = j;
%                     p0 = [xy0,z0];
%                     p = [xy,z];
%                     dist_tot = euclidian_distance(p,p0);
%                     cell_list(i).distance_pre_syn(k) = dist_tot;
%                     k=k+1;
%                 end
%             end
%         end
%         % With AM_WF_on
%         k=1;
%         for j=n_CR_matrix+n_HRZ_matrix+n_BP_on_matrix+n_BP_off_matrix:n_CR_matrix+n_HRZ_matrix+n_BP_on_matrix+n_BP_off_matrix+n_AM_WF_on_matrix
%             if i~=j
%                 xy0 = [cell_pos(i,1),cell_pos(i,2)];
%                 xy = [cell_pos(j,1),cell_pos(j,2)];
%                 dist_xy = euclidian_distance(xy,xy0);
%                 z0 = cell_pos(i,3);
%                 z = cell_pos(j,3);
%                 dist_z = abs(z0-z);
%                 if dist_xy<sigma_BP && dist_z<z_extent
%                     cell_list(i).post_syn_subset(k) = j;
%                     p0 = [xy0,z0];
%                     p = [xy,z];
%                     dist_tot = euclidian_distance(p,p0);
%                     cell_list(i).distance_post_syn(k) = dist_tot;
%                     k=k+1;
%                 end
%             end
%         end
%         % With AM_NF_on
%         for j=n_CR_matrix+n_HRZ_matrix+n_BP_on_matrix+n_BP_off_matrix+n_AM_WF_on_matrix+n_AM_WF_off_matrix:n_CR_matrix+n_HRZ_matrix+n_BP_on_matrix+n_BP_off_matrix+n_AM_WF_on_matrix+n_AM_WF_off_matrix+n_AM_NF_on_matrix
%             if i~=j
%                 xy0 = [cell_pos(i,1),cell_pos(i,2)];
%                 xy = [cell_pos(j,1),cell_pos(j,2)];
%                 dist_xy = euclidian_distance(xy,xy0);
%                 z0 = cell_pos(i,3);
%                 z = cell_pos(j,3);
%                 dist_z = abs(z0-z);
%                 if dist_xy<sigma_BP && dist_z<z_extent
%                     cell_list(i).post_syn_subset(k) = j;
%                     p0 = [xy0,z0];
%                     p = [xy,z];
%                     dist_tot = euclidian_distance(p,p0);
%                     cell_list(i).distance_post_syn(k) = dist_tot;
%                     k=k+1;
%                 end
%             end
%         end
%         % With GL_on
%         for j=n_CR_matrix+n_HRZ_matrix+n_BP_on_matrix+n_BP_off_matrix+n_AM_WF_on_matrix+n_AM_WF_off_matrix+n_AM_NF_on_matrix:n_CR_matrix+n_HRZ_matrix+n_BP_on_matrix+n_BP_off_matrix+n_AM_WF_on_matrix+n_AM_WF_off_matrix+n_AM_NF_on_matrix+n_GL_on_matrix
%             if i~=j
%                 xy0 = [cell_pos(i,1),cell_pos(i,2)];
%                 xy = [cell_pos(j,1),cell_pos(j,2)];
%                 dist_xy = euclidian_distance(xy,xy0);
%                 z0 = cell_pos(i,3);
%                 z = cell_pos(j,3);
%                 dist_z = abs(z0-z);
%                 if dist_xy<sigma_BP && dist_z<z_extent
%                     cell_list(i).post_syn_subset(k) = j;
%                     p0 = [xy0,z0];
%                     p = [xy,z];
%                     dist_tot = euclidian_distance(p,p0);
%                     cell_list(i).distance_post_syn(k) = dist_tot;
%                     k=k+1;
%                 end
%             end
%         end
%     end
% 
%     % Connection between AM_WF_on cells and BP_on/GL_on cells
%     for i=n_CR_matrix+n_HRZ_matrix+n_BP_on_matrix+n_BP_off_matrix:n_CR_matrix+n_HRZ_matrix+n_BP_on_matrix+n_BP_off_matrix+n_AM_WF_on_matrix
%         % With BP_on
%         k=1;
%         for j=n_CR_matrix+n_HRZ_matrix:n_CR_matrix+n_HRZ_matrix+n_BP_on_matrix
%             if i~=j
%                 xy0 = [cell_pos(i,1),cell_pos(i,2)];
%                 xy = [cell_pos(j,1),cell_pos(j,2)];
%                 dist_xy = euclidian_distance(xy,xy0);
%                 z0 = cell_pos(i,3);
%                 z = cell_pos(j,3);
%                 dist_z = abs(z0-z);
%                 if dist_xy<sigma_AM_WF && dist_z<z_extent
%                     cell_list(i).pre_syn_subset(k) = j;
%                     p0 = [xy0,z0];
%                     p = [xy,z];
%                     dist_tot = euclidian_distance(p,p0);
%                     cell_list(i).distance_pre_syn(k) = dist_tot;
%                     k=k+1;
%                 end
%             end
%         end
%         % With GL_on
%         k=1;
%         for j=n_CR_matrix+n_HRZ_matrix+n_BP_on_matrix+n_BP_off_matrix+n_AM_WF_on_matrix+n_AM_WF_off_matrix+n_AM_NF_on_matrix:n_CR_matrix+n_HRZ_matrix+n_BP_on_matrix+n_BP_off_matrix+n_AM_WF_on_matrix+n_AM_WF_off_matrix+n_AM_NF_on_matrix+n_GL_on_matrix
%             if i~=j
%                 xy0 = [cell_pos(i,1),cell_pos(i,2)];
%                 xy = [cell_pos(j,1),cell_pos(j,2)];
%                 dist_xy = euclidian_distance(xy,xy0);
%                 z0 = cell_pos(i,3);
%                 z = cell_pos(j,3);
%                 dist_z = abs(z0-z);
%                 if dist_xy<sigma_AM_WF && dist_z<z_extent
%                     cell_list(i).post_syn_subset(k) = j;
%                     p0 = [xy0,z0];
%                     p = [xy,z];
%                     dist_tot = euclidian_distance(p,p0);
%                     cell_list(i).distance_post_syn(k) = dist_tot;
%                     k=k+1;
%                 end
%             end
%         end
%     end
% 
%     % Connection between AM_WF_off cells and BP_off/GL_off cells
%     for i=n_CR_matrix+n_HRZ_matrix+n_BP_on_matrix+n_BP_off_matrix+n_AM_WF_on_matrix:n_CR_matrix+n_HRZ_matrix+n_BP_on_matrix+n_BP_off_matrix+n_AM_WF_on_matrix+n_AM_WF_off_matrix
%         % With BP_off
%         k=1;
%         for j=n_CR_matrix+n_HRZ_matrix+n_BP_on_matrix:n_CR_matrix+n_HRZ_matrix+n_BP_on_matrix+n_BP_off_matrix
%             if i~=j
%                 xy0 = [cell_pos(i,1),cell_pos(i,2)];
%                 xy = [cell_pos(j,1),cell_pos(j,2)];
%                 dist_xy = euclidian_distance(xy,xy0);
%                 z0 = cell_pos(i,3);
%                 z = cell_pos(j,3);
%                 dist_z = abs(z0-z);
%                 if dist_xy<sigma_AM_WF && dist_z<z_extent
%                     cell_list(i).pre_syn_subset(k) = j;
%                     p0 = [xy0,z0];
%                     p = [xy,z];
%                     dist_tot = euclidian_distance(p,p0);
%                     cell_list(i).distance_pre_syn(k) = dist_tot;
%                     k=k+1;
%                 end
%             end
%         end
%         % With GL_off
%         k=1;
%         for j=n_CR_matrix+n_HRZ_matrix+n_BP_on_matrix+n_BP_off_matrix+n_AM_WF_on_matrix+n_AM_WF_off_matrix+n_AM_NF_on_matrix+n_GL_on_matrix:n_CR_matrix+n_HRZ_matrix+n_BP_on_matrix+n_BP_off_matrix+n_AM_WF_on_matrix+n_AM_WF_off_matrix+n_AM_NF_on_matrix+n_GL_on_matrix+n_GL_off_matrix
%             if i~=j
%                 xy0 = [cell_pos(i,1),cell_pos(i,2)];
%                 xy = [cell_pos(j,1),cell_pos(j,2)];
%                 dist_xy = euclidian_distance(xy,xy0);
%                 z0 = cell_pos(i,3);
%                 z = cell_pos(j,3);
%                 dist_z = abs(z0-z);
%                 if dist_xy<sigma_AM_WF && dist_z<z_extent
%                     cell_list(i).post_syn_subset(k) = j;
%                     p0 = [xy0,z0];
%                     p = [xy,z];
%                     dist_tot = euclidian_distance(p,p0);
%                     cell_list(i).distance_post_syn(k) = dist_tot;
%                     k=k+1;
%                 end
%             end
%         end
%     end
% 
%     % Connection between AM_NF_on cells and BP_on/GL_off cells
%     for i=n_CR_matrix+n_HRZ_matrix+n_BP_on_matrix+n_BP_off_matrix+n_AM_WF_on_matrix+n_AM_WF_off_matrix:n_CR_matrix+n_HRZ_matrix+n_BP_on_matrix+n_BP_off_matrix+n_AM_WF_on_matrix+n_AM_WF_off_matrix+n_AM_NF_on_matrix
%         % With BP_on
%         k=1;
%         for j=n_CR_matrix+n_HRZ_matrix:n_CR_matrix+n_HRZ_matrix+n_BP_on_matrix
%             if i~=j
%                 xy0 = [cell_pos(i,1),cell_pos(i,2)];
%                 xy = [cell_pos(j,1),cell_pos(j,2)];
%                 dist_xy = euclidian_distance(xy,xy0);
%                 z0 = cell_pos(i,3);
%                 z = cell_pos(j,3);
%                 dist_z = abs(z0-z);
%                 if dist_xy<sigma_AM_WF && dist_z<z_extent
%                     cell_list(i).pre_syn_subset(k) = j;
%                     p0 = [xy0,z0];
%                     p = [xy,z];
%                     dist_tot = euclidian_distance(p,p0);
%                     cell_list(i).distance_pre_syn(k) = dist_tot;
%                     k=k+1;
%                 end
%             end
%         end
%         % With GL_off
%         k=1;
%         for j=n_CR_matrix+n_HRZ_matrix+n_BP_on_matrix+n_BP_off_matrix+n_AM_WF_on_matrix+n_AM_WF_off_matrix+n_AM_NF_on_matrix+n_GL_on_matrix:n_CR_matrix+n_HRZ_matrix+n_BP_on_matrix+n_BP_off_matrix+n_AM_WF_on_matrix+n_AM_WF_off_matrix+n_AM_NF_on_matrix+n_GL_on_matrix+n_GL_off_matrix
%             if i~=j
%                 xy0 = [cell_pos(i,1),cell_pos(i,2)];
%                 xy = [cell_pos(j,1),cell_pos(j,2)];
%                 dist_xy = euclidian_distance(xy,xy0);
%                 z0 = cell_pos(i,3);
%                 z = cell_pos(j,3);
%                 dist_z = abs(z0-z);
%                 if dist_xy<sigma_AM_WF && dist_z<z_extent
%                     cell_list(i).post_syn_subset(k) = j;
%                     p0 = [xy0,z0];
%                     p = [xy,z];
%                     dist_tot = euclidian_distance(p,p0);
%                     cell_list(i).distance_post_syn(k) = dist_tot;
%                     k=k+1;
%                 end
%             end
%         end
%     end
% 
%     % Connection between GL_on cells and BP_on/AM_WF_on
%     for i=n_CR_matrix+n_HRZ_matrix+n_BP_on_matrix+n_BP_off_matrix+n_AM_WF_on_matrix+n_AM_WF_off_matrix+n_AM_NF_on_matrix:n_CR_matrix+n_HRZ_matrix+n_BP_on_matrix+n_BP_off_matrix+n_AM_WF_on_matrix+n_AM_WF_off_matrix+n_AM_NF_on_matrix+n_GL_on_matrix
%         % With BP_on
%         k=1;
%         for j=n_CR_matrix+n_HRZ_matrix:n_CR_matrix+n_HRZ_matrix+n_BP_on_matrix
%             if i~=j
%                 xy0 = [cell_pos(i,1),cell_pos(i,2)];
%                 xy = [cell_pos(j,1),cell_pos(j,2)];
%                 dist_xy = euclidian_distance(xy,xy0);
%                 z0 = cell_pos(i,3);
%                 z = cell_pos(j,3);
%                 dist_z = abs(z0-z);
%                 if dist_xy<sigma_GL && dist_z<z_extent
%                     cell_list(i).pre_syn_subset(k) = j;
%                     p0 = [xy0,z0];
%                     p = [xy,z];
%                     dist_tot = euclidian_distance(p,p0);
%                     cell_list(i).distance_pre_syn(k) = dist_tot;
%                     k=k+1;
%                 end
%             end
%         end
%         % With AM_WF_on
%         for j=n_CR_matrix+n_HRZ_matrix+n_BP_on_matrix+n_BP_off_matrix:n_CR_matrix+n_HRZ_matrix+n_BP_on_matrix+n_BP_off_matrix+n_AM_WF_on_matrix
%             if i~=j
%                 xy0 = [cell_pos(i,1),cell_pos(i,2)];
%                 xy = [cell_pos(j,1),cell_pos(j,2)];
%                 dist_xy = euclidian_distance(xy,xy0);
%                 z0 = cell_pos(i,3);
%                 z = cell_pos(j,3);
%                 dist_z = abs(z0-z);
%                 if dist_xy<sigma_BP && dist_z<z_extent
%                     cell_list(i).pre_syn_subset(k) = j;
%                     p0 = [xy0,z0];
%                     p = [xy,z];
%                     dist_tot = euclidian_distance(p,p0);
%                     cell_list(i).distance_pre_syn(k) = dist_tot;
%                     k=k+1;
%                 end
%             end
%         end
%     end
% 
%     % Connection between GL_off cells and BP_off/AM_WF_off/AM_NF_on
%     for i=n_CR_matrix+n_HRZ_matrix+n_BP_on_matrix+n_BP_off_matrix+n_AM_WF_on_matrix+n_AM_WF_off_matrix+n_AM_NF_on_matrix+n_GL_on_matrix:n_CR_matrix+n_HRZ_matrix+n_BP_on_matrix+n_BP_off_matrix+n_AM_WF_on_matrix+n_AM_WF_off_matrix+n_AM_NF_on_matrix+n_GL_on_matrix+n_GL_off_matrix
%         % With BP_off
%         k=1;
%         for j=i:n_CR_matrix+n_HRZ_matrix+n_BP_on_matrix:n_CR_matrix+n_HRZ_matrix+n_BP_on_matrix+n_BP_off_matrix
%             if i~=j
%                 xy0 = [cell_pos(i,1),cell_pos(i,2)];
%                 xy = [cell_pos(j,1),cell_pos(j,2)];
%                 dist_xy = euclidian_distance(xy,xy0);
%                 z0 = cell_pos(i,3);
%                 z = cell_pos(j,3);
%                 dist_z = abs(z0-z);
%                 if dist_xy<sigma_GL && dist_z<z_extent
%                     cell_list(i).pre_syn_subset(k) = j;
%                     p0 = [xy0,z0];
%                     p = [xy,z];
%                     dist_tot = euclidian_distance(p,p0);
%                     cell_list(i).distance_pre_syn(k) = dist_tot;
%                     k=k+1;
%                 end
%             end
%         end
%         % With AM_WF_off
%         for j=n_CR_matrix+n_HRZ_matrix+n_BP_on_matrix+n_BP_off_matrix+n_AM_WF_on_matrix:n_CR_matrix+n_HRZ_matrix+n_BP_on_matrix+n_BP_off_matrix+n_AM_WF_on_matrix+n_AM_WF_off_matrix
%             if i~=j
%                 xy0 = [cell_pos(i,1),cell_pos(i,2)];
%                 xy = [cell_pos(j,1),cell_pos(j,2)];
%                 dist_xy = euclidian_distance(xy,xy0);
%                 z0 = cell_pos(i,3);
%                 z = cell_pos(j,3);
%                 dist_z = abs(z0-z);
%                 if dist_xy<sigma_BP && dist_z<z_extent
%                     cell_list(i).pre_syn_subset(k) = j;
%                     p0 = [xy0,z0];
%                     p = [xy,z];
%                     dist_tot = euclidian_distance(p,p0);
%                     cell_list(i).distance_pre_syn(k) = dist_tot;
%                     k=k+1;
%                 end
%             end
%         end
%         % With AM_NF_on
%         for j=n_CR_matrix+n_HRZ_matrix+n_BP_on_matrix+n_BP_off_matrix+n_AM_WF_on_matrix+n_AM_WF_off_matrix:n_CR_matrix+n_HRZ_matrix+n_BP_on_matrix+n_BP_off_matrix+n_AM_WF_on_matrix+n_AM_WF_off_matrix+n_AM_NF_on_matrix
%             if i~=j
%                 xy0 = [cell_pos(i,1),cell_pos(i,2)];
%                 xy = [cell_pos(j,1),cell_pos(j,2)];
%                 dist_xy = euclidian_distance(xy,xy0);
%                 z0 = cell_pos(i,3);
%                 z = cell_pos(j,3);
%                 dist_z = abs(z0-z);
%                 if dist_xy<sigma_BP && dist_z<z_extent
%                     cell_list(i).pre_syn_subset(k) = j;
%                     p0 = [xy0,z0];
%                     p = [xy,z];
%                     dist_tot = euclidian_distance(p,p0);
%                     cell_list(i).distance_pre_syn(k) = dist_tot;
%                     k=k+1;
%                 end
%             end
%         end
%     end
%     cell_list(27).pre_syn_subset
%     cell_list(27).distance_pre_syn
%     cell_list(27).post_syn_subset
%     cell_list(27).distance_post_syn
end

function p = lattice_generation(size, spacing, sigma, noise)
    K = [];
    N = [];
    for i = size
        for j = size
            param = [i,j];
            n = noise*normrnd([0,0],sigma);
            K = vertcat(K, param);
            N = vertcat(N,n);
        end
    end
    M = [1, sqrt(3);1, -sqrt(3)]*spacing;
    p = K*M + N;
end

function [cell_pos,n] = create_pos(name,noise)
    cell_ref = Cell(name, [0,0,0]);
    n = cell_ref.n;
    size_n = sqrt(n);
    index = -floor(size_n/2):floor(size_n/2);
    xy = lattice_generation(index,cell_ref.lambda,cell_ref.sigma,noise);
    n_matrix = size(index,2)^2;
    z = cell_ref.z_min + (cell_ref.z_max-cell_ref.z_min).*rand(n_matrix,1);
    cell_pos = horzcat(xy,z);
    
    for k = 1:length(cell_pos(:,1))-n
        random_ind = randi(length(cell_pos(:,1)));
        cell_pos(random_ind,:) = [];
    end
end


function d = euclidian_distance(p,p0)
    d = sqrt(sum((p - p0) .^ 2));
end
