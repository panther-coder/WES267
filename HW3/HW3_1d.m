% Filter Requirements
fs=40000;
f1=10000;
f2=15000;
A_dB=80;
Beta=A_dB/10; % if A_dB < 40 dB have to reduce Beta
M=floor((fs/(f2-f1))*A_dB/15);
if M-2*ceil(M/2)==0; M=M+1; end
MM=(M-1)/2;
phi=2*pi*(-MM:MM)*(f1+f2)/(2*fs);
h=sin(phi)./phi;
h(MM+1)=1;
h0=h.*kaiser(2*MM+1,Beta)';
h1=h0*(f2+f1)/fs;
h2 = h1 .* cos(pi * (-MM : MM));
figure(1)
subplot(3,1,1)
plot(0:2*MM,h2,'b','linewidth',2)
axis([0 2*MM,-0.30 0.8])
grid on
title('Impulse Response, Highpass FIR Filter')
xlabel('Time Index')
ylabel('Amplitude')
Nfft = 65536;
[H, f] = freqz(h2, 1, Nfft, 'whole', fs);
H_shift = fftshift(H) ;
H_dB = 20*log10(abs(H_shift)) ;
fc = (-Nfft/2:Nfft/2-1)*(fs/Nfft); %shift frequencies to center
subplot (3,1,2);
plot(fc, H_dB, 'b','linewidth' ,2)
hold on
plot ([-f1/2 -f1/2 0], [-20 -A_dB -A_dB], ':r','linewidth',2)
plot([f1/2 f1/2 0], [-20 -A_dB -A_dB], ':r', 'linewidth', 2)
plot([-f1 -f1 -fs/2], [-100 0 0], ':r', 'linewidth', 2)
plot([f1 f1 fs/2], [-100 0 0], ':r', 'linewidth', 2)
% need a new way to find -6dB gain, plot the freq and trace to find freq.
f0 = 7500;
plot ([-f0 -f0], [-100 -6],':r', 'linewidth' ,2)
plot([+f0 +f0], [-100 -6], ':r', 'linewidth', 2)
hold off
grid on
axis ([-fs/2 fs/2 -100 10])
title('Frequency Response, Low Pass FIR Filter')
xlabel ('Frequency, f_S=40 KHz')
ylabel ('Log Mag (dB)')
subplot (3,2,5)
pb_idx = (fc >= f1) & (fc <= f2); % restrict passband between -f1 and +f1
mag_pb = H_dB(pb_idx); %magnitudes in passband
f_pb = fc(pb_idx) ; %frequencies in passband
pb_min = min(mag_pb) ;
pb_max = max(mag_pb) ;
% from here, find peak deviation from unity dB  
peak_dev = max(abs(1 - pb_max), abs(pb_min - 1));
plot(f_pb, mag_pb, 'b', 'linewidth',2); grid on; hold on;
plot([f1 f1 f2 f2 ], [-0.002 pb_min pb_min -0.002],':r', 'linewidth',2)
plot([f1 f1 f2 f2 ], [+0.002 pb_max pb_max +0.002],':r', 'linewidth',2)
hold off
axis ([f1 f2 -0.002 0.002])
title('Passband Ripple')
xlabel('Frequency, f_S=40 kHz')
ylabel('Log Mag (dB)')
subplot (3,2,6)
plot(fc, H_dB, 'b', 'linewidth',2)
hold on
plot([f2 f1 f1 ],[0 0 -100],':r','linewidth',2)
plot([0 f1-5000 f1-5000],[-A_dB -A_dB -20],':r','linewidth',2)
plot([+f0 +f0],[-100 -6],':r','linewidth',2)
hold off
grid on
axis([0 f2 -100 10])
title('Transition Detail')
xlabel('Frequency, f_S=40 kHz')
ylabel('Log Mag (dB)')
%% Pass 19kHz Sinewave
N=1000;
n=0:N-1;
wc2 = 2*pi*19000/fs; %center freq of 19kHz for second sinewave
sin2 = sin(wc2*n); % generate second sinewave at 19kHz
y2 = conv(sin2,h1,'full');%output of sinewave 19kHz passing through FIR lowpass
%Plot y1 and y2 on two separate subplots
figure(2)
subplot(2,1,1);
plot(n(1:400), sin2(1:400)');
title('Input 19kHz Sinewave');
xlabel('n (samples)');
ylabel('Amplitude');
subplot(2,1,2)
plot(n(1:400), y2(1:400)');
title('Output of 19kHz Sinewave through Highpass Filter');
xlabel('n (samples)');
ylabel('Amplitude');