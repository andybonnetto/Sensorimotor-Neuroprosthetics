classdef Constants
    properties (Constant)
        % Time related constants in seconds
        tau_syn = 1e-3
        time_coeff = 40;
        time_step = Constants.tau_syn/Constants.time_coeff;
        simulation_duration = 500e-3;
        t_size = int32(Constants.simulation_duration/Constants.time_step);
    end
end