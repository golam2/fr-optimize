% Filter Frequency Response calculation for Demo 
R1 = 100000;
R2 = 2200;
C = 1000 * 10^-9;

gain = 20 * log10(R2 / R1)
w = linspace(100 * 2 * pi, 10000 * 2 * pi, 100);
s = (-1)^.5 * w                                     % substitute s = jw
brickwall = abs(-(R2/R1) .* ( 1 ./ (R2*C*s + 1)));  % compute magnitude

% -----------------------------------
% CREATE AUDIOGRAM FREQUENCY RESPONSE
% -----------------------------------

% NOTE: flipping the numerator and denominator results in inverse tranfer function
load data/gram.dat % load audiogram data

% fixed bandpass capacitor values
C1 = 33 * 10 ^ -9;   % high frequency
C2 = 330 * 10 ^ -9;  % low frequency
% C3 = 220 * 10 ^ -9; % mid frequency

x_i = linspace(100*2*pi, 10000*2*pi, 100); 
y_o = file_to_fr(gram, x_i);

% use y_o_inv for modeling the frequency response
y_o_inv = 1 ./ y_o; 

% flip left to right
% y_o_inv = fliplr(1 ./ y_o);

% TEST: ensure audiogram is accurately interpolated
% semilogx(x_i, 20 * log10(y_o_inv))

% -----------------------------------
% COMBINE FILTER AND AUDIOGRAM FREQUENCY RESPONSE
% Note: currently, phase shift is not taken into consideration in the calculation
% for this application, destruction caused by phase shift has not yet been an issue
% -----------------------------------

% optimal frequency response function in dB
% TODO: modify this to make frequency response easily modifiable
y = 0;    

% weighting function - weight frequencies that speech is spoken in more
% load data/weight.dat
% weight_x = linspace(100 * 2 * pi, 10000 * 2 * pi, 100);
% weight_y = interp1(weight(:,1), weight(:,2), weight_x, 'cubic')
% plot(weight_x, weight_y);

% anonymous function for a single MFB bandpass filter
fun_bp = @(p, C) p(4) * mfb_bandpass(p(1), p(2), p(3), C, x_i);

% define the anonymous function for optimization function
% Note: this combines frequency responses without considering phase shift, which should not be an issue
% this line will use the gram file as the audiogram source
fun = @(prm) (y - 20 * log10( (prm(1) * (y_o_inv) .* (prm(2) + fun_bp(prm(3:6), C1) + fun_bp(prm(7:10), C2))))); % .* weight_y;
% this line will use a defined filter function as the audiogram source
% fun = @(prm) (y - 20 * log10( (prm(1) * (brickwall) .* (prm(2) + fun_bp(prm(3:6), C1) + fun_bp(prm(7:10), C2))))) .* weight_y;

% starting points for optimization
init = [5000, 5000, 5000, 1];
x0 = cat(2, 100, 1, init, init);

% init_gain = [99,0.589];
% init_f1 = [645, 899, 7813, 0.918];
% init_f2 = [9999, 6814, 577, 0];
% x0 = cat(2, init_gain, init_f1, init_f2);

% lower bound
lb = cat(2, 0, zeros(1,9));

% upper bound
upper = [10000, 10000, 10000, 1];
ub = cat(2, 100, 1, upper, upper);

% use MATLAB's lsqnonlin function to perform optimization
x = lsqnonlin(fun, x0, lb, ub)


% ----------------
% PLOT RESULTS
% ----------------
% subplot(2,1,1)
semilogx(x_i, 20 * log10(y_o_inv));  % the original audiogram
hold on
% plot(x_i, x(4) * mfb_bandpass(x(1), x(2), x(3), C, x_i))

% plot filter output only
semilogx(x_i, 20 * log10(x(1) * ((x(2) + fun_bp(x(3:6), C1) + fun_bp(x(7:10), C2)))))
    
%regular plot with dB
% plot(x_i, 20 * log10(x(1) * (y_o_inv) .* (x(2) + fun_bp(x(3:6), C1) + fun_bp(x(7:10), C2))))

%log plot with dB
semilogx(x_i, 20 * log10(x(1) * (y_o_inv) .* (x(2) + fun_bp(x(3:6), C1) + fun_bp(x(7:10), C2))))

% plot(x_i, 20 * log10(x(1) * (y_o_inv) .* (x(2) + fun_bp(x(3:6), C1) + fun_bp(x(7:10), C2))))

legend('input', 'filter', 'output');
xlabel('Frequency (rad/s)');
ylabel('Gain (dB)');
xlim([100*2*pi 10000*2*pi])

% TODO: create weight function for weighting speech frequencies more
% TODO: create weight function to weight rapidly changing responses negatively