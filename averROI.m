function Intensity = averROI(roiSeq, roiNum)

Intensity = zeros(roiNum, 1);
for j = 1:roiNum
    temp = roiSeq{j}; % temp is 640x480
    Intensity(j) = mean( temp(:) ); % Intensity is column vector
end
clear j