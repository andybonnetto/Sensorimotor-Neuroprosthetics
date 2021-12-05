function plot_membrane_voltage(M_cells,mat3D)
    import Constants.*
%     figure()
%     k = 1;
%     resolution = 700;
%     background = ones(resolution,resolution)*127;
    names = ["CR","HRZ","BP_on","BP_off","AM_WF_on","AM_WF_off","AM_NF_on","GL_on","GL_off"];
%     figure()
%     k=1;
%     for name = names
%         subplot(3,3,k);
%         type = M_cells.names == name;
%         x = mat3D(type,1);
%         y = mat3D(type,2);
%         V_m = M_cells.V_m(type,end);
%         c = (((V_m(1,1)-V_m)./abs((min(V_m,[],"all")-max(V_m,[],"all"))))+1)/2;
%         img = ones(200,200,3)*0.5;
%         [y_sort,inda_y,indc_y] = unique(round((y/abs(min(y)-max(y))+min(y)+1)*80));
%         [x_sort,inda_x,indc_x] = unique(round((x/abs(min(x)-max(x))+min(x)+1)*80));
%         img(y_sort,x_sort,1)=c(inda_y,inda);
%         img(y_sort,t,3)=1-c(inda,t);
%         imshow(img)
% 
%         k = k +1;
%     end

    figure()
    k=1;
    for name = names
        subplot(3,3,k);
        type = M_cells.names == name;
        x = mat3D(type,1);
        y = mat3D(type,2);
        type_x = x==0;
        y = y(type_x);
        V_m = M_cells.V_m(type,:);
        V_m = V_m(type_x,:);
        c = (((V_m(1,1)-V_m)./abs((min(V_m,[],"all")-max(V_m,[],"all"))))+1)/2;
        img = ones(120,1000,3)*0.5;
        [y_sort,inda,indc] = unique(round((y/abs(min(y)-max(y))+min(y)+1)*80));
        t = 1:1000;
        img(y_sort,t,1)=c(inda,t);
        img(y_sort,t,3)=1-c(inda,t);
        imshow(img)

        k = k +1;
    end
    
end