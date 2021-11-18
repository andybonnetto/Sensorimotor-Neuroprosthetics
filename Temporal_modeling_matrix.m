function [M_cells,V_0] = Temporal_modeling_matrix(cell_list,init,L,pfile)
    import M.*
    import Constants.*
    
%     if nargin < 4
%         path_to_file = "C:\Users\andyb\Documents\results\test.txt";
%     else
%         path_to_file = pfile;
%     end

    if nargin < 2
        M_init = [];
        V_m_init = [];
    else
        M_init = init{1};
        V_m_init = init{2};
    end

    if isempty(M_init)
        M_cells = M(cell_list);
        assignin("base","M_init",M_cells)
        disp("Done copying datas from cell_list")
    else
        M_cells = M_init;
    end

%     delete(path_to_file)
%     fid = fopen(path_to_file, 'a');
%     fsid = fopen(strcat(path_to_file,"_V_s"), 'a');
    mrows = M_cells.N_cells;
    ncols = Constants.time_coeff;
%     outputstr_s = ['%' num2str(mrows) 'f']; % template for the string, you put your datatype here
%     outputstr = repmat(outputstr_s, 1, ncols); % replicate it to match the number of columns
%     outputstr = [outputstr '\n']; % add a new line if you want
%     assignin("base","outputstr",outputstr)
%     assignin("base", 'outputstr_s',outputstr)

    if isempty(V_m_init)
        [M_cells,V_0] = initialization(M_cells);
    else
        [M_cells,V_0] = initialization(M_cells,V_m_init);
    end
%     fprintf(fid,outputstr, M_cells.V_m.');
    w = waitbar(0, "Please wait...");
    for t = 2:Constants.t_size
        waitbar(t/Constants.t_size,w,"Update your V_m...")
        M_cells = get_Gsyn(M_cells,L,t);
        [M_cells,V_s] = update_V_m(M_cells,t);
%         fprintf(fid,outputstr, M_cells.V_m.');
%         fprintf(fsid,outputstr_s,V_s.');
%         S = get_firing_rate(M_cells,t);
    end
    close(w);
%     fclose(fid);
    assignin("base","M_cells",M_cells)

%     scatter(1:4225,S{1}(2))
end

function [M_cells,V_0] = initialization(M_cells,V_m_init)
    if nargin < 2
%         M_cells.V_m = rand(M_cells.N_cells,1)*(-100e-3);
        M_cells.V_m = ones(M_cells.N_cells,Constants.t_size)*(-50e-3);
    else
        M_cells.V_m = V_m_init;
    end
    V_0 = M_cells.V_m;
%     M_cells.Delta_Ve = ones(M_cells.N_cells,Constants.t_size)*(100e-3);
end

function M_cells = get_Gsyn(M_cells,L,t)
    M_cells = M_cells.update_V_pre(t);
    X1 = (M_cells.V_pre - M_cells.V_502(:,:,:,1))./M_cells.beta2(:,:,:,1);
    X2 = (M_cells.V_pre - M_cells.V_502(:,:,:,2))./M_cells.beta2(:,:,:,2);
    I = ones(size(X1));
    M_cells.g_syn2(:,:,:,1) = M_cells.g_min2(:,:,:,1) + (M_cells.g_max2(:,:,:,1) - M_cells.g_min2(:,:,:,1)).*(I-I./(I+exp(X1)));
    M_cells.g_syn2(:,:,:,2) = M_cells.g_min2(:,:,:,2) + (M_cells.g_max2(:,:,:,2) - M_cells.g_min2(:,:,:,2)).*(I./(I+exp(X2)));
    M_cells.g_syn(:,:,:) = M_cells.g_syn2(:,:,:,1) + M_cells.g_syn2(:,:,:,2);
    
    W = sum(exp(-M_cells.D ./ M_cells.sigma),3);
    I = ones(size(W));
    M_cells.Gsyn(:,:) = I./W .* sum(M_cells.g_syn(:,:,:) .* exp(-M_cells.D ./ M_cells.sigma),3);
    
    if nargin > 1
        M_cells = M_cells.add_light_syn(L);
    end
end

function [M_cells,V_s] = update_V_m(M_cells,t)

    G_tot = M_cells.G_m + sum(M_cells.Gsyn(:,:),2);
    tau_m = M_cells.C_m ./ G_tot;
    dt = Constants.time_step;
    I = ones(M_cells.N_cells,1);
    V_s = I ./ G_tot .* (M_cells.G_m .* M_cells.E_rest + M_cells.Delta_Ve(:,t) .* M_cells.G_m + sum(M_cells.Gsyn(:,:) .* M_cells.E_syn,2));
    assignin("base","V_s",V_s);
    dV = (-(repmat(dt,M_cells.N_cells,1))./tau_m).*M_cells.V_m(:,t) + (repmat(dt,M_cells.N_cells,1)./tau_m).*V_s;
    M_cells.V_m(:,t+1) =  dV + M_cells.V_m(:,t) ;
end

function S = get_firing_rate(M_cells,t)
    
    names = ["GL_on", "GL_off"];
    DV_0 = 5e-3;
    i = 1;
    for name = names 
        ganglions = M_cells.names == name;
        E_T = Cell(name, [0,0,0]).E_T;
        DV_t = max(zeros(sum(ganglions),1),M_cells.V_m(ganglions,t)- E_T);
        n  = 2 + (0.1*DV_t).^2;
        S{i} = DV_t.^n./(DV_t.^n+DV_0.^n);
        i = i +1;
    end
end