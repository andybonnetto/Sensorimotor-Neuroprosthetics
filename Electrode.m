classdef Electrode < handle
    properties
        name = "electrode"
        x
        y
        z
        alpha = 100e-6 %electrode diameter
        current = 50e-6
        R_tissue = 10e3
        Vo
    end
    methods 
        function self = Electrode(I,position)
            self.current = I;
            self.x = position(1);
            self.y = position(2);
            self.z = position(3);
            self.Vo = self.current*self.R_tissue;
        end
    end
end