function [idx_inj, idx_ret] = create_electrodes_geom( model, e_table )

    geom1   = model.component('comp1').geom('geom1');

    for i = 1:height(e_table)
        % create workplane at z level
        wp_tag = geom1.feature().uniquetag("wp");
        geom1.create(wp_tag, 'WorkPlane');
        geom1.feature(wp_tag).set('quickz', e_table{i,'Z'});    
        % unite object = false
        geom1.feature(wp_tag).set('unite', false);

        % create circle with given rad and position 
        circle_tag = geom1.feature().uniquetag("c");
        geom1.feature(wp_tag).geom.create(circle_tag, 'Circle');
        geom1.feature(wp_tag).geom.feature(circle_tag).set('pos', [e_table{i,'X'} e_table{i,'Y'}]); 
        geom1.feature(wp_tag).geom.feature(circle_tag).set('r', e_table{i,'rad'});         
    end     

    geom1.run('fin');


    idx_inj=[];
    idx_ret=[];

    for i = 1:height(e_table)
        % create selection of injecting/return boundaries
        x1 = e_table{i,'X'}-e_table{i,'rad'}-10^-6;
        x2 = e_table{i,'X'}+e_table{i,'rad'}+10^-6;
        y1 = e_table{i,'Y'}-e_table{i,'rad'}-10^-6;
        y2 = e_table{i,'Y'}+e_table{i,'rad'}+10^-6;
        z1 = e_table{i,'Z'}-10^-6;
        z2 = e_table{i,'Z'}+10^-6;

        idx_e = mphselectbox(model, 'geom1',[x1 x2 ; y1 y2; z1 z2 ],  'boundary' );

        if e_table{i,'type'} == 'inj'
            idx_inj =  [idx_inj idx_e ];

        elseif e_table{i,'type'} == 'ret'
            idx_ret =  [idx_ret idx_e];

        end
    end