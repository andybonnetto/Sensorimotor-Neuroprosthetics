function plot_membrane_voltage(M_cells,mat3D)
    import Constants.*
    names = ["CR","HRZ","BP_on","BP_off","AM_WF_on","AM_WF_off","AM_NF_on","GL_on","GL_off"];
    
    % Create spatial plot at time t
    figure()
    k=1;
    L = 15;
    H = 15;
    S = 5;
    t = 200;
    norm = 7e-4;
    for name = names
        subplot(3,3,k);
        type = M_cells.names == name;
        x = mat3D(type,1);
        y = mat3D(type,2);
%         type_y = y==0;
%         x = x(type_y);
        R = ones(H+1,L+1)*0.5;
        B = ones(H+1,L+1)*0.5;
        V_m = M_cells.V_m(type,t);
        c = round(((V_m(1,1)-V_m)/(abs(min(V_m,[],"all") - max(V_m,[],"all"))+3e-3))*S+0.5,5);
        c_not_zero = not(c == 0.5);
        x_target = x(c_not_zero);
        y_target = y(c_not_zero);
        c_target = c(c_not_zero);

        x_un = round((x_target/norm*L+L/2)+1);
        y_un = round((y_target/norm*H+H/2)+1);
        xy = [x_un,y_un];
        [xy_un,ind_axy,ind_cxy] = unique(xy,"rows");
        for i=1:length(xy_un(:,1))
            R(xy_un(i,1),xy_un(i,2)) = c_target(ind_axy(i));
            B(xy_un(i,1),xy_un(i,2))= 1-c_target(ind_axy(i));
        end
        G = ones(H+1,L+1)*0.5;
        img = ones(H+1,L+1,3)*0.5;
        img(:,:,1) = R;
        img(:,:,2) = G;
        img(:,:,3) = B;
        img = imresize(img,[500,500]);
        img(:,:,2) = 0.5;
        imshow(img,[0,1]);
%         axis on
%         ticks = 1:10:L+1;
%         ticks_l = num2str(round((ticks/(L+1)*norm)*10^6,3));
%         xticks(ticks);
%         xticklabels(ticks_l);
%         yticks(ticks);
%         yticklabels(ticks_l);
        k = k +1;
    end
    
    % Create temporal plot at x = 0 for y
    figure()
    k=1;
    H = 30;
    T = 2501;
    S = 3; %Saturation
    norm = 7e-4;
    new_T = 1000;
    new_H = 500;

    for name = names
        subplot(3,3,k);
        type = M_cells.names == name;
        x = mat3D(type,1);
        y = mat3D(type,2);
        type_x = x==0;
        y = y(type_x);
        V_m = M_cells.V_m(type,:);
        V_m = V_m(type_x,:);
%         c = (((V_m(1,1)-V_m)./abs((min(V_m,[],"all")-max(V_m,[],"all")))*S)+1)/2;
        c = round(((V_m(1,1)-V_m)/(abs(min(V_m,[],"all") - max(V_m,[],"all"))+3e-3))*S+0.5,5);
        c_not_zero = not(c==0.5);
        y_target = y(c_not_zero(:,200));
        c_target = c(c_not_zero(:,200),:);

        img = ones(H,T,3)*0.5;
        [y_sort,inda,indc] = unique(round((y_target/norm)*H+H/2)+1);
        t = 1:T;
        img(y_sort,t,1)=c_target(inda,t);
        img(y_sort,t,3)=1-c_target(inda,t);

        img = imresize(img,[new_H,new_T]);
        img(:,:,2) = 0.5;
        imshow(img,[0,1])
%         axis on
%         ticks = 1:10:T;
%         ticks_l = num2str(round((ticks/(new_T)*Constants.simulation_duration)*10^3),3);
%         xticks(ticks);
%         xticklabels(ticks_l);
%         ticks = 1:10:H;
%         ticks_l = num2str(round((ticks/(new_H)*norm)*10^3,3));
%         yticks(ticks);
%         yticklabels(ticks_l);
        
        k = k +1;
    end

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
%     axis on
    
end