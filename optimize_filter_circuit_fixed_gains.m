% This script attempts to optimize a circuit consisting of MFB bandpass
% filters to compensate for human hearing loss, specified in the gram.dat   
% file as a frequency response in terms of magnitude (dB) vs frequency (Hz)
% NOTE: While the input is given in Hz, this script converts the input 
% to radians/sec andperforms all operations in radians/sec for simplicity
% -------------------------------------------------------------------------

% Test frequency response of low pass filter
% s = tf('s')
% lp = (1/(1+s/1000));
% bode(lp);
% return

% -----------------------------------
% CREATE AUDIOGRAM FREQUENCY RESPONSE
% -----------------------------------

% NOTE: flipping the numerator and denominator results in inverse tranfer function
load data/gram_mixed2.dat % load audiogram data
gram = gram_mixed2

% TEST: modfiy audiogram for testing various types of inputs --------
%       gram(:,2) = circshift(gram(:,2), 1);
%       gram(:,2) = gram(:,2) + 20;
%       gram
%       return


% fixed bandpass capacitor values
C1 = 8.2 * 10 ^ -9;   % high frequency
C2 = 330 * 10 ^ -9;  % low frequency
% C3 = 100 * 10 ^ -9; % mid frequency

x_i = linspace(100, 10000, 1000) * 2*pi; 
y_o = file_to_fr(gram, x_i);

% use y_o_inv for modeling the frequency response
y_o_inv = 1 ./ y_o; 

% uncomment the following 2 lines
s_f = (-1) ^ .5 * x_i;
y_o_inv = 1 ./ (1+s_f / 1000);

% TEST: ensure audiogram is accurately interpolated
%       semilogx(x_i, 20 * log10(y_o_inv))
%       return

% -----------------------------------
% COMBINE FILTER AND AUDIOGRAM FREQUENCY RESPONSE
% -----------------------------------

% compute the ideal functoin
tune_ideal
% optimal frequency response function in dB computed in tune_ideal
y = y_ideal;
% y = 1

% weighting function - weight frequencies that speech is spoken in more
load data/weight.dat
weight_x = x_i;
% weight_x = linspace(100, 10000, 100);
weight_y = interp1(weight(:,1) , weight(:,2), weight_x, 'pchip')

% TEST: graph weight
%       semilogx(weight_x, weight_y);
%       xlim([100*2*pi 10000*2*pi])
%       return

% anonymous function for a single MFB bandpass filter
fun_bp = @(p, C) mfb_bandpass(p(1), p(2), p(3), C, x_i);

% define the anonymous function for optimization function
fixed_gain = 10;
fun = @(prm) (y - abs(fixed_gain * ...
                              (y_o_inv) .* ...
                                 (prm(1) + ...
                    fun_bp(prm(2:4), C1) + ...
                   fun_bp(prm(5:7), C2)))) %.* weight_y;
               
% this line will use a defined filter function as the audiogram source
% fun = @(prm) (y - 20 * log10( (prm(1) * (brickwall) .* (prm(2) + fun_bp(prm(3:6), C1) + fun_bp(prm(7:10), C2))))) .* weight_y;

% starting points for optimization
init_bp = [2000, 2000, 10000];
x0 = cat(2, -1, init_bp, init_bp);

% init_gain = [99,0.589];
% init_f1 = [645, 899, 7813, 0.918];
% init_f2 = [9999, 6814, 577, 0];
% x0 = cat(2, init_gain, init_f1, init_f2);

% lower bound
lb = cat(2, -1, 1000, 1000, 1000, 1000, 1000, 1000);
% lb = cat(2, -1, 75, 75, 75, 75, 75, 75);

% upper bound
upper_bp = [10000, 10000, 10000];
ub = cat(2, 0, upper_bp, upper_bp);

% use MATLAB's lsqnonlin function to perform optimization
tic
x = lsqnonlin(fun, x0, lb, ub)
% x = fmincon(fun, x0, lb, ub)
toc

% ----------------
% PLOT RESULTS
% ----------------

% x_i = 100:100:10000;
% x_i = 
% subplot(2,1,1)
semilogx(x_i, 20 * log10( abs(y_o_inv) ));  % the original audiogram
hold on
% plot(x_i, x(4) * mfb_bandpass(x(1), x(2), x(3), C, x_i))

% plot filter output only
semilogx(x_i, 20 * log10( abs(fixed_gain * ((x(1) + ...
                               fun_bp(x(2:4), C1) + ...
                               fun_bp(x(5:7), C2) )))))
                   
% regular plot with dB
% plot(x_i, 20 * log10(x(1) * (y_o_inv) .* (x(2) + fun_bp(x(3:6), C1) + fun_bp(x(7:10), C2))))

% log plot with dB
semilogx(x_i, 20 * log10( abs(fixed_gain * (y_o_inv) .* (x(1) + ...
                                           fun_bp(x(2:4), C1) + ...
                                           fun_bp(x(5:7), C2)))))

% plot(x_i, 20 * log10(x(1) * (y_o_inv) .* (x(2) + fun_bp(x(3:6), C1) + fun_bp(x(7:10), C2))))

% plot individual filters

% subplot(2,1,2)
semilogx(x_i, 20 * log10( abs((fun_bp(x(2:4), C1) ))));
semilogx(x_i, 20 * log10( abs((fun_bp(x(5:7), C2) ))));
% semilogx(x_i, 20 * log10( abs(x(1) * (fun_bp(x(9:11), C3) ))));

legend('input', 'filter', 'output', 'filter1', 'filter2');
xlabel('Frequency (rad/s)');
ylabel('Gain (dB)');
    % xlim([100*2*pi 10000*2*pi])
xlim([100 10000] * 2*pi)