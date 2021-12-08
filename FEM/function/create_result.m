function create_result(model)

    model.sol.create('sol1');
    model.sol('sol1').study('std1');
    model.sol('sol1').attach('std1');
    model.sol('sol1').create('st1', 'StudyStep');
    model.sol('sol1').create('v1', 'Variables');
    model.sol('sol1').create('s1', 'Stationary');
    model.sol('sol1').feature('s1').create('fc1', 'FullyCoupled');
    model.sol('sol1').feature('s1').create('i1', 'Iterative');
    model.sol('sol1').feature('s1').feature('i1').create('mg1', 'Multigrid');
    model.sol('sol1').feature('s1').feature.remove('fcDef');

    model.result.create('pg1', 'PlotGroup3D');
    model.result('pg1').create('mslc1', 'Multislice');
    
    
    
    

    model.sol('sol1').attach('std1');
    model.sol('sol1').feature('s1').feature('i1').set('linsolver', 'cg');
    model.sol('sol1').feature('s1').feature('i1').feature('mg1').set('prefun', 'amg');
    model.sol('sol1').runAll;

    %model.result('pg1').label('Electric Potential (ec)');
    %model.result('pg1').set('frametype', 'spatial');
    %model.result('pg1').feature('mslc1').set('resolution', 'normal');