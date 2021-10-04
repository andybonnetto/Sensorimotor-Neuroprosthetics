classdef Cell < handle
    properties
        name = "None"
        g1
        param2
    end
    methods
        function self = Cell(n)
                self.name = n;
                self.g1 = 1.5;

            if self.name == "GLC"
                self.param2 = "something";
            end
        end
    end
end