clc
clear
tifFiles = uigetfile('*.tif', 'Multiselect', 'on'); % achieve destination folder
if isequal(tifFiles, 0)
   disp('User selected Cancel')
   return;
end
img = cell(1,length(tifFiles)); % read all tiff files
% allnames = struct2cell(dir('*.tiff'));
img{1}=imread(tifFiles(1));
