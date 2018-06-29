function imgSubtractBg = BgdRemoval(imgSeq, imgNum,BgSeq, BgNum)

sum = zeros(480, 640);
for j = 1:BgNum
    temp = double(BgSeq{j});
    sum = temp + sum;
end
averBg = sum./(double(BgNum));
clear temp j

imgSubtractBg = cell(imgNum,1);
for j = 1:imgNum
    temp = double(imgSeq{j});
    imgSubtractBg{j} = temp - averBg; 
end
clear temp j
end