% myChan3 定位误差的变化规律

% 基站数目
BSN = 7;

% 各个基站的位置
BS = [0, sqrt(3), 0.5*sqrt(3), -0.5*sqrt(3), -sqrt(3), -0.5*sqrt(3), 0.5*sqrt(3); 
      0,      0,         1.5,          1.5,        0,         -1.5,        -1.5;
      0,      0,           0,            0,        0,            0,           0]; 
BS = BS(:,1:BSN);
BS = BS .* 50;

% MS的实际位置
MS = [20, 20*sqrt(3), 0];

% R0i是各个BS与MS的实际距离，无噪声
for i = 1: BSN
    R0(i) = sqrt((BS(1,i) - MS(1))^2 + (BS(2,i) - MS(2))^2 + (BS(3,i) - MS(3))^2); 
end

% 噪声方差
Noise = 1;

% R=R_{i,1},是加上了噪声后，BSi与BS1到MS的距离差，在实际使用中应该由 TDOA * c算得
for i = 1: BSN-1
    R(i) = R0(i+1) - R0(1) + Noise * randn(1); 
end

X = myChan3(BSN, BS, R)

