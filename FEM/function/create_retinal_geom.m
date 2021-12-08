function create_retinal_geom( model, wid, len )

    layer_table = create_layer_table()
    
    geom1   = model.component('comp1').geom('geom1');

    for i = 1:height(layer_table) 
        blk_tag = geom1.feature().uniquetag("blk");
        geom1.create(blk_tag, 'Block');
        geom1.feature(blk_tag).set('pos', {'0' '0' char(string(layer_table.Z(i)))});
        geom1.feature(blk_tag).set('base', 'center');
        geom1.feature(blk_tag).set('size', {char(string(wid)) char(string(len)) char(string(layer_table.layer_thickness(i)))});
    end

    model.component('comp1').geom('geom1').run('fin');
end