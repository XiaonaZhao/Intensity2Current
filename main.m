% main function for Intensity2Current
clc
clear

% ATTENTION:

% There is still two problems in this programme. one is that the CURRENT
% calculated by the iLaplace doesn't match with the result from the
% electrochemical workstation. The other is that the present background
% cutting doesn't correct the bias from the charge and discharge of gold
% plate.

% Author: nonazhao@mail.ustc.edu.cn;
% Created: 29 June 2018

% -- Important modification: 22 Nov 2018 --
% added submain.m, fft_P1.m, lowp.m and several plot lines

% -- Attention: 6 Nov 2025 --
% add .nd2 convertor
% multi files: .tif, .tiff, .raw, .nd2

%% -- Read the alive .nd2 files


%% preinstall a big struct matrix for all experiments on one subtrate
% expTab: excel for matlab
exp = cell(3, 7); % row: num of experiments; col: elements of exps
fields = {'expName', 'tifPath', 'fps', 'start_potential', 'end_potential', 'scanrate', 'saveRoute'}; % the col number of exp
expTab = cell2struct(exp, fields, 2);
clear exp fields

%% fill the struct matrix with your file info

for ii = 1:size(expTab, 1) % theoretically, 
    prompt = {...
        'Reference number of Data in Exp group:',... % 1,
        'Enter the fps of the experiment:',... % 2,
        'Enter the start potential of the electrostation:',... % 3,
        'Enter the end potential of the electrostation:',... % 4,
        'Enter the scan rate of the electrostation:',... % 5,
        'SaveRoute of processed data:'...; % 6,
        };

    dlg_title = 'Please confirm the info of the image sequence';
    num_lines = 1;

    defaultans = {...
        'A1',...
        '20',... % 20.0 fps; 50.0 ms
        '0.2',...
        '-0.8',... 
        '-0.02',...
        'I:\Electrochemistry\WS2_20251106_WSY\_Result'... % 存处理完的数据的文件夹
        };

    answer = inputdlg(prompt, dlg_title, num_lines, defaultans);
    expTab(ii).expName = answer{1}; % No. of exps
    expTab(ii).fps = str2double(answer{2}); % frames per second
    expTab(ii).start_potential = str2double(answer{3});
    expTab(ii).end_potential = str2double(answer{4});
    expTab(ii).scanrate = str2double(answer{5});
    expTab(ii).saveRoute = answer{6}; % save your result

    expTab(ii).tifPath = uigetdir('*.*', 'Select the image sequence folder');

    disp(['The last is ' expTab(ii).expName]);
end

%% TimeLine - begin.frame, need clicking
prefix = ('I:\Electrochemistry\WS2_20251106_WSY\');
d = sortObj(dir([prefix, '*.mat']));
for ii = 1:size(expTab, 1)
    varMat = load([prefix, d(ii).name]);
    fps = expTab(ii).fps;

    begin = triggerTime(varMat.data, varMat.t, fps);  % === pike or hmmt ====
    expTab(ii).begin = begin;

    disp([prefix, d(ii).name]);
end
close all
%% save your structure matrix to result file
cellpath = [expTab(ii).saveRoute '\matlab.mat'];
save(cellpath, 'expTab', '-v7.3');

%% 读取当前所需试验的时序数据 - 读取加电范围内全部帧
ii = 3; % 试验编号
tifPath = expTab(ii).tifPath;
fps = expTab(ii).fps;
begin = expTab(ii).begin;
tifDir = [dir(fullfile(tifPath, '*.tiff'));...
    dir(fullfile(tifPath, '*.tif'));...
    dir(fullfile(tifPath, '*.BMP'))];

start_potential = expTab(ii).start_potential; % V vs Ag/AgCl (3M KCl)
end_potential = expTab(ii).end_potential;
scanrate = expTab(ii).scanrate;
L = abs((end_potential - start_potential)/scanrate*fps) + 1;

validDir = tifDir(begin.frame : begin.frame + L - 1, 1); % LSV 
tif0 = double(imread(fullfile(tifPath, validDir(1).name)));
% tif0 = tif0(row(1):row(2), col(1):col(2)); % 如果有ROI

tif = cell(size(validDir, 1), 1);
for kk = 1:size(validDir, 1)
    temp = double(imread(fullfile(tifPath, validDir(kk).name)));
    tif{kk, 1} = temp -tif0;
    % tif{ii, 1} = temp(row(1):row(2), col(1):col(2)) - tif0;
end


%% 3D Mapping - 强度转电流密度
exp_3D = zeros(size(tif0, 1), size(tif0, 2), L);
parfor kk = 1:L
    exp_3D(:, :, kk) = tif{kk, 1};
end


Current_3D = zeros(size(tif0, 1), size(tif0, 2), L-1);
for kk = 1:size(tif0, 1)
    parfor jj = 1:size(tif0, 2)
        Intensity = reshape(exp_3D(kk, jj, :), L, 1);
        Current_3D(kk, jj, :) = intensity2current(Intensity, L, fps);
        % 本行应存在滤波
    end
end
clear exp_3D

Current = cell(L-1, 1);
parfor kk = 1:(L-1)
    Current{kk, 1} = -reshape(Current_3D(:, :, kk), [size(tif0, 1), size(tif0, 2)]);
    % 本行为滤波的三维还原
end

%% 电流密度观察
% figure('color', 'w');
Frame = 900;
I = Current{Frame, 1};
I = imboxfilt(I, 5);
imshow(I, 'DisplayRange', [], 'InitialMagnification', 'fit');
colormap fire
h = colorbar;
set(get(h,'title'),'string','\itj \rm(mA cm^-^2)');
set(h, 'FontSize', 9);
% set(gca, 'CLim', [1 5]); %
set(gca, 'FontName', 'Arial', 'FontSize', 16, 'Color', 'none', 'AmbientLightColor', 'none');


%% 上一个section中成像电流密度所处的电势

Voltage = start_potential + (expTab(ii).begin.frame + Frame - 1)/fps*scanrate;

%% tafel_slope
