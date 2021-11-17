function Read_V_m_file(path_to_file, outputstr)
    clear V_m;
    fid = fopen(path_to_file, 'r');
    V_m = fscanf(fid,outputstr);
    V_m = reshape(V_m,[11025,size(V_m,1)/11025]);
    assignin("base","V_m",V_m)
    fclose(fid);
end