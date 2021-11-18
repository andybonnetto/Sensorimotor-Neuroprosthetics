function Read_V_m_file(path_to_file, outputstr,n_tot)
    clear V_m;
    fid = fopen(path_to_file, 'r');
    V_m = fscanf(fid,outputstr);
    V_m = reshape(V_m,[n_tot,size(V_m,1)/n_tot]);
    assignin("base","V_m",V_m)
    fclose(fid);
end