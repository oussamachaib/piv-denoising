close('all')
clear
clc


%% reading and initializing images

imname = "parab";
I = imread('images/tiff/'+imname+'1.tiff');
J = imread('images/tiff/'+imname+'2.tiff');

I = rgb2gray(I(:,:,1:3));
J = rgb2gray(J(:,:,1:3));

%% noise settings

mu = 0; % Noise mean, always keep null
stdev = .1; % as a fraction of the maximum intensity
var = stdev^2;

seed=rng(3);
In = gaussian_noise(I,0,var);
Jn = gaussian_noise(J,0,var);

%% denoising settings

% Wavelet
wfilter = 'sym2'; % Wavelet family
lvl = 1; % Maximum level
method= 'Bayes'; % Denoising method
tr= 'median'; % Thresholding method
Id = uint8(wdenoise2(In,lvl,'Wavelet',wfilter,'DenoisingMethod',method,'ThresholdRule',tr));
Jd = uint8(wdenoise2(Jn,lvl,'Wavelet',wfilter,'DenoisingMethod',method,'ThresholdRule',tr));

% Median
[Id1,estDoS] = imnlmfilt(In);
[Jd1,estDoS] = imnlmfilt(Jn);

% Mean
Id2 = filter2(fspecial('average',3),In)/255; % 3x3 kernel
Jd2 = filter2(fspecial('average',3),Jn)/255;

% Wiener
[Id3,noise_outI] = wiener2(In,[3 3]); % 3x3 kernel
[Jd3,noise_outJ] = wiener2(Jn,[3 3]);

% Visualizing
% noiseplot(I(1:100,1:100),In(1:100,1:100),Id(1:100,1:100))


%% PIV cross-correlation settings

% Cross-correlation information
window = 32; % Window size
dt=1; % Time difference between snapshots, set to 1 by default for displacement field

% Initializing vectors and matrices
l=length(I); % Image resolution (lxl)

vx = zeros(floor(l/window),floor(l/window)); % Horizontal displacement vector
vy = zeros(floor(l/window),floor(l/window)); % Vertical displacement vector
vxn = vx;
vyn = vy;
vxd = vx;
vyd = vy;
vxd1 = vx;
vyd1 = vy;
vxd2 = vx;
vyd2 = vy;
vxd3 = vx;
vyd3 = vy;
x=linspace(0,l,l/window); % contour x-axis
y=linspace(0,l,l/window); % contour y-axis
xv=window/2:window:l; % quiver x-axis
yv=window/2:window:l; % quiver y-axis

%% PIV cross-correlation
%% real displacement field

cnta=0;
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

U = sqrt(vx.^2+vy.^2); % Total displacement vector

figure()
fig.Position = [150 250 1500 500];
subplot(231)
% Total displacement contour
[C,h] = contourf(x,y,U,100);
hold on;
title('Real disp. field','Interpreter','latex');
set(h,'LineColor','none')
colormap(parula);
colorbar();
xlim([0,512])
ylim([0,512])
% displacement field 2D plot
quiver(xv,yv,vx,vy,'k')
set(gca,'FontName','TimesNewRoman','FontSize',12);
set(gca, 'YDir','reverse')
xlabel('x [px]','Interpreter','latex')
ylabel('y [px]','Interpreter','latex')

%% noisy displacement field

cnta=0;
for a=1:window:l
    cnta=cnta+1;
    cntb=1;
    for b=1:window:l
        corr = xcorr2(In(a:a+window-1,b:b+window-1),Jn(a:a+window-1,b:b+window-1));
        [dy, dx] = find(corr==max(max(corr)),1,'first');
        dx = dx - window;
        dy = dy - window;
        vxn(cnta,cntb) = -dx/dt;
        vyn(cnta,cntb) = -dy/dt;
        cntb = cntb+1;
    end
end

Un = sqrt(vxn.^2+vyn.^2); % Total displacement vector

fig.Position = [150 250 1500 500];
subplot(232)
% Total displacement contour
[C,h] = contourf(x,y,Un,100);
hold on;
title('Noisy disp. field','Interpreter','latex');
set(h,'LineColor','none')
colormap(parula);
colorbar();
xlim([0,512])
ylim([0,512])
% displacement field 2D plot
quiver(xv,yv,vxn,vyn,'k')
set(gca,'FontName','TimesNewRoman','FontSize',12);
set(gca, 'YDir','reverse')
xlabel('x [px]','Interpreter','latex')

%% denoising
%% wavelet denoised displacement field

cnta=0;
for a=1:window:l
    cnta=cnta+1;
    cntb=1;
    for b=1:window:l
        corr = xcorr2(Id(a:a+window-1,b:b+window-1),Jd(a:a+window-1,b:b+window-1));
        [dy, dx] = find(corr==max(max(corr)),1,'first');
        dx = dx - window;
        dy = dy - window;
        vxd(cnta,cntb) = -dx/dt;
        vyd(cnta,cntb) = -dy/dt;
        cntb = cntb+1;
    end
end

Ud = sqrt(vxd.^2+vyd.^2); % Total displacement vector

subplot(233)
% Total displacement contour
[C,h] = contourf(x,y,Ud,100);
hold on;
title('Wavelet ('+string(wfilter)+', '+string(lvl)+', '+string(method)+', '+string(tr)+')','Interpreter','latex');
set(h,'LineColor','none')
colormap(parula);
colorbar();
xlim([0,512])
ylim([0,512])
% displacement field 2D plot
quiver(xv,yv,vxd,vyd,'k')
set(gca,'FontName','TimesNewRoman','FontSize',12);
set(gca, 'YDir','reverse')
xlabel('x [px]','Interpreter','latex')

%% median denoised displacement field

cnta=0;
for a=1:window:l
    cnta=cnta+1;
    cntb=1;
    for b=1:window:l
        corr = xcorr2(Id1(a:a+window-1,b:b+window-1),Jd1(a:a+window-1,b:b+window-1));
        [dy, dx] = find(corr==max(max(corr)),1,'first');
        dx = dx - window;
        dy = dy - window;
        vxd1(cnta,cntb) = -dx/dt;
        vyd1(cnta,cntb) = -dy/dt;
        cntb = cntb+1;
    end
end

Ud1 = sqrt(vxd1.^2+vyd1.^2); % Total displacement vector

subplot(234)
% Total displacement contour
[C,h] = contourf(x,y,Ud1,100);
hold on;
title('Median','Interpreter','latex');
set(h,'LineColor','none')
colormap(parula);
colorbar();
xlim([0,512])
ylim([0,512])
% displacement field 2D plot
quiver(xv,yv,vxd1,vyd1,'k')
set(gca,'FontName','TimesNewRoman','FontSize',12);
set(gca, 'YDir','reverse')
ylabel('y [px]','Interpreter','latex')
xlabel('x [px]','Interpreter','latex')

%% median denoised displacement field

cnta=0;
for a=1:window:l
    cnta=cnta+1;
    cntb=1;
    for b=1:window:l
        corr = xcorr2(Id2(a:a+window-1,b:b+window-1),Jd2(a:a+window-1,b:b+window-1));
        [dy, dx] = find(corr==max(max(corr)),1,'first');
        dx = dx - window;
        dy = dy - window;
        vxd2(cnta,cntb) = -dx/dt;
        vyd2(cnta,cntb) = -dy/dt;
        cntb = cntb+1;
    end
end

Ud2 = sqrt(vxd2.^2+vyd2.^2); % Total displacement vector

subplot(235)
% Total displacement contour
[C,h] = contourf(x,y,Ud2,100);
hold on;
title('Mean (k = 3x3)','Interpreter','latex');
set(h,'LineColor','none')
colormap(parula);
colorbar();
xlim([0,512])
ylim([0,512])
% displacement field 2D plot
quiver(xv,yv,vxd2,vyd2,'k')
set(gca,'FontName','TimesNewRoman','FontSize',12);
set(gca, 'YDir','reverse')
xlabel('x [px]','Interpreter','latex')

%% median denoised displacement field

cnta=0;
for a=1:window:l
    cnta=cnta+1;
    cntb=1;
    for b=1:window:l
        corr = xcorr2(Id3(a:a+window-1,b:b+window-1),Jd3(a:a+window-1,b:b+window-1));
        [dy, dx] = find(corr==max(max(corr)),1,'first');
        dx = dx - window;
        dy = dy - window;
        vxd3(cnta,cntb) = -dx/dt;
        vyd3(cnta,cntb) = -dy/dt;
        cntb = cntb+1;
    end
end

Ud3 = sqrt(vxd3.^2+vyd3.^2); % Total displacement vector

subplot(236)
% Total displacement contour
[C,h] = contourf(x,y,Ud3,100);
hold on;
title('Wiener (k = 3x3)','Interpreter','latex');
set(h,'LineColor','none')
colormap(parula);
colorbar();
xlim([0,512])
ylim([0,512])
% displacement field 2D plot
quiver(xv,yv,vxd3,vyd3,'k')
set(gca,'FontName','TimesNewRoman','FontSize',12);
set(gca, 'YDir','reverse')
xlabel('x [px]','Interpreter','latex')

sgtitle('$\sigma = $'+string(stdev),'Interpreter','latex') 

gca.TickLabelInterpreter='latex';
gca.TitleInterpreter='latex';
gca.LabelInterpreter='latex';

set(findall(gcf,'-property','FontSize'),'FontSize',20)

%saveas(gcf,'figures/denoising/vfield_'+imname+'_sigma'+string(stdev)+'.jpg')





