close('all')
clear
clc


I = imread('images/tiff/parab1.tiff');
J = imread('images/tiff/parab2.tiff');

I = rgb2gray(I(:,:,1:3));
J = rgb2gray(J(:,:,1:3));

rng(2)

mu = 0;
var = .1;

seed=rng(3);
In = gaussian_noise(I,0,var);
Jn = gaussian_noise(J,0,var);

wfilter = 'bior3.3';
lvl = 3;
method= 'Bayes';
tr= 'median';
Id = uint8(wdenoise2(In,lvl,'Wavelet',wfilter,'DenoisingMethod',method,'ThresholdRule',tr));
Jd = uint8(wdenoise2(Jn,lvl,'Wavelet',wfilter,'DenoisingMethod',method,'ThresholdRule',tr));

% correlation window and position
w = 32;
a = 200;
b = a+w-1;

noise = In(a:b,a:b)-I(a:b,a:b);

fig=figure();

subplot(141)
imshow(I(a:b,a:b))
title('original')

subplot(142)
imshow(In(a:b,a:b))
title('noisy')

subplot(143)
imshow(Id(a:b,a:b))
title('denoised')

subplot(144)
imshow(noise)
title('noise')

fig.Position = [150 250 1500 500];

[X,Y] = meshgrid(-(w-1):w-1,-(w-1):w-1);
crosscorr1 = normxcorr2(I(a:b,a:b),J(a:b,a:b));
%va=60;
%vb=15;
va=90;
vb=0;
fig1=figure();

% crosscorr original
subplot(131)
hold on;
surf(X,Y,crosscorr1)
title('normxcorr2[I(a,b) , J(a,b)]')
xlabel('x [px]')
ylabel('y [px]')
zlabel('normxcorr [-]')
[ymax, xmax] = find(crosscorr1==max(max(crosscorr1))); % notice how the order is inverted
plot3(xmax-w, ymax-w, max(max(crosscorr1)),'ro', 'MarkerSize', 20);
text(xmax-w-w/4, ymax-w+w/4, max(max(crosscorr1)),'('+string(xmax-w)+', '+string(ymax-w)+')','Color','r','FontSize',14)
set(gca,'FontSize',20)
view(va,vb)
shading flat
hold off;

crosscorr2 = normxcorr2(In(a:b,a:b),Jn(a:b,a:b));

% crosscorr noisy
subplot(132)
hold on;
surf(X,Y,crosscorr2)
title('normxcorr2[In(a,b) , Jn(a,b)]')
xlabel('x [px]')
ylabel('y [px]')
zlabel('normxcorr [-]')
[ymax, xmax] = find(crosscorr2==max(max(crosscorr2)));
plot3(xmax-w, ymax-w, max(max(crosscorr2)),'ro', 'MarkerSize', 20);
text(xmax-w-w/4, ymax-w+w/4, max(max(crosscorr2)),'('+string(xmax-w)+', '+string(ymax-w)+')','Color','r','FontSize',14)
set(gca,'FontSize',20)
shading flat
view(va,vb)
hold off;

crosscorr3 = normxcorr2(Id(a:b,a:b),Jd(a:b,a:b));
crosscorr3 = detrend(detrend(crosscorr3));
% crosscorr denoised
subplot(133)
hold on;
surf(X,Y,crosscorr3)
title('normxcorr2[Id(a,b) , Jd(a,b)]')
xlabel('x [px]')
ylabel('y [px]')
zlabel('normxcorr [-]')
[ymax, xmax] = find(crosscorr3==max(max(crosscorr3)));
plot3(xmax-w, ymax-w, max(max(crosscorr3)),'ro', 'MarkerSize', 20);
text(xmax-w-w/4, ymax-w+w/4, max(max(crosscorr3)),'('+string(xmax-w)+', '+string(ymax-w)+')','Color','r','FontSize',14)
set(gca,'FontSize',20)
view(va,vb)
shading flat
hold off;

fig1.Position = [150 250 1500 500];

% saveas(gcf,'figures/denoising/crosscorr_mean0_var3_a200_w32.jpg')







