%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read photos
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear all; close all;
% Specify path for directory containing sub_directories of all images
path = 'D:\Study_CUA\GitHub\Face_Recognition_PCA\Face_Recognition_PCA\ORL\';

% Get images sub_directories
dirs = dir( path );
dirs = dirs( 3 : end ); % remove the '.' and '..' dirs
num_dirs = length( dirs );
count = 1;  %initialize storage counter

for dir_idx = 1 : num_dirs    
    %Get images file name in the specified sub_directories
    dirs_s = dir( [ path , dirs(dir_idx).name] );
    dirs_s = dirs_s( 3 :  end ); % remove the '.' and '..' dirs    
    % Get number of images per directory per iteration ... (loop)
    num_images = length( dirs_s );    
    for image_idx = 1 : num_images        
        %storing all images into a 3D array called 'deck'
        deck(:,:,count) = imread( [ path, dirs(dir_idx).name, '\', dirs_s(image_idx).name] );
        count = count + 1; %update counter
    end    
end





