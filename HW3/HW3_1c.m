N=1000;
n=0:N-1;
%%%% impulse response for lowpass filter %%%%
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

wc1 = 2*pi*1000/fs;  %center freq of 1kHz for first sinewave
wc2 = 2*pi*19000/fs; %center freq of 19kHz for second sinewave
sin1 = sin(wc1*n); %generate first sinewave at 1kHz
sin2 = sin(wc2*n); % generate second sinewave at 19kHz

y1 = conv(sin1,h1,'full');%output of sinewave 1kHz passing through FIR lowpass
y2 = conv(sin2,h1,'full');%output of sinewave 19kHz passing through FIR lowpass

%Plot y1 and y2 on two separate subplots
figure(1)
subplot(2,1,1);
plot(n(1:400), sin1(1:400)');
title('Input 1kHz Sinewave');
xlabel('n (samples)');
ylabel('Amplitude');
subplot(2,1,2)
plot(n(1:400), y1(1:400)');
title('Output of 1kHz Sinewave through Lowpass Filter');
xlabel('n (samples)');
ylabel('Amplitude');

figure(2)
subplot(2,1,1);
plot(n(1:400), sin2(1:400)');
title('Input 19kHz Sinewave');
xlabel('n (samples)');
ylabel('Amplitude');
subplot(2,1,2)
plot(n(1:400), y2(1:400)');
title('Output of 19kHz Sinewave through Lowpass Filter');
xlabel('n (samples)');
ylabel('Amplitude');

% Combine the outputs of both sinewaves
sine_combo = sin1 + sin2;
y_combo = conv(sine_combo,h1,'full');%output of sinewave 1kHz passing through FIR lowpass
figure(3)
subplot(2,1,1);
plot(n(1:400), sine_combo(1:400)');
title('Combined Input Sinewave');
xlabel('n (samples)');
ylabel('Amplitude');
subplot(2,1,2)
plot(n(1:400), y_combo(1:400)');
title('Output of Combined Sinewave through Lowpass Filter');
xlabel('n (samples)');
ylabel('Amplitude');