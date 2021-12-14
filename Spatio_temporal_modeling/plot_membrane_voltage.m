function plot_membrane_voltage(M_cells,mat3D,Pop_represented,norm_V,path_to_folder)
    import Constants.*
    name_list = ["CR","HRZ","BP_on","BP_off","AM_WF_on","AM_WF_off","AM_NF_on","GL_on","GL_off"];
    names = name_list(logical(Pop_represented));
    % Create spatial plot at time t

    % Declare downsampled resolution
    L = 30;
    H = 30;
    S = 1;
    
    new_L = 500;
    new_H = 500;
    % Declare normalization of real value coefficient
    norm = 7e-4;
%     norm_V = 16e-3;
    
    for t = 1:40:Constants.t_size
        figure()
        k=1;
        for name = names
            subplot(3,3,k);
            type = M_cells.names == name;
            % Get cell positions
            x = mat3D(type,1);
            y = mat3D(type,2);
            % Declare Red and Blue images
            R = ones(H+1,L+1)*0.5;
            B = ones(H+1,L+1)*0.5;
            % Get color matrice for every cells in type
            V_m = M_cells.V_m(type,t);
            V_m_0 = M_cells.V_S(type,end);
            c = round(((V_m-V_m_0)/norm_V)/2*S+0.5,5);
            % Get indice of colored cells
            c_not_zero = not(c == 0.5);
            x_target = x(c_not_zero);
            y_target = y(c_not_zero);
            c_target = c(c_not_zero);
            % Interpolate positions of colored cells on downsampled image
            % pixels
            x_un = round((x_target/norm*L+L/2)+1);
            y_un = round((y_target/norm*H+H/2)+1);
            xy = [x_un,y_un];
            [xy_un,ind_axy,ind_cxy] = unique(xy,"rows");
            % Affiliate colors to Red and Blue images
            for i=1:length(xy_un(:,1))
                R(xy_un(i,1),xy_un(i,2)) = c_target(ind_axy(i));
                B(xy_un(i,1),xy_un(i,2))= 1-c_target(ind_axy(i));
            end
            % Declare Green image and final image
            G = ones(H+1,L+1)*0.5;
            img = ones(H+1,L+1,3)*0.5;
            img(:,:,1) = R;
            img(:,:,2) = G;
            img(:,:,3) = B;
            % Resize image to final resolution (stretch cell colors)
            img = imresize(img,[new_L,new_H]);
            img(:,:,2) = 0.5;
            imshow(img,[0,1]);
            title(name)
            k = k +1;
        end
    file = strcat("V_m ", num2str(t), ".png");
    saveas(gcf,strcat(path_to_folder,file))
    end
    % Create temporal plot at x = 0 for y
    figure()
    k=1;
    % Declare downsampled image size
    H = 15;
    T = Constants.t_size+1;
    new_T = 1000;
    new_H = 500;
    S = 1; %Saturation
    % Declare normalization coefficient
    norm = 7e-4;
%     norm_V = 10e-3;

    for name = names
        subplot(3,3,k);
        type = M_cells.names == name;
        % Get cell position
        x = mat3D(type,1);
        y = mat3D(type,2);
        % Set indices of cells at x=0
        type_x = x==0;
        y = y(type_x);
        % Get colors from Vm
        V_m = M_cells.V_m(type,:);
        V_0 = M_cells.V_S(type,end);
        V_0 = V_0(type_x,:);
        V_m = V_m(type_x,:);
%         c = (((V_m(1,1)-V_m)./abs((min(V_m,[],"all")-max(V_m,[],"all")))*S)+1)/2;
        c = round((((V_m-V_0)/norm_V+3e-3))*S+0.5,5);
        % Find indices of colored cells
        c_not_zero = not(c==0.5);
        y_target = y(c_not_zero(:,200));
        c_target = c(c_not_zero(:,200),:);
        
        % Create image
        img = ones(H,T,3)*0.5;
        [y_sort,inda,indc] = unique(round((y_target/norm)*H+H/2)+1);
        t = 1:T;
        img(y_sort,t,1)=c_target(inda,t);
        img(y_sort,t,3)=1-c_target(inda,t);
        % Resize image to final resolution
        img = imresize(img,[new_H,new_T]);
        img(:,:,2) = 0.5;
        imshow(img,[0,1])
        title(name)
        k = k +1;
    end
    file = strcat("V_m temporal.png");
    saveas(gcf,strcat(path_to_folder,file));
    
    %Create color bar 
    figure()
    H = 10;
    L = 100;
    S = 1;
    img = ones(H,L,3)*0.5;
    c = linspace(0,1,L);
    c = repmat(c,H,1);
    img(:,:,1) = c;
    img(:,:,3) = 1-c;
    imshow(img);

    file = strcat("colorbar.png");
    saveas(gcf,strcat(path_to_folder,file));
    
end