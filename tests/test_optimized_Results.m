load data/gram.dat

x_i = linspace(100,10000,100);
y_o = make_FR(gram, x_i);

C = 39 * 10 ^ -9;
% hold on
% bode(tf(gram_a, gram_b) + tf(gram_a, gram_b) * mfb_bandpass_tf(4245, 10000, 10000, C) * 6.54)
% bode((1 ./ y_o) .* (1 + mfb_bandpass_tf(.07, .142, 10000, C) * 0.000775322367308768))


plot(x_i, 20 * log10(1./y_o));
hold on
% plot(x_i, 0.00077 * mfb_bandpass(.07, .142, 10000, C, x_i))
% plot(x_i, 20 * log10((1 ./ y_o) .* (1 + 0.00077 * mfb_bandpass(.07, .142, 10000, C, x_i))))

plot(x_i, 0.146 * mfb_bandpass(4.2, 8.4, 10000, C, x_i))
plot(x_i, 20 * log10((1 ./ y_o) .* (1 + 0.146 * mfb_bandpass(4.2, 8.4, 10000, C, x_i))))

legend('input', 'filter and gain', 'output');
% axis([20 10000 -100 0])
% bode(tf(gram_a, gram_b) * mfb_bandpass_tf(4142, 10000, 10000, C) * 6.46)

% 330, 220, 39, 15 max gain
