classdef Constants
    properties (Constant)
        time_step = 1e-3
        simulation_duration = 4e-3;
        t_size = int32(Constants.simulation_duration/Constants.time_step);
    end
end