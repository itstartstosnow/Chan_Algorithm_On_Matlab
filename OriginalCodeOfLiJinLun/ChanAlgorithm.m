function X = ChanAlgorithm(BSN, MSP, Radius, Noise)
%CHANALGORITHM 本函数用于实现无线定位中的CHAN算法
%               - BSN  为基站个数，3 < BSN <= 7；
%               - MSP  为移动台的初始位置, MSx, MSy均为[0,1]之间的数；
%                      特别要注意服务小区与MS之间的关系，MS的位置不能越界。
%               - Noise 测距误差方差。
%               - R    为小区半径，单位(meter)；
%               - X    为移动台经算法处理后的位置.
%See also: ChanAlgorithm.m
 
%   李金伦，西南交通大学
%       10 December, 2004, 第一版
 
%   参数检查：
if  nargout>1
    error('Too many output arguments.');
end
if nargin<2 || nargin>4
    error('Wrong number of input arguments.');
end
 
 
% 算法开始：
BS = Radius*NetworkTop(BSN); %BS 两行，各个BS的x和y
MS = Radius*MSP;
 
% 噪声功率：
Q = eye(BSN-1);
 
% 第一次LS：
% Ri
K1 = 0;
for i = 1: BSN
    R0(i) = sqrt((BS(1,i) - MS(1))^2 + (BS(2,i) - MS(2))^2);
end
 
for i = 1: BSN-1
    R(i) = R0(i+1) - R0(1) + Noise*randn(1);
    K(i) = BS(1,i+1)^2 + BS(2,i+1)^2;
end
 
% Ga
for i = 1: BSN-1
    Ga(i,1) = -BS(1, i+1);
    Ga(i,2) = -BS(2, i+1);
    Ga(i,3) = -R(i);
end
 
% h
for i = 1: BSN-1
    h(i) = 0.5*(R(i)^2 - K(i) + K1);
end
 
% 由（14b）给出B的估计值：
Za0 = inv(Ga'*inv(Q)*Ga)*Ga'*inv(Q)*h';
 
% 利用这个粗略估计值计算B：
B = eye(BSN-1);
for i = 1: BSN-1
    B(i,i) = sqrt((BS(1,i+1) - Za0(1))^2 + (BS(2,i+1) - Za0(2))^2);
end
 
% FI:
FI = B*Q*B;
 
% 第一次LS结果：
Za1 = inv(Ga'*inv(FI)*Ga)*Ga'*inv(FI)*h';
 
if Za1(3) < 0
    Za1(3) = abs(Za1(3));
%     Za1(3) = 0;
end
%***************************************************************
 
% 第二次LS：
% 第一次LS结果的协方差：
CovZa = inv(Ga'*inv(FI)*Ga);
 
% sB：
sB = eye(3);
for i = 1: 3
    sB(i,i) = Za1(i);
end
 
% sFI：
sFI = 4*sB*CovZa*sB;
 
% sGa：
sGa = [1, 0; 0, 1; 1, 1];
 
% sh
sh  = [Za1(1)^2; Za1(2)^2; Za1(3)^2];
 
% 第二次LS结果：
Za2 = inv(sGa'*inv(sFI)*sGa)*sGa'*inv(sFI)*sh;
 
% Za = sqrt(abs(Za2));
 
Za = sqrt(Za2);
 
% 输出:
% if Za1(1) < 0,
%     out1 = -Za(1);
% else
%     out1 = Za(1);
% end
% if Za2(1) < 0,
%     out2 = -Za(2);
% else
%     out2 = Za(2);
% end
% 
% out = [out1;out2];
out = abs(Za);
 
% out = Za;
 
if nargout == 1
    X = out;
elseif nargout == 0
    disp(out);
end
