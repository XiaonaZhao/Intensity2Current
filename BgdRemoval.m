function imgSeqSubtract1stF = BgdRemoval(imgSeq, imgNum)

imgSeqSubtract1stF = cell(imgNum,1);
for j = 1:imgNum 
imgSeqSubtract1stF{j} = imgSeq{j} - imgSeq{1}; 
end 
clear j