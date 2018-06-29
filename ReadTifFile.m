clc
clear
% main function


% -- Read .tiff files

[tifFiles, tifPath] = uigetfile('*.tiff', 'Multiselect', 'on'); 
if isequal(tifFiles, 0)
   disp('User selected Cancel')
   return;
end
tifFiles = cellstr(tifFiles);  % Care for the correct type 
imgNum = length(tifFiles);
imgSeq = cell(imgNum,1); % Line Data structure, imgSeq is column vector
for j = 1:imgNum
    imgSeq{j} = imread(fullfile(tifPath, tifFiles{j})); % read all tiff files
end
clear tifFiles tifPath j


% -- Select ROIs

[cstrFilenames, cstrPathname] = uigetfile(...
    {'*.roi',  'ROI (*.roi)';...
    '*.zip',  'Zip-files (*.zip)';...
    '*.*',  'All Files (*.*)',...
    },'Pick a file');
[sROI] = ReadImageJROI(fullfile(cstrPathname, cstrFilenames));
RectBounds = sROI.vnRectBounds;
% Return current position of ROI object, [xmin ymin width height]
position = [RectBounds(1), RectBounds(2),...
    (RectBounds(3)-RectBounds(1)),...
    (RectBounds(4)-RectBounds(2))];
for j = 1:imgNum
    imgSeq{j} = imcrop(imgSeq{j}, position);
end
clear cstrFilenames cstrPathname sROI RectBounds postion j


% -- Background removal

imgSeqSubtract1stF = BgdRemoval(imgSeq, imgNum);
clear imgSeq


% -- Average each dROI

Intensity = averROI(imgSeqSubtract1stF, imgNum);
clear imgSeqSubtract1stF


% -- Laplace and iLaplace dROI for Current info

Current = intensity2current(Intensity, imgNum);
clear intensity


% -- plot Current

% calaulate the X axis
Dots = length(Current);
Voltage1 = 0;
Voltage2 = -0.5;
Voltage = (linspace(Voltage1, Voltage2, Dots))'; % linspace is row vector

figure
plot(Current, Voltage);
title('Graph of current calculated by SPR intensity');% plot title
xlabel('Voltage/V') % x-axis label
ylabel('Current/A') % y-axis label