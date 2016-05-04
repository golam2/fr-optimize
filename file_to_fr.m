% input is a set of x and y values that will be interpolated
% x_i is a vector that specifies the domain
function [y_o] = file_to_fr(input, x_i)

% multiply the input x by 2 * pi since it is in hertz
y_o = interp1(input(:,1) * 2 * pi, 10 .^ (input(:,2) ./ 20), x_i, 'pchip');
end
