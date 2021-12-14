function Delta_Ve = generate_electrical_pulse(v_diff_max,cell_list,vis,fp_indices)
    import Constants.*

    n_cells = length(cell_list);
    Delta_Ve = (v_diff_max(1,fp_indices)).';
    Delta_Ve = repmat(Delta_Ve,1,Constants.t_size);

    burst_amplitudes = [4,5,6,7];
    burst_duration = 30e-3;
    burst_duration_ind = int32(burst_duration/Constants.time_step);
    burst_interval = Constants.simulation_duration/length(burst_amplitudes);
    burst_interval_ind = int32(burst_interval/Constants.time_step);
    
    mask_full = zeros(1,Constants.t_size); 
    for i = 1:length(burst_amplitudes)
        start_ind = (i-1)*burst_interval_ind+1;
        mask_full(start_ind:2:start_ind+burst_duration_ind) = ones(size(start_ind:2:start_ind+burst_duration_ind))*burst_amplitudes(i);
    end    
    Delta_Ve = Delta_Ve*diag(mask_full,0);

    if vis
        figure()
        plot(linspace(0,Constants.simulation_duration*10^3, Constants.t_size),mask_full*100)
        xlabel("Time [ms]")
        ylabel("Current [µA]")
    end
end