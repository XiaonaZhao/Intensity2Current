function Current = intensity2current(Intensity)
% The reaction on the electrode surface: H2O + e- = H + OH-
%
%
n = -1;    % Number of electrons transferred in the cell;
F = 9.65e4;   %Faraday constant;
R = 8.314 ;   % Universal gas constant;
T = 280;      % Temperature;
Do = 1e-9; % Difusion coefficient of oxydant;
Dr = 1e-9; % Difusion coefficient of reductant;
D = 1e-9;

AlphaOxi = 7.34;
AlphaRe = 7.34./2;
Constant = (-1).*(AlphaOxi-AlphaRe)./(D.^(0.5))./(n.*F.*(pi.^(0.5)));

imgNum = length(Intensity);
Current = zeros(imgNum-1,1);
Sum_new = zeros(imgNum-2,1);
for i = 3 : imgNum
    Sum_new(i) = sum(real(Current(1:i-2)'./Sub(i-2,1:i-2))).*(DeltaT(i));
    Current(i-1) = (SPRResponse(i-1)./Constant - Sum_new(i))./abs(DeltaT(i-1)).*((Time(i)-Time(i-1)).^(0.5));
end
Current = Current*(-1);

