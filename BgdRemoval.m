function imgSeqSubtract1stF = BgdRemoval(imgSeq, imgNum)

for j = 1:imgNum 
imgSeqSubtract1stF = imsubtract(imgSeq{1}, imgSeq{j}); 
end 