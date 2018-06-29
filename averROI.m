function Intensity = averROI(roiSeq, roiNum)

Intensity = zeros(roiNum, 1);
for j = 1:roiNum
    temp = roiSeq{j}; % temp is 640x480
    nonzero = find(temp(:)~=0);
    Intensity(j) = sum( temp(:) )/(length(nonzero)); % Intensity is column vector
end
clear j
end