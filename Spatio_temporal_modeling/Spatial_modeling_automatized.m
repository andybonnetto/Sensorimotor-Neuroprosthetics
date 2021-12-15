function [cell_list,cell_list_d,cell_list_full,fp_indices] = Spatial_modeling_automatized(vis,M,Populations,Degeneration,path_to_folder)

    import Cell.*
    % Spatial Modeling

    % Variables
    Gauss_degen = Degeneration > 0;
    stand_dev = [50,50,50,50,50,50,50,50,50]; % Standard deviation for Gaussian function
    center = [0 0;
               0 0;
               0 0;
               0 0;
               0 0;
               0 0;
               0 0;
               0 0;
               0 0]; % Center of the applied Gaussian function
%     Gauss_degen = [0,0,0,0,0,0,0,0,0]; % Targeted populations for Gaussian degeneration (here we only target the CR and BP_on cells)
    Full_Populations = [1,1,1,1,1,1,1,1,1];

    % Parameters
    Populations_name = ["CR","HRZ","BP_on","BP_off","AM_WF_on","AM_WF_off","AM_NF_on","GL_on","GL_off"]; % Populations respective name
    Populations_connection = [2 3 4 0 0;
                              1 0 0 0 0;
                              1 5 7 8 0;
                              1 6 9 0 0;
                              3 8 0 0 0;
                              4 9 0 0 0;
                              3 9 0 0 0;
                              3 5 0 0 0;
                              4 6 7 0 0]; % 1 refers to CR, 2 refers to HRZ, 3 refers to BP_on, etc. The 0 at the end is a stop marker
    noise = 0;
    um = 1e-6;
    lambda = (1/sqrt(M))*[2.5,7,3.85,3.85,8,8,6,6,6].*um;
    sigma = [2.5,10.5,3.85,3.85,24,24,6,6*5/4,6].*um;
    z_min = [170,100,100,100,80,80,80,25,25].*um;
    z_max = [205,128,128,128,101,101,101,39,39].*um;
    n = M.*[4105,537,1741,1741,391,391,721,721,721];

    % Redefine the number of cells for each population
    n_new = redefine_n(Populations,n);
    n_new_sum = cumsum(n_new);
    B = [0 n_new_sum];

    n_new_full = redefine_n(Full_Populations,n);
    n_new_sum_full = cumsum(n_new_full);
    B_full = [0 n_new_sum_full];


    assignin("base","n_CR",n_new_full(1));
    
    % Attribute one position to each cell and visualize the layers
    cell_pos = create_pos(Populations,noise,lambda,sigma,z_min,z_max,n_new);
    cell_pos_full = create_pos(Full_Populations,noise,lambda,sigma,z_min,z_max,n_new_full);

    %Save cell_pos in a mat file
%     save_pos(cell_pos)

    % Create a list with each cell properties and xyz position
    cell_list = create_list(Populations,Populations_name,cell_pos,B);
    cell_list_full = create_list(Full_Populations,Populations_name,cell_pos_full,B_full);

    % Visualize the layers
    plot_layers(cell_list,n_new,um,cell_pos,vis);
    plot_layers(cell_list_full,n_new_full,um,cell_pos_full,vis);
    

    % Kill a certain percentage of cells by degeneration
%     [cell_list_degen,n_degen] = degeneration(cell_list,Populations,Degeneration,n_new);
%     n_degen_sum = cumsum(n_degen);
%     B_degen = [0 n_degen_sum];

    % Visualize the layers after degeneration
%     plot_layers(cell_list_degen,n_degen,um,vis);

    % Generate a Gaussian function for degeneration
    [cell_list_gauss_degen,n_gauss_degen] = gaussian_degen(Gauss_degen,cell_list,Populations,n_new,stand_dev,center,vis,Degeneration);
    n_gauss_degen_sum = cumsum(n_gauss_degen);
    B_gauss_degen = [0 n_gauss_degen_sum];
    
    fp_indices = get_cell_indices(cell_pos,cell_list_gauss_degen);

    % Visualize the layers after gaussian degeneration
    plot_layers(cell_list_gauss_degen,n_gauss_degen,um,cell_pos,vis,path_to_folder);

    % Connect the population of cells through synapses and visualize the
    % connections
    
    cell_list_full = connection_syn(cell_list_full,sigma,um,Full_Populations,Populations_connection,B_full);
    cell_list = connection_syn(cell_list,sigma,um,Populations,Populations_connection,B);
%     cell_list_degen = connection_syn(cell_list_degen,sigma,um,Populations,Populations_connection,B_degen);
    cell_list_d = connection_syn(cell_list_gauss_degen,sigma,um,Populations,Populations_connection,B_gauss_degen);
    
    
%     cell_list = cell_list_gauss_degen;
    assignin("base","n_CR",n_gauss_degen(1));
%     % Visualize one cell with its connections
%     visualize_connection_syn_all_pop(cell_list,um,M);
    
    mat3D = zeros(length(cell_list),3);
    i = 1;
    for c = cell_list
        mat3D(i,:) = [c.x,c.y,c.z];
        i = i+1;
    end
    save_pos(mat3D)
    save_pos(cell_pos_full,"mat3D_full")
%     
%     %Save cell_list in a MAT-file 
%     save_cell_list(cell_list)
% end

    
    function fp_indices = get_cell_indices(cell_pos,cell_list_gauss_degen)
        i = 1;
        fp_indices = zeros(size(cell_list_gauss_degen));
        for cell_d = cell_list_gauss_degen
            k = 1;
            for pos = cell_pos.'
                val = cell_d.x == pos(1) && cell_d.y == pos(2) && cell_d.z == pos(3);
                if val
                    fp_indices(i) = k;
                    break
                end
                k = k+1;
            end
            i = i+1;
        end
    end

%%%%% Function redefine_n %%%%%
function n_new = redefine_n(Populations,n)
    
    for i=1:length(Populations)
        size_matrix = sqrt(n(i));
        index = -floor(size_matrix/2):floor(size_matrix/2);
        n(i) = size(index,2)^2;
    end
    
    n_new = [];
    for i=1:length(Populations)
        if Populations(i) == 1
            n_new(i) = n(i);
        else
            n_new(i) = 0;
        end
    end
end

%%%%% Function lattice_generation %%%%%
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

%%%%% Function cell_pos %%%%%
function cell_pos = create_pos(Populations,noise,lambda,sigma,z_min,z_max,n)
    
    cell_pos=[];
    for i=1:length(Populations)
        if Populations(i)==1
            new_pos = unique_pos(noise,lambda,sigma,z_min,z_max,n,i);
            cell_pos = vertcat(cell_pos,new_pos);
        end
    end
end

%%%%% Function position %%%%%
function position = unique_pos(noise,lambda,sigma,z_min,z_max,n,i)

    size_matrix = sqrt(n(i));
    index = -floor(size_matrix/2):floor(size_matrix/2);
    xy = lattice_generation(index,lambda(i),sigma(i),noise);
    n_matrix = size(index,2)^2;
    z = z_min(i) + (z_max(i)-z_min(i)).*rand(n_matrix,1);
    position = horzcat(xy,z);

end

%%%%% Function visualization_pos %%%%%
function plot_layers(cell_list,n,um,cell_pos,vis, path_to_folder)

    if vis == 1

        figure()
        for i=1:sum(n)
            plot3(cell_list(i).x/um,cell_list(i).y/um,cell_list(i).z/um,'.','Color',cell_list(i).color);
            hold on
        end
        hold off
        xlim([-200 200])
        ylim([-400 400])
        zlim([0 210])
        xlabel('x-axis [µm]')
        ylabel('y-axis [µm]')
        zlabel('z-axis [µm]')

        if nargin > 5
            saveas(gcf,strcat(path_to_folder,"Spatial modeling"))
        end
%         legend('CR', 'HRZ', 'BP', 'AM', 'GL')

%         figure()
%         k = 1;
%         names = ["CR","HRZ","BP_on","BP_off","AM_WF_on","AM_WF_off","AM_NF_on","GL_on","GL_off"];
%         sigma = [2.5,10.5,3.85,3.85,24,24,6,6*5/4,6].*um;
%         N = zeros(length(n)+1,1);
%         N(2:end) = cumsum(n);

%         for name = names
%             subplot(3, 3, k)
% 
%             viscircles(cell_pos(N(k)+1:N(k+1),1:2), ones(n(k),1) * sigma(k), 'LineWidth', 0.5, 'Color', 'k');
%             xlim([-100e-6, 100e-6])
%             ylim([-100e-6, 100e-6])
%             title(name)
%             axis equal
%             k = k+1;
%         end

    end

end

%%%%% Function cell_list %%%%%
function cell_list = create_list(Populations,Populations_name,cell_pos,B)

    cell_list = [];
    k=1;

    for i=1:length(Populations)
        if Populations(i)==1
                for j=(B(i)+1):B(i+1)
                    cell(j)=Cell(Populations_name(i),[cell_pos(j,1),cell_pos(j,2),cell_pos(j,3)]);
                    cell_list = [cell_list,cell(j)];
                end
        end
    end
end

%%%%% Function degeneration %%%%%
function [cell_list_degen,n_degen] = degeneration(cell_list,Populations,Degeneration,n_new)

    bin_matrix_tot = [];
    for i=1:length(Populations)
        if Populations(i)==1
            rdn_matrix = rand(n_new(i),1);
            bin_matrix = rdn_matrix>=Degeneration(i);
        else
            bin_matrix = zeros(n_new(i),1);
        end
        bin_matrix_tot = [bin_matrix_tot;bin_matrix];
        n_degen(i)=sum(bin_matrix(bin_matrix==1));
    end

    cell_list_degen = cell_list(not(not(bin_matrix_tot)));

end


%%%%% Function connection_syn %%%%%
function cell_list = connection_syn(cell_list,sigma,um,Populations,Populations_connection,B)

    z_extent = 105*um;
    w = waitbar(0,'wait wait');
    for i=1:9
        waitbar(i/9,w,"Make connections")
        if Populations(i) == 1
            for j=(B(i)+1):B(i+1)
                 xy0 = [cell_list(j).x,cell_list(j).y];
                 z0 = cell_list(j).z;
                 p0 = [xy0,z0];
                 idx_post = 1;
                 idx_pre = 1;
                 k = 1;
                 while Populations_connection(i,k) ~= 0
                     if Populations(Populations_connection(i,k)) == 1
                         for l=(B(Populations_connection(i,k))+1):B(Populations_connection(i,k)+1)
                             xy = [cell_list(l).x,cell_list(l).y];
                             z = cell_list(l).z;
                             p = [xy,z];
                             dist_xy = euclidian_distance(xy,xy0);
                             dist_z = euclidian_distance(z,z0);
                             if dist_xy<3*sigma(i) && dist_z<z_extent
                                 if l > j 
                                     cell_list(j).post_syn_subset(idx_post) = l;
                                     cell_list(j).dist_post_syn_subset(idx_post) = euclidian_distance(p,p0);
                                     if i == 1
                                         cell_list(j).pre_syn_subset(idx_pre)= l;
                                         cell_list(j).dist_pre_syn_subset(idx_pre) = euclidian_distance(p,p0);
                                     end
                                     idx_post = idx_post+1;
                                 elseif l < j % Does it need to be changed because l (CR) < j (HRZ) but it is postsynaptic
                                     cell_list(j).pre_syn_subset(idx_pre) = l;
                                     cell_list(j).dist_pre_syn_subset(idx_pre) = euclidian_distance(p,p0);
                                     idx_pre = idx_pre+1;
                                 end
                             end
                         end
                     end
                     k = k+1;
                 end
             end
        end
    end
    close(w)
end

%%%%% Function euclidian_distance %%%%%
function d = euclidian_distance(p,p0)

    d = sqrt(sum((p - p0) .^ 2));

end

%%%%% Function visualize_connection_syn_all_pop %%%%%
function visualize_connection_syn_all_pop(cell_list,um,M)
        
        visualize_connection_syn(cell_list,um,M,3523);
 end

%%%%% Function visualize_connection_syn %%%%%
function visualize_connection_syn(cell_list,um,M,index)

    idx = index;
    if length(cell_list(idx).pre_syn_subset) >= 1 && length(cell_list(idx).post_syn_subset) >= 1
        figure
        plot3(cell_list(idx).x/um,cell_list(idx).y/um,cell_list(idx).z/um,'o','Color',cell_list(idx).color);
        hold on
        for j=1:length(cell_list(idx).pre_syn_subset)
            plot3(cell_list(cell_list(idx).pre_syn_subset(j)).x/um,cell_list(cell_list(idx).pre_syn_subset(j)).y/um,cell_list(cell_list(idx).pre_syn_subset(j)).z/um,'.','Color',cell_list(cell_list(idx).pre_syn_subset(j)).color);
            hold on
        end
        for j=1:length(cell_list(idx).post_syn_subset)
            plot3(cell_list(cell_list(idx).post_syn_subset(j)).x/um,cell_list(cell_list(idx).post_syn_subset(j)).y/um,cell_list(cell_list(idx).post_syn_subset(j)).z/um,'.','Color',cell_list(cell_list(idx).post_syn_subset(j)).color);
            hold on
        end
%         xlim([-200*M 200*M])
%         ylim([-400*M 400*M])
%         zlim([0 210])
        xlabel('x-axis [µm]')
        ylabel('y-axis [µm]')
        zlabel('z-axis [µm]')

    elseif length(cell_list(idx).pre_syn_subset) >= 1
        figure
        plot3(cell_list(idx).x/um,cell_list(idx).y/um,cell_list(idx).z/um,'o','Color',cell_list(idx).color);
        hold on
        for j=1:length(cell_list(idx).pre_syn_subset)
            plot3(cell_list(cell_list(idx).pre_syn_subset(j)).x/um,cell_list(cell_list(idx).pre_syn_subset(j)).y/um,cell_list(cell_list(idx).pre_syn_subset(j)).z/um,'.','Color',cell_list(cell_list(idx).pre_syn_subset(j)).color);
            hold on
        end
%         xlim([-200*M 200*M])
%         ylim([-400*M 400*M])
%         zlim([0 210])
        xlabel('x-axis [µm]')
        ylabel('y-axis [µm]')
        zlabel('z-axis [µm]')
    elseif length(cell_list(idx).post_syn_subset) >= 1
        figure
        plot3(cell_list(idx).x/um,cell_list(idx).y/um,cell_list(idx).z/um,'o','Color',cell_list(idx).color);
        hold on
        for j=1:length(cell_list(idx).post_syn_subset)
            plot3(cell_list(cell_list(idx).post_syn_subset(j)).x/um,cell_list(cell_list(idx).post_syn_subset(j)).y/um,cell_list(cell_list(idx).post_syn_subset(j)).z/um,'.','Color',cell_list(cell_list(idx).post_syn_subset(j)).color);
            hold on
        end
%         xlim([-200*M 200*M])
%         ylim([-400*M 400*M])
%         zlim([0 210])
        xlabel('x-axis [µm]')
        ylabel('y-axis [µm]')
        zlabel('z-axis [µm]')
    end
end

function save_cell_list(cell_list)
%     save('Spatial_model_cell_list','cell_list')
    assignin("base","cell_list",cell_list)
end

function save_pos(mat,name)
%     save("3Dpos","mat")
    if nargin < 2
        assignin("base", "mat3D", mat);
    else
        assignin("base",name,mat)
    end
end

    function [cell_list_gauss_degen,n_gauss_degen] = gaussian_degen(Gauss_degen,cell_list,Populations,n_new,stand_dev,center,vis,Degeneration)
    bin_matrix_tot = [];
    for i=1:length(Populations)
        bin_matrix = [];
        if Populations(i) == 1
            if Gauss_degen(i) == 1
                P = gaussian_prob(n_new,stand_dev,center,vis,i,Degeneration);
                
                rdn_matrix = rand(n_new(i),1);
                for j = 1:n_new(i)
                    bin_matrix(j) = rdn_matrix(j)>=P(j);
                end
                bin_matrix = transpose(bin_matrix);
            else
                bin_matrix = ones(n_new(i),1);
            end
        end
        bin_matrix_tot = [bin_matrix_tot;bin_matrix];
        n_gauss_degen(i)=sum(bin_matrix(bin_matrix==1));
    end               
    cell_list_gauss_degen = cell_list(logical(bin_matrix_tot));
end

    function P = gaussian_prob(n_new,stand_dev,center,vis,i,Degeneration)
    P = [];
    G = gauss2d(n_new,stand_dev,center,vis,i,Degeneration);
    for j = 1:length(G)
        for k = 1:length(G)
            p = G(j,k);
            P = vertcat(P,p);
        end
    end
end

    function G = gauss2d(n_new,stand_dev,center,vis,i,Degeneration)

    size = sqrt(n_new(i));
    index = -floor(size/2):floor(size/2);
    x = index;
    y = index;
    [X,Y]=meshgrid(x,y);
    G = Degeneration(i)*gaussC(X,Y,stand_dev,center,i);

    if vis == 1
        figure
        surf(X,Y,G)
        xlabel('x-axis [Cell index]')
        ylabel('y-axis [Cell index]')
        zlabel('Probability')
    end
end

function val = gaussC(x,y,stand_dev,center,i)
    xc = center(i,1);
    yc = center(i,2);
    exponent = ((x-xc).^2 + (y-yc).^2)./(2*stand_dev(i));
    val       = (exp(-exponent));
end
end