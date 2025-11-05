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
h_no_window=h; % no window applied this time
h1=h_no_window*(f2+f1)/fs; %scale factor is still applied 

figure(1)
subplot(3,1,1)
plot(0:2*MM,h1,'b','linewidth',2)
grid on
axis([-2 2*MM+2,-0.15 0.8])
title('Impulse Response, Low Pass FIR Filter, No Window')
xlabel('Time Index')
ylabel('Amplitude')
Nfft = 65536;
[H, f] = freqz(h1, 1, Nfft, 'whole', fs);
H_shift = fftshift(H) ;
H_dB = 20*log10(abs(H_shift)) ;
fc = (-Nfft/2:Nfft/2-1)*(fs/Nfft); %shift frequencies to center

subplot (3,1,2);
plot(fc, H_dB, 'b','linewidth' ,2)
hold on
plot ([-fs/2 -f2 -f2], [-A_dB -A_dB -20], ':r','linewidth',2)
plot([+fs/2 +f2 +f2], [-A_dB -A_dB -20], ':r', 'linewidth', 2)
plot([-f1 -f1 +f1 +f1], [-100 0 0 -100], ':r', 'linewidth', 2)
f0= (f1+f2)/2;
plot ([-f0 -f0], [-100 0],':r', 'linewidth' ,2)
plot([+f0 +f0], [-100 0], ':r', 'linewidth', 2)
hold off
grid on
axis ([-fs/2 fs/2 -100 10])
title('Frequency Response, Low Pass FIR Filter, No Window')
xlabel ('Frequency, f_S=40 KHz')
ylabel ('Log Mag (dB)')

subplot (3,2,5)
pb_idx = (fc >= -f1) & (fc <= f1); % restrict passband between -f1 and +f1
mag_pb = H_dB(pb_idx); %magnitudes in passband
f_pb = fc(pb_idx) ; %frequencies in passband
pb_min = min(mag_pb) ;
pb_max = max(mag_pb) ;
% from here, find peak deviation from unity dB  
peak_dev = max(abs(1 - pb_min), abs(pb_max - 1));
plot(f_pb, mag_pb, 'b', 'linewidth',2); grid on; hold on;
plot([-f1 -f1 f1 f1 ], [-0.002 pb_min pb_min -0.002],':r', 'linewidth',2)
plot([-f1 -f1 f1 f1 ], [+0.002 pb_max pb_max +0.002],':r', 'linewidth',2)
hold off
axis ([-f0 f0 -0.002 0.002])
title('Passband Ripple')
xlabel('Frequency, f_S=40 kHz')
ylabel('Log Mag (dB)')

subplot (3,2,6)
plot(fc, H_dB, 'b', 'linewidth',2)
hold on
plot([f1/2 f1 f1 ],[0 0 -100],':r','linewidth',2)
plot([+f2+5000 +f2 +f2],[-A_dB -A_dB -20],':r','linewidth',2)
plot([+f0 +f0],[-100 0],':r','linewidth',2)
hold off
grid on
axis([f1/2 f2+5000 -100 10])
title('Transition Detail, , No Window')
xlabel('Frequency, f_S=40 kHz')
ylabel('Log Mag (dB)')