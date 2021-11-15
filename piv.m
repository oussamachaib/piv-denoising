close('all')
clear;

%% load image

img_id = "rankine";
ext = ".tiff";

img1 = imread("images/tiff/"+img_id+'1'+ext);
img1 = rgb2gray(img1(:,:,1:3));

img2 = imread("images/tiff/"+img_id+'2'+ext);
img2 = rgb2gray(img2(:,:,1:3));

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
        [dy, dx] = find(corr==max(max(corr)));
        dx = dx - window;
        dy = dy - window;
        vx(cnta,cntb) = -dx/dt;
        vy(cnta,cntb) = -dy/dt;
        cntb = cntb+1;
    end
end

x=linspace(0,512,length(vx));
y=linspace(0,512,length(vx));

xv=window/2:window:512;
yv=window/2:window:512;

U = sqrt(vx.^2+vy.^2);
Uhat = U./max(U);

figure();
[C,h] = contourf(x,y,Uhat,200);
hold on;
title('Velocity field - '+img_id);
set(h,'LineColor','none')
colormap(hot);
colorbar();
xlim([0,512])
ylim([0,512])
quiver(xv,yv,vx,vy,'k')
set(gca,'FontName','TimesNewRoman','FontSize',12);
set(gca, 'YDir','reverse')
hold off;
