function [o] = mfb_bandpass(R1, R2, R3, C, w)
% syms s
% s = tf('s');
syms s

% the following uses equations from 
% http://www.ti.com/lit/ml/sloa088/sloa088.pdf

% w_m = (1/(C)) * ((R1 + R3) / (R1*R2*R3))^.5;
% w_m = 1;
% num = -((R2 * R3) / (R1 + R3)) * C * w_m * s;
% den1 = 2 * (( R1 * R3) / (R1 + R3)) * C * w_m * s;
% den2 = (( R1 * R2 * R3) / (R1 + R3)) * C^2 * w_m^2 * s^2; 
% % pretty(n)
% % pretty(d1)
% % pretty(d2)
% 
% mid_frequency = (1 / (2 * pi * C) ) * ((R1 + R3) / (R1 * R2 * R3)) ^ .5
% circular_mid_frequency = mid_frequency  * (2 * pi)
% 
% gain = R2 / (2 * R1)
% 
% quality = pi * mid_frequency * R2 * C
% full transfer function for MFB bandpass filter




% the following uses equations from 
% http://ocw.mit.edu/courses/mechanical-engineering/2-161-signal-processing-continuous-and-discrete-fall-2008/study-materials/lpopamp.pdf
a_0 = (1 / (R3 * C^2)) * ((1/R1) + (1/R2));
a_1 = (2 * C) / (R3 * C^2);
k = (R3 * C) / (R1 * (2 * C));

% mid_frequency = (1 / (2 * pi * C) ) * ((R1 + R2) / (R1 * R3 * R2)) ^ .5
% circular_mid_frequency = mid_frequency  * (2 * pi)
% % 
% gain = - R3 / (2 * R1)
% % 
% quality = pi * mid_frequency * R3 * C
s = (-1) ^ .5 * w;

o = abs( (-k * a_1 * s) ./ (s.^2 + a_1 * s + a_0));
% o = num / (1 + den1 + den2);
% o = subs(o, s, (-1) ^ .5 * w);
% o = abs(o);
end
