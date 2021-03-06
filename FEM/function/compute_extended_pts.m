function out = compute_extended_pts(input_mat,name_mat)


%input_mat=[1 1 1; 5 5 5; 10 10 10; 10 10 20]
%name_mat=["AM_NF_on" "AM_NF_on" "HRZ" "HRZ"]

%name_mat=matstring
name_of_cell = [    "CR"
                    "HRZ"
                    "BP_on"
                    "BP_off"
                    "AM_WF_on"
                    "AM_WF_off"
                    "AM_NF_on"
                    "GL_on"
                     "GL_off"]'
     
%radius for each type of cell not correct !!!
radius = [ 5 5 5 5 5 5 6 10 5 ] * 10^-6;

%nb_of_pts surronding each cell
nb_of_pts   = 6  ;  
out_mat1    = [] ;
for i = 0:length(radius)-1  
    idx_by_type =  name_mat == name_of_cell(i+1);
    mat         = input_mat(idx_by_type,:);
   
    %two new point on x
    matx1       = mat + [radius(i+1) 0 0];
    matx2       = mat + [-radius(i+1) 0 0];
    
    %two new point on y
    maty1       = mat + [0 radius(i+1) 0];
    maty2       = mat + [0 -radius(i+1) 0];
    
    %two new point on z
    matz1       = mat + [ 0 0 radius(i+1)];
    matz2       = mat + [ 0 0 -radius(i+1)];
    
    temp_mat = [ matx1  matx2  maty1 maty2 matz1 matz2];
    out_mat1 = [out_mat1 ; temp_mat;];
    
end

% out is a 3 * (6*nb_of_cell) matrix
out = reshape(out_mat1',[3, nb_of_pts*size(input_mat,1)]);

 






