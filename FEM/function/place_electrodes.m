x=0;y=0; % hexagone center or rectangle bottom left 

k=8;l=4; % size of the rectangle
d=1; % distance between electrods
r=0.1; % radius
% inj: 1, ret : 0
Ltype=randi([0, 1], [7,1]); % List of 7 electrodes types 
Mtype=randi([0, 1], [k,l]); % Matrix of k*l electrodes types
zinj=1; 
zret=1.5;

rectangle(x, y, d, r, zinj, zret, Mtype)
%hexa(x, y, d, r, zinj, zret, Ltype)

% (x,y) hexagone center, d distance between electrod
function T = hexa(x, y, d, r, zinj, zret, Ltype)
h = d*sqrt(3)/2;
X = [x ; x+d ; x-d ; x+d/2 ; x-d/2 ; x+d/2 ; x-d/2 ];
Y = [y ; y ; y ; y+h ; y+h ; y-h ; y-h];
rad = [r;r;r;r;r;r;r];
Z = zeros(7,1); type = string(zeros(7,1));
for i = 1:7
    if Ltype(i)
        Z(i) = zinj;
        type(i) = 'inj';
    else 
        Z(i) = zret;
        type(i) = 'ret';
    end
end
type = categorical(type);
T = table(X,Y,Z,rad,type);
end

function T = create_rectangle(x, y, d, r, zinj, zret, Mtype)
[k, l] = size(Mtype);
X = zeros(k,l); Y = zeros(k,l);
Z = zeros(k,l); type = string(zeros(k,l));
for i = 1:k
    for j =1:l
        X(i,j)=x+(i-1)*d;
        Y(i,j)=y+(j-1)*d;
        if Mtype(i,j)
            Z(i,j) = zinj;
            type(i,j) = 'inj';
        else
            Z(i,j) = zret;
            type(i,j) = 'ret';
        end
    end
end
rad = reshape(r*ones(k,l),[k*l,1]);
X = reshape(X,[k*l,1]); Y = reshape(Y,[k*l,1]);
Z = reshape(Z,[k*l,1]); type = reshape(type,[k*l,1]);
type = categorical(type);
T = table(X,Y,Z,rad,type);
end

