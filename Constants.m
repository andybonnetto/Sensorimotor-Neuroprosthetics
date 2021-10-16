classdef Constants
    properties (Constant)
        % Time related constants in seconds
        tau_syn = 1e-3
        time_coeff = 500;
        time_step = Constants.time_coeff*Constants.tau_syn;
        simulation_duration = 5
        t_size = int32(Constants.simulation_duration/Constants.time_step);
    end
end