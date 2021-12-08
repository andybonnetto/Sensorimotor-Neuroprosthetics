function create_physics( model, wid, len, idx_inj, idx_ret, injected_current )
    
    comp1 = model.component('comp1');
    
    ec = comp1.physics.create('ec', 'ConductiveMedia', 'geom1');

    ec.create('term1', 'Terminal', 2);
    ec.feature('term1').selection.set(idx_inj);

    ec.create('gnd1', 'Ground', 2);
    ec.feature('gnd1').selection.set(idx_ret);
    
    idx_gnd_bound = [];
    
    
    x1 = -wid/2-10^-6;
    x2 = -wid/2+10^-6;
    y1 = -wid/2-10^-6;
    y2 = wid/2+10^-6;
    z1 = -1000*10^-6;
    z2 = 1000*10^-6;
    idx_gnd_bound = [idx_gnd_bound mphselectbox(model, 'geom1',[x1 x2 ; y1 y2; z1 z2 ],  'boundary' )];
    
    
    x1 = -wid/2-10^-6;
    x2 = +wid/2+10^-6;
    y1 = -wid/2-10^-6;
    y2 = -wid/2+10^-6;
    z1 = -1000*10^-6;
    z2 = 1000*10^-6;
    idx_gnd_bound = [idx_gnd_bound mphselectbox(model, 'geom1',[x1 x2 ; y1 y2; z1 z2 ],  'boundary' )];
   
    x1 = +wid/2-10^-6;
    x2 = +wid/2+10^-6;
    y1 = -wid/2-10^-6;
    y2 = +wid/2+10^-6;
    z1 = -1000*10^-6;
    z2 = 1000*10^-6;
    idx_gnd_bound = [idx_gnd_bound mphselectbox(model, 'geom1',[x1 x2 ; y1 y2; z1 z2 ],  'boundary' )];
    
    x1 = -wid/2-10^-6;
    x2 = +wid/2+10^-6;
    y1 = +wid/2-10^-6;
    y2 = +wid/2+10^-6;
    z1 = -1000*10^-6;
    z2 = 1000*10^-6;
    idx_gnd_bound = [idx_gnd_bound mphselectbox(model, 'geom1',[x1 x2 ; y1 y2; z1 z2 ],  'boundary' )];
    
    ec.create('gnd2', 'Ground', 2);
    ec.feature('gnd2').selection.set(idx_gnd_bound);
    
    
    ec.feature('term1').set('I0', injected_current);  %set current
    
    