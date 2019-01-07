%% -- raw figures
Potential = sheet(:, 6);
for n = 1:col
    Current(:, n) = intensity2current(Yfit(:, n), 1601);
end

figure('color','w');
for n = [1 3]
    plot(Potential(4:end), -Current(3:end, n)); % get fitted lines
    hold on
end

xlabel('Potential/V','fontsize',10);
ylabel('I-Current','fontsize',10);
set(findobj(get(gca, 'Children'), 'LineWidth',0.5), 'LineWidth', 2);
set(gca, 'linewidth', 1.5)

%% -- signal frequency spectrum
Fs = 800; % hamamatsu camera in CV
% Fs = 200; % hamamatsu camera in i-t
X2 = Yfit(:, 4);
% Y2 = fft(X2);
% L = length(X2);
% P2 = abs(Y2/L);
% P1 = P2(1:L/2+1);
% P1(2:end-1) = 2*P1(2:end-1);
% f = Fs*(0:(L/2))/L;
[f, P1] = fft_P1(X2, Fs);
figure('color','w');
plot(f, P1)
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')

%%
color = [...
    'r',... % Red 1
    'g',... % Green 2
    'b',... % Blue 3
    'c',... % Cyan 4
    'm',... % Magenta 5
    'y',... % Yellow 6
    'k',... % Black 7
    'w',... % White 8
    ];
roiLabel = ['1', '2', '3', '4',...
    '5', '6', '7'];

%% -- filtered 1-D digital i-t signal
filtY = zeros(size(Y));
for n = 1:col
    filtY(:, n) = lowp(Y(:, n), 1, 4, 0.1, 20, Fs);
end

figure('color','w');
for n = 1:col
    plot(X, filtY(:, n), color(n));
    hold on
end

legend
xlabel('Frame');
ylabel('¦¤Intensity');

%% -- filtered 1-D digital CV signal
filtCurrent = zeros(size(Current(3:end, :)));
for n = [1 3]
    filtCurrent(:, n) = lowp(Current(3:end, n), 4, 30, 0.1, 20, 800);
end

figure('color','w');
for n = [1 3]
    % scatter(Potential(4:end), -filtCurrent(:, n));
    %     figure('color','w');
%     plot(Potential(4:end), -filtCurrent(:, n), color(n));
plot(Potential(4:end), -filtCurrent(:, n));
    %     legend(roiLabel(n)); % plot respectively
    %     xlabel('Potential/V');
    %     ylabel('¦¤Current');
    hold on
end

legend
xlabel('Potential/V','fontsize',10);
ylabel('I-Current','fontsize',10);
set(findobj(get(gca, 'Children'), 'LineWidth',0.5), 'LineWidth', 2);
set(gca, 'linewidth', 1.5)