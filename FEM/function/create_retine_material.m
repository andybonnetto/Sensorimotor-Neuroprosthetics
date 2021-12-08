function create_retine_material( model, wid, len )

    layer_table = create_layer_table();

    %extract unique layer
    [unique_layer_type, ia] = unique(layer_table.layer_name,'first');


    %empty cell array
    idx = cell(height(layer_table),1);
    idx_unique = cell(length(unique_layer_type),1);

    %conductivity array for each material
    conductivity  = layer_table.layer_cond(ia);

    for i = 1:height(layer_table)
        % creer selection des injecting 1)
        x1 = -wid/2;
        x2 = +wid/2;
        y1 = -len/2;
        y2 = +len/2;
        z1 = layer_table{i,'Z'}-layer_table{i,'layer_thickness'}/2-10^-6;
        z2 = layer_table{i,'Z'}+layer_table{i,'layer_thickness'}/2+10^-6;

        idx{i} = mphselectbox(model, 'geom1',[x1 x2 ; y1 y2; z1 z2 ],  'domain' );

    end



    for i = 1:length(unique_layer_type)
        for j=1:length(layer_table.layer_name)
            if string(unique_layer_type(i))==string(layer_table.layer_name(j))       
                idx_unique{i}=[idx_unique{i} idx{j}];  
            end  
        end
    end



    for i = 1:length(unique_layer_type)

        %"creating  " +  char(unique_layer_type(i))
        temp_cond = char(string(conductivity(i)));
        model.component('comp1').material.create(char(unique_layer_type(i)), 'Common');
        model.component('comp1').material( char(unique_layer_type(i)) ).selection.set(idx_unique{i});
        model.component('comp1').material( char(unique_layer_type(i)) ).propertyGroup('def').set('relpermittivity', {'1' '0' '0' '0' '1' '0' '0' '0' '1'});
        model.component('comp1').material( char(unique_layer_type(i)) ).propertyGroup('def').set('electricconductivity', {temp_cond '0' '0' '0' temp_cond '0' '0' '0' temp_cond});
    end
