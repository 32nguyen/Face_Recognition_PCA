function image_subfigure( in, titles )
%
% image_subfigure( in, titles )
%
% in        3d array, containing multiple images 
% titles    Cell array of titles, one for each image (optional)
% 
% Author: Dr. Russell Hardie
% University of Dayton
% 1/10/07


% get size info
[sy,sx,sz]=size(in);
ncols=round(sqrt(sz));
nrows=ceil(sz/ncols);

% If not titles provided, make it an empty array
if nargin < 2
    titles = cell(sz);
end

% Create new figure
figure
for k=1:sz

    % Display current image in a subplot
    subplot(ncols,nrows,k)
    im( in(:,:,k),0 );
    set(gca, 'XTick', [], 'YTick', []);
    % Title the image
    title( titles{k} )
end

