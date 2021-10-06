classdef Light
    properties
        name = "light"
        L
        L_max = 1
        t_photo
        x
        y
        d %diameter
    end
    methods
        function self = Light(position,diameter,intensity)
            self.x = position(1);
            self.y = position(2);
            self.d = diameter;
            self.L = intensity;
        end

        function I = get_intensity(x_cell,y_cell)
            distance = sqrt((self.x-x_cell)^2 + (self.y-y_cell)^2);
            if distance < self.d
                I = exp(1/self.d);
            else
                I = 0;
            end
        end
    end
end