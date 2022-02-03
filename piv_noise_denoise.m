close('all')
clear;

%% load image

img_id = "parab";
ext = ".tiff";

if ext==".tiff"
    img1 = imread("images/tiff/"+img_id+'1'+ext);
    img1 = rgb2gray(img1(:,:,1:3));

    img2 = imread("images/tiff/"+img_id+'2'+ext);
    img2 = rgb2gray(img2(:,:,1:3));
else
    img1 = imread("images/tiff/"+img_id+'1'+ext);
    img2 = imread("images/tiff/"+img_id+'2'+ext);
end

% in case the image matrix isn't square
% img1=img1(1:500,1:500);
% img1=img1(1:500,1:500);


l = length(img1);

%% add noise + denoise

wfilter='bior1.1';
level = 2;
dm = 'Bayes'; % 'Bayes' by def


mu = 0; % noise mu
var = 2 ; % noise variance
rng(1)

img1n = imnoise(img1, 'gaussian',mu,var/255);
img2n = imnoise(img2, 'gaussian',mu,var/255);


% just don't...
% % test binarizing 
% img1den = imbinarize(img1n);
% img2den = imbinarize(img2n);
% 
% img1den = uint8(img1den*255);
% img2den = uint8(img1den*255);

img1den = wdenoise2(img1n,level,'Wavelet',wfilter,'DenoisingMethod',dm);
img1den = uint8(img1den); 
img2den = wdenoise2(img2n,level,'Wavelet',wfilter); 
img2den = uint8(img2den);

% net = denoisingNetwork('DnCNN');
% img1den1 = denoiseImage(img1n,net);
% img2den1 = denoiseImage(img2n,net);

% figure();
% subplot(131)
% imshow(img1(:,:));
% title('img1(1:50,1:50)')
% xlabel('x [px]')
% ylabel('y [px]')
% subplot(132)
% imshow(img1den(:,:));
% title('DWT')
% xlabel('x [px]')
% ylabel('y [px]')
% subplot(133);
% imshow(img1den1(:,:));
% xlabel('x [px]');
% ylabel('y [px]');
% title("NN");

fig0=figure();
subplot(131)
imshow(img1(1:100,1:100));
title('img1(1:100,1:100)')
xlabel('x [px]')
ylabel('y [px]')


subplot(132)
imshow(img1n(1:100,1:100));
title('img1n(1:100,1:100)')
xlabel('x [px]')
ylabel('y [px]')

subplot(133);
imshow(img1den(1:100,1:100));
xlabel('x [px]');
ylabel('y [px]');
title("img1n(1:100,1:100) denoised");


fig0.Position = [2000 2000 1500 500];%800 400];

% imwrite(img1n,'images/noise/'+img_id+'1n.tiff','tiff')
% imwrite(img2n,'images/noise/'+img_id+'2n.tiff','tiff')
% 
% imwrite(img1den,'images/noise/'+img_id+'1den.tiff','tiff')
% imwrite(img2den,'images/noise/'+img_id+'2den.tiff','tiff')

%% cross-correlation without noise

window = 32;
dt=1;
cnta=0;

vx = zeros(floor(l/window),floor(l/window));
vy = zeros(floor(l/window),floor(l/window));

for a=1:window:l
    cnta=cnta+1;
    cntb=1;
    for b=1:window:l
        corr = xcorr2(img1(a:a+window-1,b:b+window-1),img2(a:a+window-1,b:b+window-1));
        [dy, dx] = find(corr==max(max(corr)),1,'first');
        dx = dx - window;
        dy = dy - window;
        vx(cnta,cntb) = -dx/dt;
        vy(cnta,cntb) = -dy/dt;
        cntb = cntb+1;
    end
end

u = vx;
v = vy;

x=linspace(0,512,length(vx));
y=linspace(0,512,length(vx));

xv=window/2:window:l;
yv=window/2:window:l;

U = sqrt(vx.^2+vy.^2);
Uhat = U;%./max(U);

fig=figure();

fig.Position = [150 250 1500 500];

subplot(131)
[C,h] = contourf(x,y,Uhat,100);
hold on;
title('Velocity field - '+img_id);
set(h,'LineColor','none')
colormap(parula);
colorbar();
xlim([0,512])
ylim([0,512])
quiver(xv,yv,vx,vy,'k')
set(gca,'FontName','TimesNewRoman','FontSize',12);
set(gca, 'YDir','reverse')
xlabel('x [px]')
ylabel('y [px]')
hold off;

%% cross-correlation with noise

cnta=0;

vx = zeros(floor(l/window),floor(l/window));
vy = zeros(floor(l/window),floor(l/window));

for a=1:window:l
    cnta=cnta+1;
    cntb=1;
    for b=1:window:l
        corr = xcorr2(img1n(a:a+window-1,b:b+window-1),img2n(a:a+window-1,b:b+window-1));
        [dy, dx] = find(corr==max(max(corr)),1,'first');
        dx = dx - window;
        dy = dy - window;
        vx(cnta,cntb) = -dx/dt;
        vy(cnta,cntb) = -dy/dt;
        cntb = cntb+1;
    end
end

un = vx;
vn = vy;

Un = sqrt(vx.^2+vy.^2);
Uhat = Un;%./max(Un);

subplot(132)
[C,h] = contourf(x,y,Uhat,100);
hold on;
title('Velocity field - '+img_id+' + noise');
set(h,'LineColor','none')
colormap(parula);
colorbar();
xlim([0,512])
ylim([0,512])
quiver(xv,yv,vx,vy,'k')
set(gca,'FontName','TimesNewRoman','FontSize',12);
set(gca, 'YDir','reverse')
xlabel('x [px]')
ylabel('y [px]')
hold off;

%% cross-correlation on denoised image
cnta=0;

vx = zeros(floor(l/window),floor(l/window));
vy = zeros(floor(l/window),floor(l/window));

for a=1:window:l
    cnta=cnta+1;
    cntb=1;
    for b=1:window:l
        corr = xcorr2(img1den(a:a+window-1,b:b+window-1),img2den(a:a+window-1,b:b+window-1));
        [dy, dx] = find(corr==max(max(corr)),1,'first');
        dx = dx - window;
        dy = dy - window;
        vx(cnta,cntb) = -dx/dt;
        vy(cnta,cntb) = -dy/dt;
        cntb = cntb+1;
    end
end

uden = vx;
vden = vy;

Uden = sqrt(vx.^2+vy.^2);
Uhat = Uden;%./max(Uden);

subplot(133)
[C,h] = contourf(x,y,Uhat,100);
hold on;
title('Velocity field - '+img_id+' denoised');
set(h,'LineColor','none')
colormap(parula);
colorbar();
xlim([0,512])
ylim([0,512])
quiver(xv,yv,vx,vy,'k')
set(gca,'FontName','TimesNewRoman','FontSize',12);
set(gca, 'YDir','reverse')
xlabel('x [px]')
ylabel('y [px]')
hold off;

%% estimating error

Urms_n = sqrt(mean(mean((Un-U).^2)))
Urms_den = sqrt(mean(mean((Uden-U).^2)))


imgrms_n = sqrt(mean(mean((img1-img1n).^2)))
imgrms_den = sqrt(mean(mean((img1-img1den).^2)))


urms_n=sqrt(mean(mean((u-un).^2)))
urms_den=sqrt(mean(mean((u-uden).^2)))

vrms_n=sqrt(mean(mean((v-vn).^2)))
vrms_den=sqrt(mean(mean((v-vden).^2)))








