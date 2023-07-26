function data = customreader(filename)
% filename
I = imread(filename);

[a,b,c] = size(I);

% if the image is a greyscale convert it RGB
if c==1,
%     I0 = imread('0.jpg');
%     [indimg, indmap] = rgb2ind(I0,128);
%     indasgray = rgb2gray(reshape(indmap,[size(indmap,1),1,3]));
% %     image(indimg);
% %     colromap(indasgray);   %image painted gray but multiple ind might have same gray
%     I = round(ind2rgb(indimg, indmap)*254);   %not indasgray

    I = grs2rgb(I);
end

% use this section to add noise only to image samples with wrong labels
%global images
%global idx
%i = find( strcmp(images.Files,filename) );
%if ismember( i, idx)
%    Ig = rgb2gray(imnoise(I, 'gaussian', 0, 0.01));
%    I = cat(3, Ig, Ig, Ig);
%end
% >> end of section

% use this section to add nois to all samples in the dataset
% Ig = rgb2gray(imnoise(I, 'gaussian', 0, 0.01));
% I = cat(3, Ig, Ig, Ig);
% >> end of section

data = imresize(I,[227 227]);
% whos data
