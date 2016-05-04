
R1 = 100000;
R2 = 2200;
C = 1000 * 10^-9;

gain = 20 * log10(R2 / R1)
w = linspace(100, 10000, 100);
s = (-1)^.5 * w
brickwall = abs(-(R2/R1) .* ( 1 ./ (R2*C*s + 1)));
% semilogx(w, 20 * log10(brickwall))
% return
%bode plot
s = tf('s')
brickwall = -(R2/R1) * ( 1 / (R2*C*s + 1));

% semilogx(w, 20*log10(brickwall))
bode(brickwall);
xlim([100 10000])


% b = [-(R2/R1)];
% a = [R2*C  1];
% w = logspace(100,10000,100);
% freqs(b,a)
% xlim([100 10000])