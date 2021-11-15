close('all')
clear;

%% load image

img_id = "stag";
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

%% cross-correlation

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

x=linspace(0,512,length(vx));
y=linspace(0,512,length(vx));

xv=window/2:window:l;
yv=window/2:window:l;

U = sqrt(vx.^2+vy.^2);
Uhat = U./max(U);

figure();
[C,h] = contour(x,y,Uhat,100);
hold on;
title('Velocity field - '+img_id);
set(h,'LineColor','none')
colormap(parula);
%colorbar();
xlim([0,512])
ylim([0,512])
quiver(xv,yv,vx,vy,'k')
set(gca,'FontName','TimesNewRoman','FontSize',12);
set(gca, 'YDir','reverse')
xlabel('x [px]')
ylabel('y [px]')
hold off;
