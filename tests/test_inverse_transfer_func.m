s = tf('s');
lead = (s+2)/(s+1);
lead_inv = 1 / lead;
lead_40 = 40 * lead;

lead_d = lead /60;
lead_d_inv = 1 / lead_d

bode((1/(s+1)));
% hold on
% bode(1/s);
% bode(s + 1/s);
% plot


legend('show');
% bode(s / s);