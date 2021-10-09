classdef Constants
    properties (Constant)
        tau_syn = 1e-3
        time_coeff = 500;
        time_step = Constants.time_coeff*Constants.tau_syn;
        simulation_duration = 5
        t_size = int32(Constants.simulation_duration/Constants.time_step);
    end
end