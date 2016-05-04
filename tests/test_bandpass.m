C = 39 * 10 ^ - 9;
x_i = linspace(100,10000,100);
bandpass = mfb_bandpass(2500, 10000, 10000, C, x_i);
semilogx(x_i ./ (2 * pi), 20 * log10(bandpass));
title('Band Pass Frequency Response');
xlabel('rad/s');
ylabel('Magnitude dB');