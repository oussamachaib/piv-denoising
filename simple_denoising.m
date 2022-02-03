close('all')
clear
clc


I = imread('images/toureiffel.jpg');

I = rgb2gray(I);

In = imnoise(I,'gaussian');%,0,5/255);

Id = uint8(wdenoise2(In,9,'Wavelet','db4','DenoisingMethod','Bayes'));


fig=figure()

subplot(131)
imshow(I)

subplot(132)
imshow(In)

subplot(133)
imshow(Id)

fig.Position = [150 250 1500 500];