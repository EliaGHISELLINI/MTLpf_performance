function [x_sat] = SAT(x_comp)
% Saturation 
%   saturation between -1.0 and 1.0

if x_comp > -1.0
    if x_comp < 1.0
        x_sat = x_comp;
    else 
        x_sat = 1.0;
    end 
else 
    x_sat = -1.0; 
end

end