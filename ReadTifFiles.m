function [tifSeq, tifNum] = ReadTifFiles(TopName, skipNum)
[tifFiles, tifPath] = uigetfile('*.tiff', 'Multiselect', 'on', TopName); 
if isequal(tifFiles, 0)
   disp('User selected Cancel')
   return;
end
tifFiles = cellstr(tifFiles);  % Care for the correct type 
tifNum = floor((length(tifFiles))/(skipNum+1)) + 1;
tifSeq = cell(tifNum,1); % Line Data structure, imgSeq is column vector
for jj = 1:tifNum
    tifSeq{jj} = imread(fullfile(tifPath, tifFiles{jj})); % read all tiff files
end
clear jj
end