function begin = triggerTime(data, t, Fs)
% check the timeline of double trigger

% [~, begin.pike] = max(diff(data(:, 1))); % trigger dot of the camera
[~, begin.hmmt] = max(diff(data(:, 3))); % trigger dot of the camera

plot(t, data(:, 2))

[x, ~] = ginput(2);
x1 = t((x(1)*10000):(x(2)*10000))';
y1 = data((x(1)*10000):(x(2)*10000), 2);
[x, ~] = ginput(2);
x2 = t((x(1)*10000):(x(2)*10000))';
y2 = data((x(1)*10000):(x(2)*10000), 2);

[px, ~] = crosspoint(x1, y1, x2, y2);
begin.CS1 = px*10000; % trigger dot of the CS studio


begin.frame = ceil((begin.CS1 - begin.hmmt + 1)/10000*Fs);

end

