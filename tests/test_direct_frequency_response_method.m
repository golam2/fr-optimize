s = tf('s')

initial_tf = 2 /s;
bode(initial_tf)
hold on
bp = mfb_bandpass_tf(1,1,1,1);
bode(bp)
bode(initial_tf * bp)
legend('input', 'output', 'bandpass');  
