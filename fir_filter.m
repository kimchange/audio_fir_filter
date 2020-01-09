function hn = fir_filter(ws1,wp1,wp2,ws2,alphaS)
% author: Kimchange 3017207458 from TJU
% 理想 非带阻 滤波器设计
% ws1, wp1, wp2, ws2 依次不递减,单位弧度rad
% wp1 = 0， 即为理想线性相位低通滤波器
% wp2 = pi，即为理想线性相位高通滤波器。
% --------------------------------

%  alphaS = 阻带最小衰减dB,认为不超过80dB
%

% Band 过渡带宽度
if wp1 == 0
    Band = (ws2 - wp2);
elseif wp2 == pi
    Band = (wp1 - ws1);
else 
    Band = min( (ws2 - wp2) ,(wp1 - ws1) );
end


alphaS = abs(alphaS);
if alphaS <= 21
    M = 1.8*pi/Band;
    M = floor( ceil(M)/2 )*2+1;            % 取大于等于M的最小奇数
    win = rectwin(M);                      % 矩形窗
elseif alphaS > 21 & alphaS <= 25
    M = 6.1*pi/Band;
    M = floor( ceil(M)/2 )*2+1;            % 取大于等于M的最小奇数
    win = bartlett(M);                     % 三角窗
elseif alphaS > 25 & alphaS <= 44
    M = 6.1*pi/Band;
    M = floor( ceil(M)/2 )*2+1;            % 取大于等于M的最小奇数
    win = hanning(M);                      % 汉宁窗
elseif alphaS > 44 & alphaS <= 53
    M = 6.6*pi/Band;
    M = floor( ceil(M)/2 )*2+1;            % 取大于等于M的最小奇数
    win = hamming(M);                      % 汉明窗
elseif alphaS > 53 & alphaS <= 74
    M = 11*pi/Band;
    M = floor( ceil(M)/2 )*2+1;            % 取大于等于M的最小奇数
    win = blackman(M);                     % 布莱克曼窗
else
    M = 10*pi/Band;
    M = floor( ceil(M)/2 )*2+1;            % 取大于等于M的最小奇数
    win = kaiser(M,7.865);                 % 凯赛窗
end
    

M = double(M);
alpha = (M-1)/2;
n = [0:1:(M-1)];
m = n - alpha + eps;
hdn = ( sin( (wp2+ws2)/2 *m) - sin((wp1+ws1)/2 *m) ) ./ (pi*m);
hn = hdn.*win';
end


