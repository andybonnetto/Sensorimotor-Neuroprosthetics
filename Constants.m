classdef Constants
    properties (Constant)
        tau_syn = 1e-3
        time_coeff = 5;
        time_step = Constants.time_coeff*Constants.tau_syn;
        simulation_duration = 50e-3
        t_size = int32(Constants.simulation_duration/Constants.time_step);
    end
end