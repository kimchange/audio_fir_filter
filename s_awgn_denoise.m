%% add awgn
clear;clc;close all;
[x,Fs] = audioread('chirp.wav');
N=length(x);

subplot(2,4,1);
plot(x);title('原始信号波形');

y=fft(x,N);
df = Fs/N;
f = 0:df:df*(round(N/2)-1);
Xk=abs(y)/N;
Xk(1) = Xk(1)*2;
subplot(2,4,5)
plot(f,Xk(1:round(N/2)));title('原始信号幅度谱');
axis([0 Fs/2 0 max(Xk)*1.2]); xlabel('频率(单位：Hz)'); ylabel('幅度值');

x_awgn = awgn(x,20);
subplot(2,4,2);
plot(x_awgn);title('加噪语音信号的时域波形');

y_awgn = fft(x_awgn,N);
Xk_awgn=abs(y_awgn)/N;
Xk_awgn(1) = 2*Xk_awgn(1);
subplot(2,4,6);
plot(f,Xk_awgn(1:round(N/2)));title('加噪语音信号的幅度谱');
axis([0 Fs/2 0 max(Xk_awgn)*1.2]); xlabel('频率(单位：Hz)'); ylabel('幅度值');

%% denoise  使用BPF
ws1 = 2*pi*2000/Fs;                     % 阻带截止频率2000Hz
wp1 = 2*pi*2200/Fs;                     % 通带截止频率2200Hz
wp2 = 2*pi*4000/Fs;                     % 通带截止频率4000Hz
ws2 = 2*pi*4090/Fs;                     % 阻带截止频率4090Hz
alphaS = 50;                            % 阻带最小衰减

hn_BPF = fir_filter(ws1,wp1,wp2,ws2,alphaS);
x_denoise_BPF = filter(hn_BPF,1,x_awgn);
subplot(2,4,3);
plot(x_denoise_BPF);title('BPF滤波后的时域波形');

y_denoise_BPF = fft(x_denoise_BPF,N);
Xk_denoise_BPF=abs(y_denoise_BPF)/N;
Xk_denoise_BPF(1) = 2*Xk_denoise_BPF(1);
subplot(2,4,7);
plot(f,Xk_denoise_BPF(1:round(N/2)));title('BPF滤波后的幅度谱');
axis([0 Fs/2 0 max(Xk_denoise_BPF)*1.2]); xlabel('频率(单位：Hz)'); ylabel('幅度值');


% HPF
ws1_HPF = 2*pi*2000/Fs;                     % 阻带截止频率2000Hz
wp1_HPF = 2*pi*2200/Fs;                     % 通带截止频率2200Hz
wp2_HPF = pi;
ws2_HPF = pi;                               %高通

hn_HPF = fir_filter(ws1_HPF,wp1_HPF,wp2_HPF,ws2_HPF,alphaS);
x_denoise_HPF = filter(hn_HPF,1,x_awgn);
subplot(2,4,4);
plot(x_denoise_HPF);title('HPF滤波后的时域波形');

y_denoise_HPF = fft(x_denoise_HPF,N);
Xk_denoise_HPF=abs(y_denoise_HPF)/N;
Xk_denoise_HPF(1) = 2*Xk_denoise_HPF(1);
subplot(2,4,8);
plot(f,Xk_denoise_HPF(1:round(N/2)));title('HPF滤波后的幅度谱');
axis([0 Fs/2 0 max(Xk_denoise_HPF)*1.2]); xlabel('频率(单位：Hz)'); ylabel('幅度值');

sound(x,Fs);
pause(2);
sound(x_awgn,Fs);
pause(2);
sound(x_denoise_BPF,Fs);
pause(2);
sound(x_denoise_HPF,Fs);
