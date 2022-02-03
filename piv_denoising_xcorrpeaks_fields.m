close('all')
clear
clc


I = imread('images/tiff/parab1.tiff');
J = imread('images/tiff/parab2.tiff');

I = rgb2gray(I(:,:,1:3));
J = rgb2gray(J(:,:,1:3));

rng(2)
%% noise

mu = 0;
var = 0.01; % as a fraction of the maximum intensity



seed=rng(3);
In = gaussian_noise(I,0,var);
Jn = gaussian_noise(J,0,var);

wfilter = 'db1';
lvl = 1;
method= 'Bayes';
tr= 'median';
Id = uint8(wdenoise2(In,lvl,'Wavelet',wfilter,'DenoisingMethod',method,'ThresholdRule',tr));
Jd = uint8(wdenoise2(Jn,lvl,'Wavelet',wfilter,'DenoisingMethod',method,'ThresholdRule',tr));

%%
% correlation window and position
w = 32;

a = 1;
b = a+w-1;
c = 1;
d = c+w-1;


noise = In(a:b,c:d)-I(a:b,c:d);

fig=figure();

subplot(141)
imshow(I(a:b,c:d))
title('original')

subplot(142)
imshow(In(a:b,c:d))
title('noisy')

subplot(143)
imshow(Id(a:b,c:d))
title('denoised')

subplot(144)
imshow(noise)
title('noise')

fig.Position = [150 250 1500 500];

[X,Y] = meshgrid(-(w-1):w-1,-(w-1):w-1);
crosscorr1 = normxcorr2(I(a:b,c:d),J(a:b,c:d));
%va=60;
%vb=15;
%%
%%

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

crosscorr2 = normxcorr2(In(a:b,c:d),Jn(a:b,c:d));

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

crosscorr3 = normxcorr2(Id(a:b,c:d),Jd(a:b,c:d));
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

fig1.Position = [150 250 1500 500];
hold off;
% saveas(gcf,'figures/denoising/crosscorr_mean0_var3_a200_w32.jpg')

%%
%%
figure()
window = 32;
dt=1;
cnta=0;
l=length(I);

vx = zeros(floor(l/window),floor(l/window));
vy = zeros(floor(l/window),floor(l/window));

for a=1:window:l
    cnta=cnta+1;
    cntb=1;
    for b=1:window:l
        corr = xcorr2(I(a:a+window-1,b:b+window-1),J(a:a+window-1,b:b+window-1));
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

fig.Position = [150 250 1500 500];

subplot(131)
[C,h] = contourf(x,y,Uhat,100);
hold on;
title('Velocity field - I,J');
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


%%


window = 32;
dt=1;
cnta=0;
l=length(I);

vx = zeros(floor(l/window),floor(l/window));
vy = zeros(floor(l/window),floor(l/window));

for a=1:window:l
    cnta=cnta+1;
    cntb=1;
    for b=1:window:l
        corr = xcorr2(In(a:a+window-1,b:b+window-1),Jn(a:a+window-1,b:b+window-1));
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

fig.Position = [150 250 1500 500];

subplot(132)
[C,h] = contourf(x,y,Uhat,100);
hold on;
title('Velocity field - In,Jn');
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

%%
window = 32;
dt=1;
cnta=0;

vx = zeros(floor(l/window),floor(l/window));
vy = zeros(floor(l/window),floor(l/window));

for a=1:window:l
    cnta=cnta+1;
    cntb=1;
    for b=1:window:l
        corr = xcorr2(Id(a:a+window-1,b:b+window-1),Jd(a:a+window-1,b:b+window-1));
        [dy, dx] = find(detrend(detrend(corr))==max(max(detrend(detrend(corr)))),1,'first');
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


fig.Position = [150 250 1500 500];

subplot(133)
[C,h] = contourf(x,y,Uhat,100);
hold on;
title('Velocity field - Id,Jd');
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

%%

Inorm = double(I)./max(max(double(I)));

Innorm = double(In)./max(max(double(In)));

Idnorm = double(I)./max(max(double(Id)));

figure();

subplot(131)
imshow(Inorm)
subplot(132)
imshow(Innorm)
subplot(133)
imshow(Idnorm)

rmsa = sqrt(mean(mean(In-I)))
aa = normxcorr(Innorm-Inorm);

bb = abs(Idnorm-Inorm);

figure()
subplot(121)
contourf(aa)
subplot(122)
contourf(bb)



