close('all');
clear;

x  = linspace(0,20,100);
y = sin(x);
mean = .2;
std = 1;
rng(1)
noise = mean.*randn(1,length(y))+std;
yn = (y + noise)/max(y + noise);
figure();
subplot(121);
plot(x,y);
ylim([-2.5,2.5])
title(" y = f(x) ");
subplot(122);
plot(x,yn);
ylim([-2.5,2.5])
title(" y = f(x) + noise ");

wname='db1';

% level 1 forward DWT
[coeff_a, coeff_b] = dwt(yn,wname);
figure()
subplot(121)
plot(x(1:length(coeff_a)),coeff_a)
title('coeff approximation level 1');
ylim([-2.5,2.5]);
subplot(122);
plot(x(1:length(coeff_b)),coeff_b);
title('coeff details level 1');
ylim([-2.5,2.5]);

% multi-level DWT (up to lvl 2)
[ c , l ] = wavedec(yn,1,wname);
ca1 = appcoef(c,l,wname);
[ c , l ] = wavedec(yn,2,wname);
ca2 = appcoef(c,l,wname);
[cd1,cd2] = detcoef(c,l,[1 2]);

x1=x([1:floor(length(x)/2)]);
x2=x([1:floor(length(x)/4)]);

figure()
subplot(3,4,3)
plot(x,yn)
title(" y = f(x) + noise ");
ylim([-2.5,2.5]);
xlim([x(1),x(length(x))]);
subplot(3,4,6)
plot(x1,ca1)
title("ca1");
ylim([-2.5,2.5]);
xlim([x(1),x(length(x))]);
subplot(3,4,7)
plot(x1,cd1)
title("cd1");
ylim([-2.5,2.5]);
xlim([x(1),x(length(x))]);
subplot(3,4,9)
plot(x2,ca2)
title("ca2");
ylim([-2.5,2.5]);
xlim([x(1),x(length(x))]);
subplot(3,4,10)
plot(x2,cd2)
title("cd2");
ylim([-2.5,2.5]);
xlim([x(1),x(length(x))]);

yd=wdenoise(yn,5,'Wavelet','bior3.3');
figure();
subplot(131);
plot(x,y);
title('y');
subplot(132);
plot(x,yn);
title('yn = y + noise');
subplot(133);
plot(x,yd);
title('yn denoised');
