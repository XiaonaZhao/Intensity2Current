% main function
clc
clear

% I still find it difficult to use the imageJ-roi in matlab especially the
% reactangle. Firstly, the rectangle's decoded-structure is different from
% the other types'. Then, the inner coordinates in the imageJ-roi seem not
% cooperating with the coordinates of pixels showed in imageJ. Finally, I don't
% know how to decode the Jave code of imageJ and still known little on
% matlab.
% Author: nonazhao@mail.ustc.edu.cn;
% Created: 29 June 2018


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
Polygon = sROI.mnCoordinates;
col = Polygon(:,2);
row = Polygon(:,1);
BW = uint16((roipoly(imgSeq{1},col,row))*1); 
% "*1" turns logical into double, then "uint16" turn double into uint16.

% RectBounds = sROI.vnRectBounds;
% Return current position of ROI object, [xmin ymin width height]
% position = [RectBounds(1), RectBounds(2),...
%     (RectBounds(3)-RectBounds(1)),...
%     (RectBounds(4)-RectBounds(2))];
% set more variable to monitor the matrix changes
imgSegment = cell(imgNum,1); 
for j = 1:imgNum
    imgSegment{j} = imgSeq{j}.*BW;
end
clear cstrFilenames cstrPathname sROI Polygon
clear col row BW j imgSeq


% -- Background removal

imgSeqSubtract1stF = BgdRemoval(imgSegment, imgNum);
clear imgSegment


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