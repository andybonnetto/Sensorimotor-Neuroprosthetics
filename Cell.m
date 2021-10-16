classdef Cell < handle
    properties
        name = "None"
        gsyn
        exc_or_in
        C_m
        G_m
        tau_rest
        E_rest
        E_T
        E_syn
        g_min
        g_max
        V_50
        beta
        type
        
        %Dynamic Variables 
%         Must be lists for visualization
        Gsyn
        V_m
        Delta_Ve

        lambda
        sigma
        z_min
        z_max

        post_syn_subset
        pre_syn_subset  
        distance_post_syn
        distance_pre_syn

        n
        %Position Variables
        x
        y
        z
    end
    
    methods
        function self = Cell(i,pos)
                self.name = i;
                self.x = pos(1);
                self.y = pos(2);
                self.z = pos(3);

                ms = 1e-3;
                pF = 1e-12;
                nS = 1e-9;
                mV = 1e-3;
                um = 1e-6;
    

        % CR cells
            if self.name == "CR"
                self.C_m = 80*pF;
                self.G_m = 4*nS;
                self.tau_rest = 20*ms;
                self.E_rest = -50*mV;

                self.E_syn = [-8*mV,-67*mV];
                self.g_min = [0,0];
                self.g_max = [0.9*nS,3*nS];
                self.type = ["D","I"];
                self.V_50 = [0, -29.5*mV];
                self.beta = [0, 7.4*mV];

                self.lambda = 2.5*um;
                self.sigma = 2.5*um;
                self.z_min = 170*um;
                self.z_max = 205*um;
                self.n = 4105;
        % HRZ cells
            elseif self.name == "HRZ"
                self.C_m = 210*pF;
                self.G_m = 2.5*nS;
                self.tau_rest = 84*ms;
                self.E_rest = -65*mV;

                self.E_syn = [0];
                self.g_min = [0];
                self.g_max = [7*nS];
                self.V_50 = [-43*mV];
                self.beta = [2*mV];
                self.type = ["I"];

                self.lambda = 7*um;
                self.sigma = 10.5*um;
                self.z_min = 100*um;
                self.z_max = 128*um;
                self.n = 537;
        % BP_on cells
            elseif self.name == "BP_on"
                self.C_m = 50*pF;
                self.G_m = 2*nS;
                self.tau_rest = 25*ms;
                self.E_rest = -45*mV;

                self.E_syn = [0,0];
                self.g_min = [0.1*nS];
                self.g_max = [1.1*nS];
                self.V_50 = [-47*mV];
                self.beta = [1.7*mV];
                self.type = ["D"];

                self.lambda = 3.85*um;
                self.sigma = 3.85*um;
                self.z_min = 100*um;
                self.z_max = 128*um;
                self.n = 1741;
        % BP_off cells
            elseif self.name == "BP_off"
                self.C_m = 50*pF;
                self.G_m = 2*nS;
                self.tau_rest = 25*ms;
                self.E_rest = -45*mV; 

                self.E_syn = [0];
                self.g_min = [0];
                self.g_max = [3.75*nS];
                self.V_50 = [-41.5*mV];
                self.beta = [1.2*mV];
                self.type = ["I"];

                self.lambda = 3.85*um;
                self.sigma = 3.85*um;
                self.z_min = 100*um;
                self.z_max = 128*um;
                self.n = 1741;
        % AM_WF_on cells
            elseif self.name == "AM_WF_on"
                self.C_m = 50*pF;
                self.G_m = 2*nS;
                self.tau_rest = 25*ms;
                self.E_rest = -50*mV; 

                self.E_syn = [0];
                self.g_min = [0];
                self.g_max = [1*nS];
                self.V_50 = [-33.5*mV];
                self.beta = [3*mV];
                self.type = ["I"];

                self.lambda = 8*um;
                self.sigma = 24*um;
                self.z_min = 80*um;
                self.z_max = 101*um;
                self.n = 391;
        % AM_WF_off cells
            elseif self.name == "AM_WF_off"
                self.C_m = 50*pF;
                self.G_m = 2*nS;
                self.tau_rest = 25*ms;
                self.E_rest = -50*mV;

                self.E_syn = [0];
                self.g_min = [0];
                self.g_max = [1.8*nS];
                self.V_50 = [-44*mV];
                self.beta = [3*mV];
                self.type = ["I"];

                self.lambda = 8*um;
                self.sigma = 24*um;
                self.z_min = 80*um;
                self.z_max = 101*um;
                self.n = 391;
        % AM_NF_on cells
            elseif self.name == "AM_NF_on"
                self.C_m = 50*pF;
                self.G_m = 2*nS;
                self.tau_rest = 25*ms;
                self.E_rest = -50*mV; 

                self.E_syn = [0];
                self.g_min = [0];
                self.g_max = [0.2*nS];
                self.V_50 = [-35*mV];
                self.beta = [3*mV];
                self.type = ["I"];

                self.lambda = 6*um;
                self.sigma = 6*um;
                self.z_min = 80*um;
                self.z_max = 101*um;
                self.n = 721;
            
        % GL_on cells
            elseif self.name == "GL_on"
                self.C_m = 50*pF;
                self.G_m = 2*nS;
                self.tau_rest = 25*ms;
                self.E_rest = -60*mV;
                self.E_T = -50.6*mV;

                self.E_syn = [0,-70*mV];
                self.g_min = [0,0];
                self.g_max = [2.5*nS,2*nS];
                self.V_50 = [-33.5*mV, -42.5*mV];
                self.beta = [3*mV,2.5*mV];
                self.type = ["I","I"];

                self.lambda = 6*um;
                self.sigma = 6*um;
                self.z_min = 25*um;
                self.z_max = 39*um;
                self.n = 721;
            
        % GL_off cells
            elseif self.name == "GL_off"
                self.C_m = 50*pF;
                self.G_m = 2*nS;
                self.tau_rest = 25*ms;
                self.E_rest = -60*mV;
                self.E_T = -54.1*mV;
                
                self.E_syn = [0,-70*mV, -80*mV];
                self.g_min = [0,0,0];
                self.g_max = [2.5*nS,2.5*nS,2.0*nS];
                self.V_50 = [-44*mV,-34.4*mV, -47.5*mV];
                self.beta = [3*mV,2.5*mV, 2.0*mV];
                self.type = ["I","I"];

                self.lambda = 6*um;
                self.sigma = 6*um;
                self.z_min = 25*um;
                self.z_max = 39*um;
                self.n = 721;
            end
        end
    end
end

