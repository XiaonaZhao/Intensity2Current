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


%% -- Read the alive .tiff files

prompt = 'Increment of frames:\n ';
skipNum = input(prompt);
[imgSeq, imgNum] = ReadTifFiles(...
    'Open sampling image sequence', skipNum); % uint16 cell


% -- Remove the no-electro background

[BgSeq, BgNum] = ReadTifFiles('Open background sequence'); % uint16 cell
imgSubtractBg = BgdRemoval(imgSeq, imgNum, BgSeq, BgNum);
clear imgSeq BgSeq BgNum


%% -- Select ROIs

[cstrFilenames, cstrPathname] = uigetfile(...
    {'*.roi',  'ROI (*.roi)';...
    '*.zip',  'Zip-files (*.zip)';...
    '*.*',  'All Files (*.*)',...
    },'Pick a .roi imageJ file');
[sROI] = ReadImageJROI(fullfile(cstrPathname, cstrFilenames));
switch sROI.strType
    case 'Rectangle'
        RectBounds = sROI.vnRectBounds;
        % [x-left_up y-left_up x-right_down y-right_down]
        col = [RectBounds(2), RectBounds(4)];
        row = [RectBounds(1), RectBounds(3)];
    case 'Polygon'
        Polygon = sROI.mnCoordinates;
        col = Polygon(:,2);
        row = Polygon(:,1);
end
BW = roipoly(imgSubtractBg{1}, col, row);
nonzeroBW  = length(find(BW(:)~=0));
BW = BW*1;
% "*1" turns logical into double, then "uint16" turn double into uint16.
% set more variable to monitor the matrix changes
imgSegment = cell(imgNum,1); 
for j = 1:imgNum
    imgSegment{j} = imgSubtractBg{j}.*BW; % double cell
end
clear cstrFilenames cstrPathname sROI
clear col row BW j imgSubtractBg


%% -- Average each dROI

Intensity = averROI(imgSegment, imgNum, nonzeroBW);
clear imgSegment nonzeroBW


%% -- Laplace and iLaplace dROI for Current info

Current = intensity2current(Intensity, imgNum);
% clear Intensity imgNum


%% -- plot Current

Voltage  = calculateVolt(Current); % calaulate the X axis - Voltage

figure
plot(Voltage, Current);
title('Graph of current calculated by SPR intensity'); % plot title
xlabel('Voltage/V') % x-axis label
ylabel('Current/A') % y-axis label