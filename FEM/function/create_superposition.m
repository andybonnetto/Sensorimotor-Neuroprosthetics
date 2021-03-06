function out = create_superposition(model,wid,current,nb_e_x, nb_e_y) 
close all

height_max = 426*10^-6;
height_min = -200*10^-6;

retine_size = 6000 *10^-6;   %[um]
patch_size  = wid;   %[um]

%step between two sample
step = 15*10^-6 ;            %[um]

%nb of sample on z
z_nb_sample = 60;

%spec between electrodes
d = 300*10^-6 ;              %[um]

X_patch = [-patch_size/2: step: patch_size/2 ];
Y_patch = [-patch_size/2: step: patch_size/2 ]; 
Z = linspace( height_min, height_max, z_nb_sample);
[x, y, z] = meshgrid(X_patch, Y_patch, Z);
points = [x(:), y(:),z(:)];

[V] = mphinterp(model,'V','coord', points');

%permtute two first dim if e are not symetrical
V_mat = reshape(V,[length(X_patch),length(Y_patch),length(Z)]);

%plot one electrode
figure;
scatter3(x(:),y(:),z(:),5,V);

%create retina matrix
X_ret = [-retine_size/2: step: retine_size/2 ];
Y_ret = [-retine_size/2: step: retine_size/2 ];

M = zeros(length(X_ret), length(Y_ret), length(Z));

idx_step = round(size(M,1)*d/retine_size);
for i=0:nb_e_y-1
    for j=0:nb_e_x-1
        
        x_min = 1 + i*idx_step ;
        x_max = i*idx_step+length(X_patch) ;
        y_min = 1 + j*idx_step ;
        y_max = j*idx_step+length(Y_patch) ;
        
        %size_Vmat= size(V_mat)
        %size_M = size(M(x_min:x_max, y_min:y_max, 1:length(Z)))
        M(x_min:x_max, y_min:y_max, 1:length(Z)) =  M(x_min:x_max, y_min:y_max, 1:length(Z)) + V_mat * current((i+1)*(j+1));
        
    end
end

[x, y, z] = meshgrid(X_ret, Y_ret, Z);

%figure;
%scatter3(x(:),y(:),z(:), 10, reshape(M,1,[]));

% V_out.x = x(:);
% V_out.y = y(:);
% V_out.z = z(:);
% V_out.V = reshape(M,1,[])';

V_out.x = x;
V_out.y = y;
V_out.z = z;
V_out.V = M;

"Superposition computed..."
out = V_out ;
