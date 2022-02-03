close('all')
clear;

%% load image

img_id = "parab";
ext = ".tiff";

img1 = imread("images/tiff/"+img_id+'1'+ext);
img1 = rgb2gray(img1(:,:,1:3));

% img1_b = imbinarize(img1);
% figure()
% subplot(121)
% imshow(img1)
% subplot(122)
% imshow(img1_b)

% in case the image matrix isn't square
% img1=img1(1:500,1:500);
% img1=img1(1:500,1:500);

l = length(img1);

%% add noise + denoise

mean = 0; % noise mean
var1 = 0.3  ; % noise variance
var2 = 0.5
img1n1 = imnoise(img1,'gaussian',mean,var1/255);
img1n2 = imnoise(img1,'gaussian',mean,var2/255);

figure()
subplot(131)
imshow(img1)
title('img1')
ylabel('y [px]')
xlabel('x [px]')
subplot(132)
imshow(img1n1)
title('img1+N('+string(mean)+';'+string(var1)+')')
xlabel('x [px]')
subplot(133)
imshow(img1n2)
title('img1+N('+string(mean)+';'+string(var2)+')')
xlabel('x [px]')
set(findall(gcf,'-property','FontSize'),'FontSize',20)

figure()
subplot(131)
imshow(img1(1:50,1:50))
title('img1')
ylabel('y [px]')
xlabel('x [px]')
subplot(132)
imshow(img1n1(1:50,1:50))
title('img1+N('+string(mean)+';'+string(var1)+')')
xlabel('x [px]')
subplot(133)
imshow(img1n2(1:50,1:50))
title('img1+N('+string(mean)+';'+string(var2)+')')
xlabel('x [px]')
set(findall(gcf,'-property','FontSize'),'FontSize',50)

%set(findall(gcf,'-property','FontSize'),'FontSize',50)

% img1den = wdenoise2(img1n,level,'Wavelet',wfilter,'DenoisingMethod',dm);
% img1den = uint8(img1den);
% img2den = wdenoise2(img2n,level,'Wavelet',wfilter);
% img2den = uint8(img2den);










