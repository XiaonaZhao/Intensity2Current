function Intensity = averROI(roiSeq, roiNum)

Intensity = zeros(roiNum, 1);
for j = 1:roiNum
    temp = roiSeq{j};
    Intensity(j) = mean( temp(:) );
end