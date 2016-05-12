% This script is used to comptute a customized ideal frequency response
% function to be used with the optimize_filter_circuit scripts. The
% function y_ideal is interpolated from user defined points
% -------------------------------------------------------------------------

x_i = linspace(100, 10000, 1000) * 2 * pi;
x = [100 156 312 625 1250 2500 5000 10000] * 2 * pi;

% define ideal function in dB here
y_ideal = [0 0 0 0 5 10 25 15];

% interpolate to smoothen and convert to gain
y_ideal = interp1(x, 10 .^ (y_ideal ./ 20 ), x_i, 'pchip');
% use the computed function as the ideal y value in simulation

% plot dB
semilogx(x_i, 20 * log10(y_ideal));

% semilogx(x_i, 20 * log10(y_ideal));

ylim([-50 50]);
xlim([100 10000] * 2* pi)
