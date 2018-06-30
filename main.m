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


% -- Read the alive .tiff files

[imgSeq, imgNum] = ReadTifFiles; % uint16 cell


% -- Remove the no-electro background

[BgSeq, BgNum] = ReadTifFiles;% uint16 cell
imgSubtractBg = BgdRemoval(imgSeq,...
    imgNum,BgSeq, BgNum);
clear imgSeq BgSeq BgNum


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
BW = roipoly(imgSubtractBg{1}, col, row);
nonzeroBW  = length(find(BW(:)~=0));
BW = BW*1;
% "*1" turns logical into double, then "uint16" turn double into uint16.

% RectBounds = sROI.vnRectBounds;
% Return current position of ROI object, [xmin ymin width height]
% position = [RectBounds(1), RectBounds(2),...
%     (RectBounds(3)-RectBounds(1)),...
%     (RectBounds(4)-RectBounds(2))];
% set more variable to monitor the matrix changes
imgSegment = cell(imgNum,1); 
for j = 1:imgNum
    imgSegment{j} = imgSubtractBg{j}.*BW; % double cell
end
clear cstrFilenames cstrPathname sROI Polygon
clear col row BW j imgSubtractBg


% -- Average each dROI

Intensity = averROI(imgSegment, imgNum, nonzeroBW);
clear imgSegment nonzeroBW


% -- Laplace and iLaplace dROI for Current info

Current = intensity2current(Intensity, imgNum);
clear Intensity imgNum


% -- plot Current

Voltage  = calculateVolt(Current);% calaulate the X axis - Voltage

figure
plot(Voltage, Current);
title('Graph of current calculated by SPR intensity');% plot title
xlabel('Voltage/V') % x-axis label
ylabel('Current/A') % y-axis label