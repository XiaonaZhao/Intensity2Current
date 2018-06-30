function Voltage  = calculateVolt(Current)

Dots = length(Current);
Voltage1 = 0;
Voltage2 = -0.5;
VoltDots = (linspace(Voltage1,Voltage2,...
    (Dots + mod(Dots, 2))/2 ))';% linspace is row vector
if mod(Dots, 2)
    Voltage = [VoltDots; VoltDots(1:end-1)];
else
    Voltage = [VoltDots; VoltDots];
end
end