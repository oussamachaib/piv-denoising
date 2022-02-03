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

l = length(img1);

%% add noise + denoise

wfilter='bior1.1';
level = 2;
dm = 'Bayes'; % 'Bayes' by def


mu = 0; % noise mu
var = 3 ; % noise variance

max_iter = 50

window = 32;
dt=1;



%% declaring vars
vx = zeros(floor(l/window),floor(l/window));
vy = zeros(floor(l/window),floor(l/window));

x=linspace(0,512,length(vx));
y=linspace(0,512,length(vx));

xv=window/2:window:l;
yv=window/2:window:l;

Urms_n = zeros(length(max_iter),1);
Urms_den = zeros(length(max_iter),1);
imgrms_n = zeros(length(max_iter),1);
imgrms_den = zeros(length(max_iter),1);
urms_n = zeros(length(max_iter),1);
urms_den = zeros(length(max_iter),1);
vrms_n = zeros(length(max_iter),1);
vrms_den = zeros(length(max_iter),1);

for i=1:max_iter
i
img1n = imnoise(img1, 'gaussian',mu,var/255);
img2n = imnoise(img2, 'gaussian',mu,var/255);

img1den = wdenoise2(img1n,level,'Wavelet',wfilter,'DenoisingMethod',dm);
img1den = uint8(img1den); 
img2den = wdenoise2(img2n,level,'Wavelet',wfilter); 
img2den = uint8(img2den);

%% cross-correlation without noise


cnta=0;
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

U = sqrt(vx.^2+vy.^2);


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

%% estimating error

Urms_n(i) = sqrt(mean(mean((Un-U).^2)));
Urms_den(i) = sqrt(mean(mean((Uden-U).^2)));


imgrms_n(i) = sqrt(mean(mean((img1-img1n).^2)));
imgrms_den(i) = sqrt(mean(mean((img1-img1den).^2)));


urms_n(i)=sqrt(mean(mean((u-un).^2)));
urms_den(i)=sqrt(mean(mean((u-uden).^2)));

vrms_n(i)=sqrt(mean(mean((v-vn).^2)));
vrms_den(i)=sqrt(mean(mean((v-vden).^2)));

end


