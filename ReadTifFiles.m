function [tifSeq, tifNum] = ReadTifFiles
[tifFiles, tifPath] = uigetfile('*.tiff', 'Multiselect', 'on'); 
if isequal(tifFiles, 0)
   disp('User selected Cancel')
   return;
end
tifFiles = cellstr(tifFiles);  % Care for the correct type 
tifNum = length(tifFiles);
tifSeq = cell(tifNum,1); % Line Data structure, imgSeq is column vector
for j = 1:tifNum
    tifSeq{j} = imread(fullfile(tifPath, tifFiles{j})); % read all tiff files
end
clear j
end