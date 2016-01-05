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

%% Get training and testing parts
test = double(deck(:,:,1:10:end));  
train=double(deck); train(:,:,1:10:end) = []; 
image_subfigure(test);
% compute average face
[y,x,M] = size(train); 
N = x*y; 
vector_face = zeros(N,M);
c = zeros(N,1);
for i=1:M
    a = train(:,:,i);
    vector_face(:,i) = a(:);  % vector_face (vector rn ). (N*360 matrix) 360 images of N = width*height elements in column
    c = c + a(:); % c is single matrix has N = x*y elements in column = sum of 360 images. This is used for showing
end
average_vector_face = c/M;      % average of vector_face Nx1 elements in 1 column
c = reshape(average_vector_face,y,x); % reshape back to image size
figure; imagesc(c);colormap(gray(256));title('average face');axis image;
        set(gca, 'XTick', [], 'YTick', []);

%% Difference between each rn vector face to averave vector face
A = zeros(N,M);
for i = 1:M
    A(:,i) =  vector_face(:,i) - average_vector_face; % (N*360 matrix)
end
% covariance matrix - MxM dimension
L = A'*A;
figure; imagesc(L); title('covariance');colormap(gray(256));axis image;

%% Find Eigen vector in MxM dimension
[Eigen_vector, Eigen_value] = eig(L); % C*Eigen_vector = Eigen_vector*Eigen_value;
V = A*Eigen_vector; % N*M matrix Avi in paper
% eigen faces
eigenface = [];
eigen = [];
for i = 1:M
    b = V(:,i);
    eigenface{i} = reshape(b,y,x); % eigenface is y*x*M matrix
end
m=diag(Eigen_value);
[ma,mb] = sort(m,'descend');
% Set of 20 highest eignvalue
for i = 1:20
    eigen{i} = eigenface{mb(i)}; % eigenface_descend is y*x*20 matrix
    a(:,:,i) = eigen{i};
    eigenface_vector(:,i) = eigen{i}(:);
end
image_subfigure(a); % Display 20 highest priority eigenfaces

%% Calculate the weights

n = 20;% select  eigen faces
for i = 1:M  % image number
    for k = 1:n 
        weight(k,i) = dot(A(:,i),eigenface_vector(:,k)); %% weight is M*20 matrix
    end
end

%% 20 element vector of testing images
test_face= test(:,:,1);
[~,~,m] = size(test); 
%imagesc(test_face);colormap(gray(256));
for i = 1:m
    test_face= test(:,:,i);
    face_A = test_face(:)-average_vector_face; % normilized face
    for k=1:n
        wface(k,i)  =  dot(face_A,eigenface_vector(:,k)); %20*40 matrix, contribute of 20 eigenface on 
                                                          %each face in 40 testing faces  
    end
end

%% find distance
distance = distance_mx(wface, weight); % 40*360 

%% test 40 faces
for i = 1:m
    face_test = test(:,:,i);
    [mi,idx] = min(distance(i,:));
    face_detected = train(:,:,idx);
    face(:,:,i) = [face_test face_detected];
end
image_subfigure(face);



