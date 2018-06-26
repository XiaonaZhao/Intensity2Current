function imgSeqSubtract1stF = BgdRemoval(imgSeq, imgNum)

for j = 1:imgNum 
imgSeqSubtract1stF = imsubtract(imgSeq.read(1), imgSeq.read(j)); 
end 