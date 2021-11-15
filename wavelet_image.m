close('all');
clear;

%% loading image

img_id = "rankine1";
ext = ".tiff";
img = imread("images/tiff/"+img_id+ext);
img = rgb2gray(img(:,:,1:3));

figure();
subplot(131)
imshow(img(1:50,1:50));
title('img(1:50,1:50)')
xlabel('x [px]')
ylabel('y [px]')
hold on;

%% adding noise

mean = 0;
var = 0.01;
imgn = imnoise(img, 'gaussian',mean,var);
subplot(132)
imshow(imgn(1:50,1:50))
xlabel('x [px]')
ylabel('y [px]')
title("img(1:50,1:50) + noise")

%% denoising

img_den = wdenoise2(imgn,1,'Wavelet','db3');
img_den = uint8(img_den);
subplot(133);
imshow(img_den(1:50,1:50));
xlabel('x [px]');
ylabel('y [px]');
title("imgn(1:50,1:50) denoised");




