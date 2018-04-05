function X = NetworkTop(BSN) 
%  本程序生成网络拓扑，假设网络半径为1 
%  NetworkTop 
%    参数说明： 
%        BSN:   蜂窝网络中基站数目 3<=BSN<=7 
%  Also see: NetworkTop. 
 
%  Designed by 李金伦, SWJTU, 2005.10.4 
 
%  参数检测: 
if nargout>1, 
    error('Too many output arguments!'); 
end  
if nargin ~= 1 
    error('input arguments error!'); 
end 
if BSN > 7 | BSN < 3, 
    error('Overflow!'); 
end 
 
% 7小区网络拓扑： 
BS = [0, sqrt(3), 0.5*sqrt(3), -0.5*sqrt(3), -sqrt(3), -0.5*sqrt(3), 0.5*sqrt(3); 
      0,      0,         1.5,          1.5,        0,         -1.5,        -1.5]; 
 
% BSN个小区网络拓扑： 
for i = 1 : BSN, 
    X(1,i) = BS(1,i); 
    X(2,i) = BS(2,i); 
end 
 
% 结果输出： 
if nargout == 1, 
    X; 
else 
    disp(X); 
end 