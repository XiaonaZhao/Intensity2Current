clc
clear


% -- Read .tiff files

tifFiles = uigetfile('*.tif', 'Multiselect', 'on'); 
if isequal(tifFiles, 0)
   disp('User selected Cancel')
   return;
end
tifFiles = cellstr(tifFiles);  % Care for the correct type 
imgNum = length(tifFiles);
imgSeq = cell(imgNum,1); % Line Data structure
for j = 1:imgNum
    imgSeq{j} = imread(tifFiles{j}); % read all tiff files
end
% % - 3D data structure from QC
% img = cell(imgNum,3); 
% % allnames = struct2cell(dir('*.tiff'));
% for j = 1:imgNum
%     img{j,:,:} = j;
% end
% for j = 1:imgNum
%     img{:,:,j} = imread(tifFiles{j}); % read all tiff files
% end


% -- Select ROIs

cstrFilenames = uigetfile(...
    {'*.roi',  'ROI (*.roi)';...
    '*.zip',  'Zip-files (*.zip)';...
    '*.*',  'All Files (*.*)',...
    },'Pick a file');
[sROI] = ReadImageJROI(cstrFilenames);


% -- Background removal

imgSeqSubtract1stF = BgdRemoval(imgSeq, imgNum);


% -- Average each dROI

Intensity = averROI(imgSeqSubtract1stF, imgNum);


% -- Laplace and iLaplace dROI for Current info
Current = intensity2current(intensity);


% -- plot Current