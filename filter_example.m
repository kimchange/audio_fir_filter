% clear;clc;
% author: Kimchange 3017207458
% hn = fir_filter(0,0,0.2*pi,0.4*pi,30);            % 低通
% hn = fir_filter(0.2*pi,0.4*pi,pi,pi,50);          % 高通
% hn = fir_filter(0.1*pi,0.2*pi,0.6*pi,0.8*pi,50);    % 带通

[H,w] = freqz(hn_HPF,1,1000,'whole');
% H = (H(1:1:501))'; %只取 0～pi 区间
% w = (w(1:1:501))'; %只取 0～pi 区间
mag = abs(H);
db = 20*log10((mag + eps) / max(mag));

plot(w/pi,db); title('幅度响应'); grid;
axis([0 1 -100 10]); xlabel('频率(单位 pi)'); ylabel('dB');