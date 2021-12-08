function out = model
%
% modele_retine.m
%
% Model exported on Nov 22 2021, 19:25 by COMSOL 5.3.1.201.

import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('Model');

model.modelPath('C:\Users\Valentin\Desktop\Comsol_neuro');

model.label('modele_retine.mph');

model.param.set('wid', ['300[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm]']);
model.param.set('len', ['300[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm]']);
model.param.set('rgc', ['39[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm]']);
model.param.set('ipl', ['41[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm]']);
model.param.set('bipolar', ['48[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm]']);
model.param.set('opl', ['43[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm]']);
model.param.set('photo', ['35[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm]']);
model.param.set('vitreous', ['200[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm]']);
model.param.set('RPE', ['20[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm]']);
model.param.set('choroid', ['100[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm]']);
model.param.set('vitreous_hei', ['-200[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm]']);
model.param.set('rgc_hei', ['0[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm]']);
model.param.set('ipl_hei', ['39[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm]']);
model.param.set('bipolar_hei', ['39[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm]+41[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm]']);
model.param.set('opl_hei', ['80[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm]+48[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm]']);
model.param.set('photo_hei', ['80[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm]+48[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm]+43[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm]']);
model.param.set('RPE_hei', ['80[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm]+48[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm]+43[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm]+35[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm]']);
model.param.set('choroid_hei', ['80[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm]+48[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm]+43[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm]+35[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm]+20[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm]']);
model.param.set('e_area', 'radius*radius*3.14');
model.param.set('radius', ['20[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm]']);
model.param.set('current_density', ['1[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'A]/e_area']);
model.param.set('imped', '0.000001[S/m]');
model.param.set('e_hei', ['190[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm]']);

model.component.create('comp1', true);

model.component('comp1').geom.create('geom1', 3);

model.result.table.create('tbl1', 'Table');
model.result.table.create('evl2', 'Table');

model.component('comp1').mesh.create('mesh1');

model.component('comp1').geom('geom1').selection.create('csel1', 'CumulativeSelection');
model.component('comp1').geom('geom1').selection('csel1').label('Cumulative Selection 1');
model.component('comp1').geom('geom1').create('blk2', 'Block');
model.component('comp1').geom('geom1').feature('blk2').label('vitreous');
model.component('comp1').geom('geom1').feature('blk2').set('pos', {'0' '0' 'vitreous_hei+vitreous/2'});
model.component('comp1').geom('geom1').feature('blk2').set('base', 'center');
model.component('comp1').geom('geom1').feature('blk2').set('size', {'wid' 'len' 'vitreous'});
model.component('comp1').geom('geom1').create('blk1', 'Block');
model.component('comp1').geom('geom1').feature('blk1').label('rgc');
model.component('comp1').geom('geom1').feature('blk1').set('pos', {'0' '0' 'rgc_hei+rgc/2'});
model.component('comp1').geom('geom1').feature('blk1').set('base', 'center');
model.component('comp1').geom('geom1').feature('blk1').set('size', {'wid' 'len' 'rgc'});
model.component('comp1').geom('geom1').create('blk3', 'Block');
model.component('comp1').geom('geom1').feature('blk3').label('ipl');
model.component('comp1').geom('geom1').feature('blk3').set('pos', {'0' '0' 'ipl_hei+ipl/2'});
model.component('comp1').geom('geom1').feature('blk3').set('base', 'center');
model.component('comp1').geom('geom1').feature('blk3').set('size', {'wid' 'len' 'ipl'});
model.component('comp1').geom('geom1').create('blk4', 'Block');
model.component('comp1').geom('geom1').feature('blk4').label('bipolar');
model.component('comp1').geom('geom1').feature('blk4').set('contributeto', 'csel1');
model.component('comp1').geom('geom1').feature('blk4').set('pos', {'0' '0' 'bipolar_hei+bipolar/2'});
model.component('comp1').geom('geom1').feature('blk4').set('base', 'center');
model.component('comp1').geom('geom1').feature('blk4').set('size', {'wid' 'len' 'bipolar'});
model.component('comp1').geom('geom1').create('blk5', 'Block');
model.component('comp1').geom('geom1').feature('blk5').label('opl');
model.component('comp1').geom('geom1').feature('blk5').set('pos', {'0' '0' 'opl_hei+opl/2'});
model.component('comp1').geom('geom1').feature('blk5').set('base', 'center');
model.component('comp1').geom('geom1').feature('blk5').set('size', {'wid' 'len' 'opl'});
model.component('comp1').geom('geom1').create('blk6', 'Block');
model.component('comp1').geom('geom1').feature('blk6').label('photo');
model.component('comp1').geom('geom1').feature('blk6').set('pos', {'0' '0' 'photo_hei+photo/2'});
model.component('comp1').geom('geom1').feature('blk6').set('base', 'center');
model.component('comp1').geom('geom1').feature('blk6').set('size', {'wid' 'len' 'photo'});
model.component('comp1').geom('geom1').create('blk7', 'Block');
model.component('comp1').geom('geom1').feature('blk7').label('rpe');
model.component('comp1').geom('geom1').feature('blk7').set('pos', {'0' '0' 'RPE_hei+RPE/2'});
model.component('comp1').geom('geom1').feature('blk7').set('base', 'center');
model.component('comp1').geom('geom1').feature('blk7').set('size', {'wid' 'len' 'RPE'});
model.component('comp1').geom('geom1').create('blk8', 'Block');
model.component('comp1').geom('geom1').feature('blk8').label('choroid');
model.component('comp1').geom('geom1').feature('blk8').set('pos', {'0' '0' 'choroid_hei+choroid/2'});
model.component('comp1').geom('geom1').feature('blk8').set('base', 'center');
model.component('comp1').geom('geom1').feature('blk8').set('size', {'wid' 'len' 'choroid'});
model.component('comp1').geom('geom1').create('blk9', 'Block');
model.component('comp1').geom('geom1').feature('blk9').label('vitreous_top');
model.component('comp1').geom('geom1').feature('blk9').set('pos', {'0' '0' ['choroid_hei+100[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm]+vitreous/2']});
model.component('comp1').geom('geom1').feature('blk9').set('base', 'center');
model.component('comp1').geom('geom1').feature('blk9').set('size', {'wid' 'len' 'vitreous'});
model.component('comp1').geom('geom1').create('cyl1', 'Cylinder');
model.component('comp1').geom('geom1').feature('cyl1').label('electrode_center');
model.component('comp1').geom('geom1').feature('cyl1').set('pos', {'0' '0' ['-200[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm]']});
model.component('comp1').geom('geom1').feature('cyl1').set('r', 'radius');
model.component('comp1').geom('geom1').feature('cyl1').set('h', 'e_hei');
model.component('comp1').geom('geom1').create('cyl2', 'Cylinder');
model.component('comp1').geom('geom1').feature('cyl2').label('electrode_return');
model.component('comp1').geom('geom1').feature('cyl2').set('pos', {['50[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm]'] ['50[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm]'] ['-200[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm]']});
model.component('comp1').geom('geom1').feature('cyl2').set('r', 'radius');
model.component('comp1').geom('geom1').feature('cyl2').set('h', 'e_hei');
model.component('comp1').geom('geom1').create('cyl3', 'Cylinder');
model.component('comp1').geom('geom1').feature('cyl3').active(false);
model.component('comp1').geom('geom1').feature('cyl3').label('electrode_return 1');
model.component('comp1').geom('geom1').feature('cyl3').set('pos', {['50[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm]'] ['-50[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm]'] ['-200[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm]']});
model.component('comp1').geom('geom1').feature('cyl3').set('r', 'radius');
model.component('comp1').geom('geom1').feature('cyl3').set('h', 'e_hei');
model.component('comp1').geom('geom1').create('dif2', 'Difference');
model.component('comp1').geom('geom1').feature('dif2').selection('input').set({'blk1' 'blk2' 'blk3' 'blk4' 'blk5' 'blk6' 'blk7' 'blk8' 'blk9'});
model.component('comp1').geom('geom1').feature('dif2').selection('input2').set({'cyl1' 'cyl2' 'cyl3'});
model.component('comp1').geom('geom1').create('blk10', 'Block');
model.component('comp1').geom('geom1').feature('blk10').active(false);
model.component('comp1').geom('geom1').feature('blk10').label('shell_inside');
model.component('comp1').geom('geom1').feature('blk10').set('pos', {'0' '0' ['-200[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm]+(choroid_hei+100[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm]+400[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm])/2']});
model.component('comp1').geom('geom1').feature('blk10').set('base', 'center');
model.component('comp1').geom('geom1').feature('blk10').set('size', {'wid' 'len' ['choroid_hei+100[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm]+400[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm]']});
model.component('comp1').geom('geom1').create('blk11', 'Block');
model.component('comp1').geom('geom1').feature('blk11').active(false);
model.component('comp1').geom('geom1').feature('blk11').label('shell');
model.component('comp1').geom('geom1').feature('blk11').set('pos', {'0' '0' ['-200[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm]+(choroid_hei+100[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm]+400[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm])/2']});
model.component('comp1').geom('geom1').feature('blk11').set('base', 'center');
model.component('comp1').geom('geom1').feature('blk11').set('size', {['wid+10[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm]'] ['len+10[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm]'] ['choroid_hei+100[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm]+400[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm]']});
model.component('comp1').geom('geom1').create('dif1', 'Difference');
model.component('comp1').geom('geom1').feature('dif1').active(false);
model.component('comp1').geom('geom1').feature('dif1').selection('input').set({'blk11'});
model.component('comp1').geom('geom1').feature('dif1').selection('input2').set({'blk10'});
model.component('comp1').geom('geom1').run;
model.component('comp1').geom('geom1').run('fin');

model.view.create('view2', 2);
model.view.create('view3', 2);
model.view.create('view4', 2);
model.view.create('view5', 2);

model.component('comp1').material.create('mat2', 'Common');
model.component('comp1').material.create('mat3', 'Common');
model.component('comp1').material.create('mat4', 'Common');
model.component('comp1').material.create('mat5', 'Common');
model.component('comp1').material.create('mat6', 'Common');
model.component('comp1').material.create('mat7', 'Common');
model.component('comp1').material.create('mat8', 'Common');
model.component('comp1').material.create('mat9', 'Common');
model.component('comp1').material.create('mat10', 'Common');
model.component('comp1').material.create('mat11', 'Common');
model.component('comp1').material('mat3').selection.set([2]);
model.component('comp1').material('mat4').selection.set([3]);
model.component('comp1').material('mat5').selection.set([4]);
model.component('comp1').material('mat6').propertyGroup('def').func.create('k', 'Piecewise');
model.component('comp1').material('mat6').propertyGroup('def').func.create('res_solid_1', 'Piecewise');
model.component('comp1').material('mat6').propertyGroup('def').func.create('alpha_solid_1', 'Piecewise');
model.component('comp1').material('mat6').propertyGroup('def').func.create('C_solid_1', 'Piecewise');
model.component('comp1').material('mat6').propertyGroup('def').func.create('sigma_solid_1', 'Piecewise');
model.component('comp1').material('mat6').propertyGroup('def').func.create('HC_solid_1', 'Piecewise');
model.component('comp1').material('mat6').propertyGroup('def').func.create('VP_solid_1', 'Piecewise');
model.component('comp1').material('mat6').propertyGroup('def').func.create('epsilon', 'Piecewise');
model.component('comp1').material('mat6').propertyGroup('def').func.create('rho_solid_1', 'Piecewise');
model.component('comp1').material('mat6').propertyGroup('def').func.create('TD', 'Piecewise');
model.component('comp1').material('mat6').propertyGroup.create('ThermalExpansion', 'Thermal expansion');
model.component('comp1').material('mat6').propertyGroup('ThermalExpansion').func.create('dL_solid_1', 'Piecewise');
model.component('comp1').material('mat6').propertyGroup.create('Enu', 'Young''s modulus and Poisson''s ratio');
model.component('comp1').material('mat6').propertyGroup('Enu').func.create('E', 'Piecewise');
model.component('comp1').material('mat6').propertyGroup('Enu').func.create('nu', 'Piecewise');
model.component('comp1').material('mat6').propertyGroup.create('KG', 'Bulk modulus and shear modulus');
model.component('comp1').material('mat6').propertyGroup('KG').func.create('mu', 'Piecewise');
model.component('comp1').material('mat6').propertyGroup('KG').func.create('kappa', 'Piecewise');
model.component('comp1').material('mat7').selection.set([5]);
model.component('comp1').material('mat8').selection.set([6]);
model.component('comp1').material('mat9').selection.set([7]);
model.component('comp1').material('mat10').selection.set([8]);

model.component('comp1').physics.create('ec', 'ConductiveMedia', 'geom1');
model.component('comp1').physics('ec').create('dimp1', 'DistributedImpedance', 2);
model.component('comp1').physics('ec').feature('dimp1').selection.set([1 2 4 5 7 8 10 11 13 14 16 17 19 20 22 23 25 26 29 30 31 32 33 34 35 36 37 48 49 50 51 52 53 54 55 56]);
model.component('comp1').physics('ec').create('gnd1', 'Ground', 2);
model.component('comp1').physics('ec').feature('gnd1').selection.set([1 2 3 4 5 7 8 10 11 12 13 14 16 17 19 20 22 23 24 25 26 28 29 30 31 32 33 34 35 36 37 48 49 50 52 53 54 55 56]);
model.component('comp1').physics('ec').create('ncd1', 'NormalCurrentDensity', 2);
model.component('comp1').physics('ec').feature('ncd1').selection.set([40]);
model.component('comp1').physics('ec').create('ncd2', 'NormalCurrentDensity', 2);
model.component('comp1').physics('ec').feature('ncd2').selection.set([45]);
model.component('comp1').physics('ec').create('ci1', 'ContactImpedance', 2);
model.component('comp1').physics('ec').feature('ci1').selection.set([1 2 4 5 7 8 10 11 13 14 16 17 19 20 22 23 25 26 29 30 31 32 33 34 35 36 37 48 49 50 51 52 53 54 55 56]);

model.component('comp1').mesh('mesh1').autoMeshSize(1);


model.result.table('tbl1').comments('Point Evaluation 1 (V)');
model.result.table('evl2').label('Evaluation 2D');
model.result.table('evl2').comments('Interactive 2D values');

model.component('comp1').view('view1').set('transparency', true);
model.view('view2').axis.set('xmin', -2.966569154523313E-4);
model.view('view2').axis.set('xmax', 6.226568948477507E-4);
model.view('view2').axis.set('ymin', -2.227386285085231E-4);
model.view('view2').axis.set('ymax', 2.227386285085231E-4);
model.view('view2').axis.set('abstractviewlratio', -0.2712748348712921);
model.view('view2').axis.set('abstractviewrratio', 0.2712748348712921);
model.view('view2').axis.set('abstractviewbratio', -0.04999999701976776);
model.view('view2').axis.set('abstractviewtratio', 0.04999999701976776);
model.view('view2').axis.set('abstractviewxscale', 3.4602649634507543E-7);
model.view('view2').axis.set('abstractviewyscale', 3.4602649634507543E-7);
model.view('view3').axis.set('xmin', -2.8744354494847357E-4);
model.view('view3').axis.set('xmax', 2.8911454137414694E-4);
model.view('view3').axis.set('ymin', -1.3967488484922796E-4);
model.view('view3').axis.set('ymax', 1.3971125008538365E-4);
model.view('view3').axis.set('abstractviewlratio', 0.1071508601307869);
model.view('view3').axis.set('abstractviewrratio', -0.10158086568117142);
model.view('view3').axis.set('abstractviewbratio', 0.03441709280014038);
model.view('view3').axis.set('abstractviewtratio', -0.034295860677957535);
model.view('view3').axis.set('abstractviewxscale', 9.931555950970505E-7);
model.view('view3').axis.set('abstractviewyscale', 9.93155822470726E-7);
model.view('view4').axis.set('xmin', -3.965333744417876E-4);
model.view('view4').axis.set('xmax', 7.225333247333765E-4);
model.view('view4').axis.set('ymin', -2.2653673659078777E-4);
model.view('view4').axis.set('ymax', 2.2653673659078777E-4);
model.view('view4').axis.set('abstractviewlratio', -0.16328555345535278);
model.view('view4').axis.set('abstractviewrratio', 0.16328555345535278);
model.view('view4').axis.set('abstractviewbratio', -0.04999999329447746);
model.view('view4').axis.set('abstractviewtratio', 0.04999999329447746);
model.view('view4').axis.set('abstractviewxscale', 1.237905735251843E-6);
model.view('view4').axis.set('abstractviewyscale', 1.237905735251843E-6);
model.view('view5').axis.set('xmin', -3.4050398971885443E-4);
model.view('view5').axis.set('xmax', 3.4050398971885443E-4);
model.view('view5').axis.set('ymin', -1.6500000492669642E-4);
model.view('view5').axis.set('ymax', 1.6500000492669642E-4);
model.view('view5').axis.set('abstractviewlratio', -0.635013222694397);
model.view('view5').axis.set('abstractviewrratio', 0.635013222694397);
model.view('view5').axis.set('abstractviewbratio', -0.049999989569187164);
model.view('view5').axis.set('abstractviewtratio', 0.049999989569187164);
model.view('view5').axis.set('abstractviewxscale', 8.753315796639072E-7);
model.view('view5').axis.set('abstractviewyscale', 8.753315796639072E-7);

model.component('comp1').material('mat2').label('vitreous');
model.component('comp1').material('mat2').set('family', 'custom');
model.component('comp1').material('mat2').set('specular', 'custom');
model.component('comp1').material('mat2').set('customspecular', [0.5176470875740051 0.7607843279838562 0.9176470637321472]);
model.component('comp1').material('mat2').set('diffuse', 'custom');
model.component('comp1').material('mat2').set('customdiffuse', [0.5176470875740051 0.7607843279838562 0.9176470637321472]);
model.component('comp1').material('mat2').set('ambient', 'custom');
model.component('comp1').material('mat2').set('customambient', [0.9803921580314636 0.9411764740943909 0.9019607901573181]);
model.component('comp1').material('mat2').set('noise', true);
model.component('comp1').material('mat2').set('noisefreq', 1);
model.component('comp1').material('mat2').set('lighting', 'phong');
model.component('comp1').material('mat2').set('shininess', 64);
model.component('comp1').material('mat2').propertyGroup('def').set('relpermittivity', {'1' '0' '0' '0' '1' '0' '0' '0' '1'});
model.component('comp1').material('mat2').propertyGroup('def').set('electricconductivity', {'1' '0' '0' '0' '1' '0' '0' '0' '1'});
model.component('comp1').material('mat3').label('rgc');
model.component('comp1').material('mat3').set('family', 'custom');
model.component('comp1').material('mat3').set('specular', 'custom');
model.component('comp1').material('mat3').set('customspecular', [0.6980392336845398 0.13333334028720856 0.13333334028720856]);
model.component('comp1').material('mat3').set('diffuse', 'custom');
model.component('comp1').material('mat3').set('customdiffuse', [0.6980392336845398 0.13333334028720856 0.13333334028720856]);
model.component('comp1').material('mat3').set('ambient', 'custom');
model.component('comp1').material('mat3').set('customambient', [0.03529411926865578 0.4627451002597809 0.03529411926865578]);
model.component('comp1').material('mat3').set('noise', true);
model.component('comp1').material('mat3').set('noisefreq', 1);
model.component('comp1').material('mat3').set('lighting', 'cooktorrance');
model.component('comp1').material('mat3').set('fresnel', 0.99);
model.component('comp1').material('mat3').set('roughness', 0.07);
model.component('comp1').material('mat3').propertyGroup('def').set('relpermittivity', {'1' '0' '0' '0' '1' '0' '0' '0' '1'});
model.component('comp1').material('mat3').propertyGroup('def').set('electricconductivity', {'0.014' '0' '0' '0' '0.014' '0' '0' '0' '0.014'});
model.component('comp1').material('mat4').label('ipl');
model.component('comp1').material('mat4').set('family', 'custom');
model.component('comp1').material('mat4').set('specular', 'custom');
model.component('comp1').material('mat4').set('customspecular', [1 0.8196078538894653 0.3607843220233917]);
model.component('comp1').material('mat4').set('diffuse', 'custom');
model.component('comp1').material('mat4').set('customdiffuse', [1 0.8196078538894653 0.3607843220233917]);
model.component('comp1').material('mat4').set('ambient', 'custom');
model.component('comp1').material('mat4').set('customambient', [1 0.8196078538894653 0.3607843220233917]);
model.component('comp1').material('mat4').set('noise', true);
model.component('comp1').material('mat4').set('noisefreq', 1);
model.component('comp1').material('mat4').set('lighting', 'phong');
model.component('comp1').material('mat4').set('shininess', 64);
model.component('comp1').material('mat4').propertyGroup('def').set('relpermittivity', {'1' '0' '0' '0' '1' '0' '0' '0' '1'});
model.component('comp1').material('mat4').propertyGroup('def').set('electricconductivity', {'0.0549' '0' '0' '0' '0.0549' '0' '0' '0' '0.0549'});
model.component('comp1').material('mat5').label('bipolar');
model.component('comp1').material('mat5').set('family', 'custom');
model.component('comp1').material('mat5').set('specular', 'custom');
model.component('comp1').material('mat5').set('customspecular', [0.7529411911964417 0.7529411911964417 0.7529411911964417]);
model.component('comp1').material('mat5').set('diffuse', 'custom');
model.component('comp1').material('mat5').set('customdiffuse', [0.7529411911964417 0.7529411911964417 0.7529411911964417]);
model.component('comp1').material('mat5').set('ambient', 'custom');
model.component('comp1').material('mat5').set('customambient', [0.7529411911964417 0.7529411911964417 0.7529411911964417]);
model.component('comp1').material('mat5').set('noise', true);
model.component('comp1').material('mat5').set('noisefreq', 1);
model.component('comp1').material('mat5').set('lighting', 'phong');
model.component('comp1').material('mat5').set('shininess', 64);
model.component('comp1').material('mat5').propertyGroup('def').set('relpermittivity', {'1' '0' '0' '0' '1' '0' '0' '0' '1'});
model.component('comp1').material('mat5').propertyGroup('def').set('electricconductivity', {'0.0167' '0' '0' '0' '0.0167' '0' '0' '0' '0.0167'});
model.component('comp1').material('mat6').active(false);
model.component('comp1').material('mat6').label('Platinum [solid]');
model.component('comp1').material('mat6').set('family', 'custom');
model.component('comp1').material('mat6').set('specular', 'custom');
model.component('comp1').material('mat6').set('customspecular', [0.7843137254901961 1 1]);
model.component('comp1').material('mat6').set('diffuse', 'custom');
model.component('comp1').material('mat6').set('customdiffuse', [0.7843137254901961 0.7843137254901961 0.7843137254901961]);
model.component('comp1').material('mat6').set('ambient', 'custom');
model.component('comp1').material('mat6').set('customambient', [0.7843137254901961 0.7843137254901961 0.7843137254901961]);
model.component('comp1').material('mat6').set('noise', true);
model.component('comp1').material('mat6').set('noisefreq', 1);
model.component('comp1').material('mat6').set('lighting', 'cooktorrance');
model.component('comp1').material('mat6').set('fresnel', 0.9);
model.component('comp1').material('mat6').propertyGroup('def').func('k').set('arg', 'T');
model.component('comp1').material('mat6').propertyGroup('def').func('k').set('pieces', {'0.0' '13.6' '209.6991*T^1+18.16709*T^2-4.678988*T^3+0.2278691*T^4-0.002748296*T^5';  ...
'13.6' '50.0' '2978.797-201.1759*T^1+3.362113*T^2+0.0713319*T^3-0.002761393*T^4+2.280531E-5*T^5';  ...
'50.0' '100.0' '1212.843-69.25658*T^1+1.763533*T^2-0.0228956*T^3+1.494028E-4*T^4-3.889706E-7*T^5';  ...
'100.0' '285.0' '123.3886-1.066855*T^1+0.009646914*T^2-4.536814E-5*T^3+1.072687E-7*T^4-1.004522E-10*T^5';  ...
'285.0' '2045.0' '73.99627-0.01557887*T^1+2.646931E-5*T^2-6.133801E-9*T^3'});
model.component('comp1').material('mat6').propertyGroup('def').func('res_solid_1').set('arg', 'T');
model.component('comp1').material('mat6').propertyGroup('def').func('res_solid_1').set('pieces', {'14.0' '47.0' '-5.497611E-10+1.415797E-10*T^1-1.305787E-11*T^2+5.545444E-13*T^3-7.41428E-15*T^4+3.513902E-17*T^5';  ...
'47.0' '160.0' '1.845544E-9-3.44008E-10*T^1+1.431636E-11*T^2-1.250757E-13*T^3+5.330375E-16*T^4-8.95938E-19*T^5';  ...
'160.0' '600.0' '-1.927892E-8+5.233699E-10*T^1-4.107885E-13*T^2+6.694129E-16*T^3-4.447775E-19*T^4';  ...
'600.0' '2000.0' '-4.843579E-8+5.552497E-10*T^1-1.600249E-13*T^2+2.814022E-17*T^3'});
model.component('comp1').material('mat6').propertyGroup('def').func('alpha_solid_1').set('arg', 'T');
model.component('comp1').material('mat6').propertyGroup('def').func('alpha_solid_1').set('pieces', {'0.0' '66.0' '6.562827E-6+2.345522E-8*T^1+1.067424E-10*T^2-3.40817E-12*T^3+1.084047E-14*T^4+7.298473E-17*T^5'; '66.0' '227.0' '6.867919E-6+1.945355E-8*T^1-6.698432E-11*T^2+1.199734E-13*T^3-1.069967E-16*T^4'; '227.0' '1973.0' '8.801519E-6+4.097477E-10*T^1+1.248065E-12*T^2-7.133932E-16*T^3+1.689741E-19*T^4'});
model.component('comp1').material('mat6').propertyGroup('def').func('C_solid_1').set('arg', 'T');
model.component('comp1').material('mat6').propertyGroup('def').func('C_solid_1').set('pieces', {'0.0' '19.0' '0.03281349*T^1+0.001129466*T^2+3.449445E-4*T^3+5.174165E-5*T^4-1.325633E-6*T^5';  ...
'19.0' '119.0' '10.30393-1.986516*T^1+0.1283953*T^2-0.002010741*T^3+1.359791E-5*T^4-3.445457E-8*T^5';  ...
'119.0' '290.0' '0.4467027+1.721765*T^1-0.009418853*T^2+2.453936E-5*T^3-2.455881E-8*T^4';  ...
'290.0' '2000.0' '122.2187+0.03986346*T^1-1.836174E-5*T^2+7.556773E-9*T^3'});
model.component('comp1').material('mat6').propertyGroup('def').func('sigma_solid_1').set('arg', 'T');
model.component('comp1').material('mat6').propertyGroup('def').func('sigma_solid_1').set('pieces', {'14.0' '47.0' '1/(3.513902E-17*T^5-7.414280E-15*T^4+5.545444E-13*T^3-1.305787E-11*T^2+1.415797E-10*T-5.497611E-10)';  ...
'47.0' '160.0' '1/(-8.959380E-19*T^5+5.330375E-16*T^4-1.250757E-13*T^3+1.431636E-11*T^2-3.440080E-10*T+1.845544E-09)';  ...
'160.0' '600.0' '1/(-4.447775E-19*T^4+6.694129E-16*T^3-4.107885E-13*T^2+5.233699E-10*T-1.927892E-08)';  ...
'600.0' '2000.0' '1/(2.814022E-17*T^3-1.600249E-13*T^2+5.552497E-10*T-4.843579E-08)'});
model.component('comp1').material('mat6').propertyGroup('def').func('HC_solid_1').set('arg', 'T');
model.component('comp1').material('mat6').propertyGroup('def').func('HC_solid_1').set('pieces', {'0.0' '19.0' '0.006401583*T^1+2.203475E-4*T^2+6.72952E-5*T^3+1.009428E-5*T^4-2.586177E-7*T^5';  ...
'19.0' '119.0' '2.018562-0.3875494*T^1+0.02504865*T^2-3.922754E-4*T^3+2.652817E-6*T^4-6.721742E-9*T^5';  ...
'119.0' '290.0' '0.08714724+0.3358992*T^1-0.001837525*T^2+4.787383E-6*T^3-4.791178E-9*T^4';  ...
'290.0' '2000.0' '23.84364+0.007776964*T^1-3.582192E-6*T^2+1.47425E-9*T^3'});
model.component('comp1').material('mat6').propertyGroup('def').func('VP_solid_1').set('arg', 'T');
model.component('comp1').material('mat6').propertyGroup('def').func('VP_solid_1').set('pieces', {'293.0' '2041.0' '(exp((-2.938700e+04/T+1.103900e+00*log10(T)+7.762810e+00-4.527000e-01/T^3)*log(10.0)))*1.333200e+02'});
model.component('comp1').material('mat6').propertyGroup('def').func('epsilon').set('arg', 'T');
model.component('comp1').material('mat6').propertyGroup('def').func('epsilon').set('pieces', {'1000.0' '2000.0' '0.1248438+6.688811E-5*T^1+5.827506E-10*T^2'});
model.component('comp1').material('mat6').propertyGroup('def').func('rho_solid_1').set('arg', 'T');
model.component('comp1').material('mat6').propertyGroup('def').func('rho_solid_1').set('pieces', {'0.0' '10.0' '21512.11';  ...
'10.0' '70.0' '21512.45-0.07336997*T^1+0.005824972*T^2-2.116082E-4*T^3+2.17523E-6*T^4-8.010422E-9*T^5';  ...
'70.0' '280.0' '21510.32+0.1433013*T^1-0.00470128*T^2+1.502256E-5*T^3-1.883994E-8*T^4';  ...
'280.0' '1973.0' '21557.19-0.5675783*T^1-1.7525E-5*T^2-3.171806E-8*T^3+4.698968E-12*T^4'});
model.component('comp1').material('mat6').propertyGroup('def').func('TD').set('arg', 'T');
model.component('comp1').material('mat6').propertyGroup('def').func('TD').set('pieces', {'1.0' '13.0' '0.28943+0.02978421*T^1-0.01910933*T^2+0.002338801*T^3-1.192084E-4*T^4+2.259771E-6*T^5';  ...
'13.0' '26.0' '0.479876-0.09317326*T^1+0.00742796*T^2-3.009776E-4*T^3+6.158414E-6*T^4-5.06774E-8*T^5';  ...
'26.0' '47.0' '0.04400487-0.005080433*T^1+2.385187E-4*T^2-5.637839E-6*T^3+6.679134E-8*T^4-3.165162E-10*T^5';  ...
'47.0' '125.0' '0.001066481-4.888577E-5*T^1+9.559252E-7*T^2-9.500665E-9*T^3+4.750364E-11*T^4-9.509351E-14*T^5';  ...
'125.0' '320.0' '9.16865E-5-1.137641E-6*T^1+8.445007E-9*T^2-3.265918E-11*T^3+6.395616E-14*T^4-4.999866E-17*T^5';  ...
'320.0' '1973.0' '2.79405E-5-1.315728E-8*T^1+1.500886E-11*T^2-5.443494E-15*T^3+5.128524E-19*T^4-5.706943E-24*T^5'});
model.component('comp1').material('mat6').propertyGroup('def').set('thermalconductivity', {'k(T[1/K])[W/(m*K)]' '0' '0' '0' 'k(T[1/K])[W/(m*K)]' '0' '0' '0' 'k(T[1/K])[W/(m*K)]'});
model.component('comp1').material('mat6').propertyGroup('def').set('resistivity', {'res_solid_1(T[1/K])[ohm*m]' '0' '0' '0' 'res_solid_1(T[1/K])[ohm*m]' '0' '0' '0' 'res_solid_1(T[1/K])[ohm*m]'});
model.component('comp1').material('mat6').propertyGroup('def').set('thermalexpansioncoefficient', {'(alpha_solid_1(T[1/K])[1/K]+(Tempref-293[K])*if(abs(T-Tempref)>1e-3,(alpha_solid_1(T[1/K])[1/K]-alpha_solid_1(Tempref[1/K])[1/K])/(T-Tempref),d(alpha_solid_1(T[1/K])[1/K],T)))/(1+alpha_solid_1(Tempref[1/K])[1/K]*(Tempref-293[K]))' '0' '0' '0' '(alpha_solid_1(T[1/K])[1/K]+(Tempref-293[K])*if(abs(T-Tempref)>1e-3,(alpha_solid_1(T[1/K])[1/K]-alpha_solid_1(Tempref[1/K])[1/K])/(T-Tempref),d(alpha_solid_1(T[1/K])[1/K],T)))/(1+alpha_solid_1(Tempref[1/K])[1/K]*(Tempref-293[K]))' '0' '0' '0' '(alpha_solid_1(T[1/K])[1/K]+(Tempref-293[K])*if(abs(T-Tempref)>1e-3,(alpha_solid_1(T[1/K])[1/K]-alpha_solid_1(Tempref[1/K])[1/K])/(T-Tempref),d(alpha_solid_1(T[1/K])[1/K],T)))/(1+alpha_solid_1(Tempref[1/K])[1/K]*(Tempref-293[K]))'});
model.component('comp1').material('mat6').propertyGroup('def').set('heatcapacity', 'C_solid_1(T[1/K])[J/(kg*K)]');
model.component('comp1').material('mat6').propertyGroup('def').set('electricconductivity', {'sigma_solid_1(T[1/K])[S/m]' '0' '0' '0' 'sigma_solid_1(T[1/K])[S/m]' '0' '0' '0' 'sigma_solid_1(T[1/K])[S/m]'});
model.component('comp1').material('mat6').propertyGroup('def').set('HC', 'HC_solid_1(T[1/K])[J/(mol*K)]');
model.component('comp1').material('mat6').propertyGroup('def').set('VP', 'VP_solid_1(T[1/K])[Pa]');
model.component('comp1').material('mat6').propertyGroup('def').set('emissivity', 'epsilon(T[1/K])');
model.component('comp1').material('mat6').propertyGroup('def').set('density', 'rho_solid_1(T[1/K])[kg/m^3]');
model.component('comp1').material('mat6').propertyGroup('def').set('TD', 'TD(T[1/K])[m^2/s]');
model.component('comp1').material('mat6').propertyGroup('def').set('relpermittivity', {'1' '0' '0' '0' '1' '0' '0' '0' '1'});
model.component('comp1').material('mat6').propertyGroup('def').addInput('temperature');
model.component('comp1').material('mat6').propertyGroup('def').addInput('strainreferencetemperature');
model.component('comp1').material('mat6').propertyGroup('ThermalExpansion').func('dL_solid_1').set('arg', 'T');
model.component('comp1').material('mat6').propertyGroup('ThermalExpansion').func('dL_solid_1').set('pieces', {'0.0' '10.0' '-0.001923264';  ...
'10.0' '70.0' '-0.00192855+1.134373E-6*T^1-9.005848E-8*T^2+3.271584E-9*T^3-3.362442E-11*T^4+1.238208E-13*T^5';  ...
'70.0' '280.0' '-0.001895358-2.225109E-6*T^1+7.277336E-8*T^2-2.321766E-10*T^3+2.913888E-13*T^4';  ...
'280.0' '1973.0' '-0.002617286+8.777313E-6*T^1+3.786334E-10*T^2+5.373731E-13*T^3-6.636722E-17*T^4'});
model.component('comp1').material('mat6').propertyGroup('ThermalExpansion').set('alphatan', '');
model.component('comp1').material('mat6').propertyGroup('ThermalExpansion').set('dL', '');
model.component('comp1').material('mat6').propertyGroup('ThermalExpansion').set('alphatanIso', '');
model.component('comp1').material('mat6').propertyGroup('ThermalExpansion').set('dLIso', '');
model.component('comp1').material('mat6').propertyGroup('ThermalExpansion').set('dL', {'(dL_solid_1(T[1/K])-dL_solid_1(Tempref[1/K]))/(1+dL_solid_1(Tempref[1/K]))' '0' '0' '0' '(dL_solid_1(T[1/K])-dL_solid_1(Tempref[1/K]))/(1+dL_solid_1(Tempref[1/K]))' '0' '0' '0' '(dL_solid_1(T[1/K])-dL_solid_1(Tempref[1/K]))/(1+dL_solid_1(Tempref[1/K]))'});
model.component('comp1').material('mat6').propertyGroup('ThermalExpansion').set('dLIso', '(dL_solid_1(T)-dL_solid_1(Tempref))/(1+dL_solid_1(Tempref))');
model.component('comp1').material('mat6').propertyGroup('ThermalExpansion').addInput('temperature');
model.component('comp1').material('mat6').propertyGroup('ThermalExpansion').addInput('strainreferencetemperature');
model.component('comp1').material('mat6').propertyGroup('Enu').func('E').set('arg', 'T');
model.component('comp1').material('mat6').propertyGroup('Enu').func('E').set('pieces', {'93.0' '293.0' '1.667479E11-4.099535E7*T^1+54115.62*T^2-51.62897*T^3'; '293.0' '1480.0' '1.68E11-3.38E7*T^1'});
model.component('comp1').material('mat6').propertyGroup('Enu').func('nu').set('arg', 'T');
model.component('comp1').material('mat6').propertyGroup('Enu').func('nu').set('pieces', {'293.0' '1480.0' '0.3516936-1.897311E-5*T^1-5.685048E-9*T^2'});
model.component('comp1').material('mat6').propertyGroup('Enu').set('youngsmodulus', 'E(T[1/K])[Pa]');
model.component('comp1').material('mat6').propertyGroup('Enu').set('poissonsratio', 'nu(T[1/K])');
model.component('comp1').material('mat6').propertyGroup('Enu').addInput('temperature');
model.component('comp1').material('mat6').propertyGroup('KG').func('mu').set('arg', 'T');
model.component('comp1').material('mat6').propertyGroup('KG').func('mu').set('pieces', {'293.0' '1480.0' '6.55395E10-1.15E7*T^1+3.035766E-9*T^2'});
model.component('comp1').material('mat6').propertyGroup('KG').func('kappa').set('arg', 'T');
model.component('comp1').material('mat6').propertyGroup('KG').func('kappa').set('pieces', {'293.0' '1480.0' '1.99731E11-6.619246E7*T^1+4690.398*T^2'});
model.component('comp1').material('mat6').propertyGroup('KG').set('K', '');
model.component('comp1').material('mat6').propertyGroup('KG').set('G', '');
model.component('comp1').material('mat6').propertyGroup('KG').set('K', 'kappa(T[1/K])[Pa]');
model.component('comp1').material('mat6').propertyGroup('KG').set('G', 'mu(T[1/K])[Pa]');
model.component('comp1').material('mat6').propertyGroup('KG').addInput('temperature');
model.component('comp1').material('mat7').label('opl');
model.component('comp1').material('mat7').set('family', 'custom');
model.component('comp1').material('mat7').set('specular', 'custom');
model.component('comp1').material('mat7').set('customspecular', [1 0.8196078538894653 0.3607843220233917]);
model.component('comp1').material('mat7').set('diffuse', 'custom');
model.component('comp1').material('mat7').set('customdiffuse', [1 0.8196078538894653 0.3607843220233917]);
model.component('comp1').material('mat7').set('ambient', 'custom');
model.component('comp1').material('mat7').set('customambient', [1 0.8196078538894653 0.3607843220233917]);
model.component('comp1').material('mat7').set('noise', true);
model.component('comp1').material('mat7').set('noisefreq', 1);
model.component('comp1').material('mat7').set('lighting', 'phong');
model.component('comp1').material('mat7').set('shininess', 64);
model.component('comp1').material('mat7').propertyGroup('def').set('relpermittivity', {'1' '0' '0' '0' '1' '0' '0' '0' '1'});
model.component('comp1').material('mat7').propertyGroup('def').set('electricconductivity', {'0.05' '0' '0' '0' '0.05' '0' '0' '0' '0.05'});
model.component('comp1').material('mat8').label('photo');
model.component('comp1').material('mat8').set('family', 'custom');
model.component('comp1').material('mat8').set('specular', 'custom');
model.component('comp1').material('mat8').set('customspecular', [0.43921568989753723 0.686274528503418 0.10196078568696976]);
model.component('comp1').material('mat8').set('diffuse', 'custom');
model.component('comp1').material('mat8').set('customdiffuse', [0.43921568989753723 0.686274528503418 0.10196078568696976]);
model.component('comp1').material('mat8').set('ambient', 'custom');
model.component('comp1').material('mat8').set('customambient', [0.43921568989753723 0.686274528503418 0.10196078568696976]);
model.component('comp1').material('mat8').set('noise', true);
model.component('comp1').material('mat8').set('noisefreq', 1);
model.component('comp1').material('mat8').set('lighting', 'phong');
model.component('comp1').material('mat8').set('shininess', 64);
model.component('comp1').material('mat8').propertyGroup('def').set('relpermittivity', {'1' '0' '0' '0' '1' '0' '0' '0' '1'});
model.component('comp1').material('mat8').propertyGroup('def').set('electricconductivity', {'0.0787' '0' '0' '0' '0.0787' '0' '0' '0' '0.0787'});
model.component('comp1').material('mat9').label('rpe');
model.component('comp1').material('mat9').set('family', 'custom');
model.component('comp1').material('mat9').set('specular', 'custom');
model.component('comp1').material('mat9').set('customspecular', [0.7686274647712708 0.4156862795352936 0.2823529541492462]);
model.component('comp1').material('mat9').set('diffuse', 'custom');
model.component('comp1').material('mat9').set('customdiffuse', [0.7686274647712708 0.4156862795352936 0.2823529541492462]);
model.component('comp1').material('mat9').set('ambient', 'custom');
model.component('comp1').material('mat9').set('customambient', [0.7686274647712708 0.4156862795352936 0.2823529541492462]);
model.component('comp1').material('mat9').set('noise', true);
model.component('comp1').material('mat9').set('noisefreq', 1);
model.component('comp1').material('mat9').set('lighting', 'phong');
model.component('comp1').material('mat9').set('shininess', 64);
model.component('comp1').material('mat9').propertyGroup('def').set('relpermittivity', {'1' '0' '0' '0' '1' '0' '0' '0' '1'});
model.component('comp1').material('mat9').propertyGroup('def').set('electricconductivity', {'0.0000813' '0' '0' '0' '0.0000813' '0' '0' '0' '0.0000813'});
model.component('comp1').material('mat10').label('choroid');
model.component('comp1').material('mat10').set('family', 'custom');
model.component('comp1').material('mat10').set('specular', 'red');
model.component('comp1').material('mat10').set('diffuse', 'red');
model.component('comp1').material('mat10').set('ambient', 'custom');
model.component('comp1').material('mat10').set('customambient', [0.7411764860153198 0.7882353067398071 0.8470588326454163]);
model.component('comp1').material('mat10').set('noise', true);
model.component('comp1').material('mat10').set('noisefreq', 1);
model.component('comp1').material('mat10').set('lighting', 'phong');
model.component('comp1').material('mat10').set('shininess', 64);
model.component('comp1').material('mat10').propertyGroup('def').set('relpermittivity', {'1' '0' '0' '0' '1' '0' '0' '0' '1'});
model.component('comp1').material('mat10').propertyGroup('def').set('electricconductivity', {'0.04348' '0' '0' '0' '0.04348' '0' '0' '0' '0.04348'});
model.component('comp1').material('mat11').set('family', 'air');
model.component('comp1').material('mat11').propertyGroup('def').set('electricconductivity', {'1' '0' '0' '0' '1' '0' '0' '0' '1'});
model.component('comp1').material('mat11').propertyGroup('def').set('relpermittivity', {'1' '0' '0' '0' '1' '0' '0' '0' '1'});

model.component('comp1').physics('ec').feature('dimp1').set('ds', '100[mm]');
model.component('comp1').physics('ec').feature('dimp1').set('sigmabnd', 'imped');
model.component('comp1').physics('ec').feature('dimp1').active(false);
model.component('comp1').physics('ec').feature('gnd1').active(false);
model.component('comp1').physics('ec').feature('ncd1').set('nJ', 'current_density');
model.component('comp1').physics('ec').feature('ncd2').set('nJ', '-current_density');
model.component('comp1').physics('ec').feature('ci1').set('ds', '1[mm]');
model.component('comp1').physics('ec').feature('ci1').set('sigmabnd', 'imped');
model.component('comp1').physics('ec').feature('ci1').active(false);
model.component('comp1').physics('ec').feature('dimp1').set('sigmabnd_mat', 'userdef');
model.component('comp1').physics('ec').feature('dimp1').set('epsilonrbnd_mat', 'userdef');
model.component('comp1').physics('ec').feature('ci1').set('sigmabnd_mat', 'userdef');
model.component('comp1').physics('ec').feature('ci1').set('epsilonrbnd_mat', 'userdef');


model.study.create('std1');
model.study('std1').create('stat', 'Stationary');


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



%model.component('comp1').geom('geom1').run(); %%%%%%%%%%%%%%%%%%%%%%%%%%% 
%model.component('comp1').mesh('mesh1').run(); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%model.study('std1').run(); %%%%%%%%%%%%%%%%%%%%%%%%
%model.sol('sol1').run();




"Running solution..."
model.sol('sol1').attach('std1');
model.sol('sol1').feature('s1').feature('i1').set('linsolver', 'cg');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').set('prefun', 'amg');
model.sol('sol1').runAll;
"Solution OK."

"Ploting..."
cpldefinition(model, 'xy', 'cpl1', '0[um]' );
cpldefinition(model, 'xy', 'cpl2', '30[um]' );
cpldefinition(model, 'pn', 'cpl3', '0', '0', '-10[um]', 0, 0, -1);
cpldefinition(model, 'pn', 'cpl4', '0', '0', '0', -1, 1, 0 );

clndefinition(model,'cln1', '-1', '-1', '-10[um]', '1', '1', '-10[um]');
clndefinition(model,'cln2', '-1', '-1', '0[um]', '1', '1', '0[um]');
clndefinition(model,'cln3', '-1', '-1', '10[um]', '1', '1', '10[um]');

buildmslc(model,'pg1','60[um]','50[um]','100[um]');

buildcpl(model, 'pg2', 'surf1', 'cpl1', 'cpl3');
buildcpl(model, 'pg3', 'surf2', 'cpl4', 'cpl4');

buildcln(model, 'pg4', 'cln1', 'cln2', 'cln3');
"Ploting OK."


%model.result.create('pg1', 'PlotGroup3D');
%model.result('pg1').create('mslc1', 'Multislice');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%{
pg = model.result.create('pg1', 'PlotGroup3D'); 

% Create a multislice plot
pg.create('mslc1', 'Multislice');
% Create dataset for multisclice plot
pg.feature('mslc1').set('data', 'dset1');

% Create 3D plot frame
model.result('pg1').label('Electric Potential (ec)');
model.result('pg1').set('frametype', 'spatial');
model.result('pg1').feature('mslc1').set('multiplanexmethod', 'coord');
model.result('pg1').feature('mslc1').set('xcoord', '60[um]');
model.result('pg1').feature('mslc1').set('resolution', 'normal');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

model.sol('sol1').attach('std1');
model.sol('sol1').feature('s1').feature('i1').set('linsolver', 'cg');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').set('prefun', 'amg');
model.sol('sol1').runAll;
%}

%{
% Create all lines and planes
model.result.dataset.create('cpl1', 'CutPlane');
model.result.dataset.create('cpl2', 'CutPlane');
model.result.dataset.create('cln4', 'CutLine3D');
model.result.dataset.create('cln5', 'CutLine3D');
model.result.dataset.create('cln6', 'CutLine3D');
model.result.dataset.create('cln7', 'CutLine3D');
model.result.dataset.create('cln8', 'CutLine3D');
model.result.dataset.create('cln9', 'CutLine3D');
model.result.dataset.create('cln10', 'CutLine3D');
model.result.dataset.create('cpl3', 'CutPlane');
model.result.dataset.create('cpl4', 'CutPlane');
model.result.dataset.create('cpl5', 'CutPlane');
model.result.dataset.create('cpl6', 'CutPlane');
model.result.dataset.create('cpl7', 'CutPlane');

% Create Plot groups
model.result.create('pg1', 'PlotGroup3D');
model.result.create('pg2', 'PlotGroup2D');
model.result.create('pg3', 'PlotGroup1D');
model.result.create('pg4', 'PlotGroup1D');
model.result.create('pg5', 'PlotGroup1D');
model.result.create('pg6', 'PlotGroup2D');

%For each Plot group : define the plot types we need (multislice, streamline, linegraph)

model.result('pg1').create('mslc1', 'Multislice');
model.result('pg1').create('str1', 'Streamline');
model.result('pg1').feature('mslc1').set('data', 'dset1');
model.result('pg1').feature('str1').set('data', 'dset1');

model.result('pg2').create('surf1', 'Surface');
model.result('pg2').create('str1', 'Streamline');
model.result('pg2').create('traj1', 'ParticleTrajectories');
model.result('pg2').create('surf2', 'Surface');

model.result('pg3').create('lngr2', 'LineGraph');
model.result('pg3').create('lngr3', 'LineGraph');
model.result('pg3').create('lngr4', 'LineGraph');
model.result('pg3').feature('lngr2').set('xdata', 'expr');
model.result('pg3').feature('lngr3').set('xdata', 'expr');
model.result('pg3').feature('lngr4').set('xdata', 'expr');

model.result('pg4').create('lngr1', 'LineGraph');
model.result('pg4').create('lngr2', 'LineGraph');
model.result('pg4').create('lngr3', 'LineGraph');
model.result('pg4').feature('lngr1').set('xdata', 'expr');
model.result('pg4').feature('lngr2').set('xdata', 'expr');
model.result('pg4').feature('lngr3').set('xdata', 'expr');
model.result('pg5').create('lngr1', 'LineGraph');
model.result('pg5').feature('lngr1').set('xdata', 'expr');
model.result('pg6').create('surf1', 'Surface');
model.result('pg6').create('surf2', 'Surface');
model.result('pg6').create('surf3', 'Surface');
model.result('pg6').create('surf4', 'Surface');







model.sol('sol1').attach('std1');
model.sol('sol1').feature('s1').feature('i1').set('linsolver', 'cg');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').set('prefun', 'amg');
model.sol('sol1').runAll;

model.result.dataset('cpl1').set('planetype', 'general');
model.result.dataset('cpl1').set('genmethod', 'pointnormal');
model.result.dataset('cpl1').set('genpnpoint', {'0' '0' '-10[um]'});
model.result.dataset('cpl1').set('genpnvec', [0 0 -1]);
model.result.dataset('cpl2').set('planetype', 'general');
model.result.dataset('cpl2').set('genmethod', 'pointnormal');
model.result.dataset('cpl2').set('genpnvec', [-1 1 0]);
model.result.dataset('cln4').set('genpoints', {'-1' '-1' '-10[um]'; '1' '1' '-10[um]'});
model.result.dataset('cln5').set('genpoints', {'-1' '-1' '0[um]'; '1' '1' '0[um]'});
model.result.dataset('cln5').set('spacevars', {'cln4x'});
model.result.dataset('cln6').set('genpoints', {'-1' '-1' '10[um]'; '1' '1' '10[um]'});
model.result.dataset('cln6').set('spacevars', {'cln4x'});
model.result.dataset('cln7').set('genpoints', {'1' '-1' '-10[um]'; '-1' '1' '-10[um]'});
model.result.dataset('cln7').set('spacevars', {'cln4x'});
model.result.dataset('cln8').set('genpoints', {'1' '-1' '0[um]'; '-1' '1' '0[um]'});
model.result.dataset('cln8').set('spacevars', {'cln4x'});
model.result.dataset('cln9').set('genpoints', {'1' '-1' '10[um]'; '-1' '1' '10[um]'});
model.result.dataset('cln9').set('spacevars', {'cln4x'});
model.result.dataset('cln10').set('genpoints', {'0' '0' '-10[um]'; '0' '0' '1'});
model.result.dataset('cln10').set('spacevars', {'cln4x'});
model.result.dataset('cpl3').set('quickplane', 'xy');
model.result.dataset('cpl4').set('quickplane', 'xy');
model.result.dataset('cpl4').set('quickz', ['10[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm]']);
model.result.dataset('cpl4').set('spacevars', {'cpl3x' 'cpl3y'});
model.result.dataset('cpl4').set('normal', {'cpl3nx' 'cpl3ny' 'cpl3nz'});
model.result.dataset('cpl5').set('quickplane', 'xy');
model.result.dataset('cpl5').set('quickz', ['20[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm]']);
model.result.dataset('cpl5').set('spacevars', {'cpl3x' 'cpl3y'});
model.result.dataset('cpl5').set('normal', {'cpl3nx' 'cpl3ny' 'cpl3nz'});
model.result.dataset('cpl6').set('quickplane', 'xy');
model.result.dataset('cpl6').set('quickz', ['30[' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm]']);
model.result.dataset('cpl6').set('spacevars', {'cpl3x' 'cpl3y'});
model.result.dataset('cpl6').set('normal', {'cpl3nx' 'cpl3ny' 'cpl3nz'});
model.result.dataset('cpl7').set('planetype', 'general');
model.result.dataset('cpl7').set('genmethod', 'pointnormal');
model.result.dataset('cpl7').set('genpnpoint', {'30[um]' '-30[um]' '0'});
model.result.dataset('cpl7').set('genpnvec', [-1 1 0]);
model.result.dataset('cpl7').set('spacevars', {'cpl2x' 'cpl2y'});
model.result.dataset('cpl7').set('normal', {'cpl2nx' 'cpl2ny' 'cpl2nz'});

model.result('pg1').label('Electric Potential (ec)');
model.result('pg1').set('frametype', 'spatial');
model.result('pg1').feature('mslc1').set('multiplanexmethod', 'coord');
model.result('pg1').feature('mslc1').set('xcoord', '60[um]');
model.result('pg1').feature('mslc1').set('resolution', 'normal');
model.result('pg1').feature('str1').set('posmethod', 'start');
model.result('pg1').feature('str1').set('resolution', 'normal');
model.result('pg2').set('data', 'cpl2');
model.result('pg2').feature('surf1').active(false);
model.result('pg2').feature('surf1').set('data', 'cpl2');
model.result('pg2').feature('surf1').set('resolution', 'normal');
model.result('pg2').feature('str1').active(false);
model.result('pg2').feature('str1').set('data', 'cpl2');
model.result('pg2').feature('str1').set('resolution', 'normal');
model.result('pg2').feature('traj1').active(false);
model.result('pg2').feature('surf2').set('data', 'cpl7');
model.result('pg2').feature('surf2').set('resolution', 'normal');

model.result('pg3').set('data', 'cpl1');
model.result('pg3').set('xlabel', 'x/0.7 (m)');
model.result('pg3').set('ylabel', 'Electric potential (V)');
model.result('pg3').set('xlabelactive', false);
model.result('pg3').set('ylabelactive', false);
model.result('pg3').feature('lngr2').set('data', 'cln4');
model.result('pg3').feature('lngr2').set('xdataexpr', 'x/0.7');
model.result('pg3').feature('lngr2').set('xdataunit', 'm');
model.result('pg3').feature('lngr2').set('xdatadescr', 'x/0.7');
model.result('pg3').feature('lngr2').set('legend', true);
model.result('pg3').feature('lngr2').set('legendmethod', 'manual');
model.result('pg3').feature('lngr2').set('legends', {'potential at z= -10 um'});
model.result('pg3').feature('lngr2').set('resolution', 'normal');
model.result('pg3').feature('lngr3').set('data', 'cln5');
model.result('pg3').feature('lngr3').set('xdataexpr', 'x/0.7');
model.result('pg3').feature('lngr3').set('xdataunit', 'm');
model.result('pg3').feature('lngr3').set('xdatadescr', 'x/0.7');
model.result('pg3').feature('lngr3').set('legend', true);
model.result('pg3').feature('lngr3').set('legendmethod', 'manual');
model.result('pg3').feature('lngr3').set('legends', {'potential at z= 0 um'});
model.result('pg3').feature('lngr3').set('resolution', 'normal');
model.result('pg3').feature('lngr4').set('data', 'cln6');
model.result('pg3').feature('lngr4').set('xdataexpr', 'x/0.7');
model.result('pg3').feature('lngr4').set('xdataunit', 'm');
model.result('pg3').feature('lngr4').set('xdatadescr', 'x/0.7');
model.result('pg3').feature('lngr4').set('legend', true);
model.result('pg3').feature('lngr4').set('legendmethod', 'manual');
model.result('pg3').feature('lngr4').set('legends', {'potential at z= 10 um'});
model.result('pg3').feature('lngr4').set('resolution', 'normal');
model.result('pg4').set('xlabel', 'x/0.7 (m)');
model.result('pg4').set('ylabel', 'Electric potential (V)');
model.result('pg4').set('xlabelactive', false);
model.result('pg4').set('ylabelactive', false);
model.result('pg4').feature('lngr1').label('potential at z=-10');
model.result('pg4').feature('lngr1').set('data', 'cln7');
model.result('pg4').feature('lngr1').set('xdataexpr', 'x/0.7');
model.result('pg4').feature('lngr1').set('xdataunit', 'm');
model.result('pg4').feature('lngr1').set('xdatadescr', 'x/0.7');
model.result('pg4').feature('lngr1').set('legend', true);
model.result('pg4').feature('lngr1').set('legendmethod', 'manual');
model.result('pg4').feature('lngr1').set('legends', {'potential at z=-10 um'});
model.result('pg4').feature('lngr1').set('resolution', 'normal');
model.result('pg4').feature('lngr2').set('data', 'cln8');
model.result('pg4').feature('lngr2').set('xdataexpr', 'x/0.7');
model.result('pg4').feature('lngr2').set('xdataunit', 'm');
model.result('pg4').feature('lngr2').set('xdatadescr', 'x/0.7');
model.result('pg4').feature('lngr2').set('legend', true);
model.result('pg4').feature('lngr2').set('legendmethod', 'manual');
model.result('pg4').feature('lngr2').set('legends', {'potential at z= 0 um'});
model.result('pg4').feature('lngr2').set('resolution', 'normal');
model.result('pg4').feature('lngr3').set('data', 'cln9');
model.result('pg4').feature('lngr3').set('xdataexpr', 'x/0.7');
model.result('pg4').feature('lngr3').set('xdataunit', 'm');
model.result('pg4').feature('lngr3').set('xdatadescr', 'x/0.7');
model.result('pg4').feature('lngr3').set('legend', true);
model.result('pg4').feature('lngr3').set('legendmethod', 'manual');
model.result('pg4').feature('lngr3').set('legends', {'potential at z= 10 um'});
model.result('pg4').feature('lngr3').set('resolution', 'normal');
model.result('pg5').set('xlabel', ['z-coordinate (' native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm)']);
model.result('pg5').set('ylabel', 'Electric potential (V)');
model.result('pg5').set('xlabelactive', false);
model.result('pg5').set('ylabelactive', false);
model.result('pg5').feature('lngr1').set('data', 'cln10');
model.result('pg5').feature('lngr1').set('xdataexpr', 'z');
model.result('pg5').feature('lngr1').set('xdataunit', [native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']);
model.result('pg5').feature('lngr1').set('xdatadescr', 'z-coordinate');
model.result('pg5').feature('lngr1').set('resolution', 'normal');
model.result('pg6').feature('surf1').active(false);
model.result('pg6').feature('surf1').label('Surface  z=0');
model.result('pg6').feature('surf1').set('data', 'cpl3');
model.result('pg6').feature('surf1').set('resolution', 'normal');
model.result('pg6').feature('surf2').active(false);
model.result('pg6').feature('surf2').label('Surface 2  z=10');
model.result('pg6').feature('surf2').set('data', 'cpl4');
model.result('pg6').feature('surf2').set('resolution', 'normal');
model.result('pg6').feature('surf3').active(false);
model.result('pg6').feature('surf3').label('Surface 3  z=20');
model.result('pg6').feature('surf3').set('data', 'cpl5');
model.result('pg6').feature('surf3').set('resolution', 'normal');
model.result('pg6').feature('surf4').label('Surface 4  z=30');
model.result('pg6').feature('surf4').set('data', 'cpl6');
model.result('pg6').feature('surf4').set('resolution', 'normal');
%}

out = model;
