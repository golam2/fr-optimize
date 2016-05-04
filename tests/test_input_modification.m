% a = [1 2 3 2 1 4];
% b = [1 2 3 2 3];
% 
% [h,w] = freqs(b,a,64);
% h
% w
% 
% square(9)

%mfb_bandpass test
% func = mfb_bandpass(2, 2, 2, 4, 5)
% bode(func)
% anon_func = @(a,b,c,d,e) mfb_bandpass(a, b,s c, d, e);

% syms s 
% func = s
% s = 5
% func = s
% out = subs(func, s, 10)

load data/gram.dat
temp = (gram(:,1));
x_i = gram(1,1):100:temp(end)

y_i = interp1(gram(:,1), 10 .^ (gram(:,2) ./ 20), transpose(x_i), 'pchip')

plot( gram(:,1), 10 .^ (gram(:,2) / 20) );
hold on
plot(x_i, y_i); % the amplitude is NOT in log format

% [length, xxx] = size(y_i)
% wt = linspace(1,1, length);
% size(gram(:,1));
% % [gram_b, gram_a] = invfreqs(10 .^ (gram(:,2) ./ 20), gram(:,1), 4, 5)
% [gram_b, gram_a] = invfreqs(y_i, x_i, 4, 5)
% bode(gram_a, gram_b)
% axis([20 15000 -100 0])