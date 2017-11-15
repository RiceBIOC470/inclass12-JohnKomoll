%Inclass 12. 
%GB comments
1) 100
2) 100
3) 100
4) 100
Overall 100

% Continue with the set of images you used for inclass 11, the same time 
% point (t = 30)

filename = '011917-wntDose-esi017-RI_f0016.tif';
reader = bfGetReader(filename);
time = 30;
zslice = 1;

% 1. Use the channel that marks the cell nuclei. Produce an appropriately
% smoothed image with the background subtracted. 

% Read in correct channel and show first image
chan = 2;
iplane = reader.getIndex(zslice - 1, chan - 1, time - 1)+1;
img_nuc = bfGetPlane(reader, iplane);
imshow(imadjust(img_nuc))

% Smooth with Gaussing filter
rad = 7;
sigma = 2;
fgauss = fspecial('gaussian', rad, sigma);
img_nuc_smooth = imfilter(img_nuc, fgauss);

% Subtract background
img_nuc_signal = imopen(img_nuc_smooth, strel('disk', 4));
figure
imshow(img_nuc_signal,[])

% 2. threshold this image to get a mask that marks the cell nuclei. 

% Generate a mask and apply to image
threshold = 585;
img_nuc_mask = img_nuc_signal > threshold;
figure
imshow(img_nuc_mask)

% 3. Use any morphological operations you like to improve this mask (i.e.
% no holes in nuclei, no tiny fragments etc.)

% Perform dilation, then erosion, to get rid of small holes
img_close = imclose(img_nuc_mask, strel('disk', 6));

% Perform erosion, then dilation, to get rid of small spots
img_open = imopen(img_close, strel('disk', 6));
figure
imshow(img_open)

% 4. Use the mask together with the images to find the mean intensity for
% each cell nucleus in each of the two channels. Make a plot where each data point 
% represents one nucleus and these two values are plotted against each other

% Get image of membrane channel
chan = 1;
iplane = reader.getIndex(zslice - 1, chan - 1, time - 1)+1;
img_membrane = bfGetPlane(reader, iplane);

% Get properties of nuclei based on final mask generated, for each channel
cell_properties_nuc = regionprops(img_open, img_nuc, 'MeanIntensity');
cell_properties_mem = regionprops(img_open, img_membrane, 'MeanIntensity');

% Plot mean intensities for each nucleus against each other with respect to
% channel
intensities_c1 = [cell_properties_mem.MeanIntensity];
intensities_c2 = [cell_properties_nuc.MeanIntensity];
figure
plot(intensities_c1, intensities_c2, '.r', 'MarkerSize', 18)
xlabel('Channel 1', 'FontSize', 28);
ylabel('Channel 2', 'FontSize', 28);
