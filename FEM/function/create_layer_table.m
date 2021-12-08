function layer_table = create_layer_table()

    layer_name      = {'vitreous';'rgc';'ipl';'bipolar';'opl';'photo';'rpe';'choroid';'vitreous'};
    layer_thickness = [200; 39; 41; 48; 43; 35; 20; 100; 200]*10^-6;
    layer_cond      = [ 1  0.014  0.059 0.0167 0.05 0.0787 0.0000813 0.04348 1 ]';

    nb_layer = size(layer_name);

    Z=[];
    sum = -200*10^-6;
    %Z is the position of the center of the different layer
    for i = 1:nb_layer
        Z = [ Z  sum+layer_thickness(i)/2];
        sum = sum  + layer_thickness(i);
    end   

    Z=Z';
    %table creation
    layer_table = table(layer_name,layer_thickness,Z,  layer_cond);