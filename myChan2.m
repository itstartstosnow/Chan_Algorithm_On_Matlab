function X = myChan2(BSN, BS, R)
%   实现无线定位中的CHAN算法
%   参考：ChanAlgorithm.m NetworkTop.m 李金伦，西南交通大学，10 December, 2004, 第一版
%       - BSN 为基站个数，3 < BSN <= 7；
%       - BS 为 (2, BSN) 矩阵，为各个 BS 的坐标 x 和 y
%       - R 为 (BSN-1) 向量，为论文中的 r_{i,1}，即第 2,3,...BSN 个基站与第一个基站
%           距 MS 的距离之差，可由TDOA乘以光速直接算得
%       - X 为算得的 MS 的位置 x 和 y
 
    % 噪声功率：
    Q = eye(BSN-1);

    % 第一次LS：
    K1 = 0;
    for i = 1: BSN-1
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
