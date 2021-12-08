
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