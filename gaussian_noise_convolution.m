close('all')
clear
clc


I = imread('images/tiff/parab1.tiff');
J = imread('images/tiff/parab2.tiff');

I = rgb2gray(I(:,:,1:3));
J = rgb2gray(J(:,:,1:3));

%% testing how to manually create a normal distribution with fixed mean and std

% mu = 1;
% var = 2;
% 
% x = -100:.1:100;
% gaussian = (1/sqrt(2*pi*var))*exp(-((x-mu).^2)/(2*var));
% 
% rand2 = randn(1,201);
% rand2 = rand2*(sqrt(var));
% rand2 = rand2+mu;
% 
% gaussian2 = (1/sqrt(2*pi*std(rand2)^2))*exp(-((x-mean(rand2)).^2)/(2*std(rand2)^2));
% 
% figure();
% plot(x,gaussian,'b')
% hold on;
% 
% plot(x,gaussian2,'r')
% legend('og','new');
% set(gca,'FontSize',30);

%% denoising function
mu = 0;
var = 0.10 ; % as a percentage of the maximum signal i suppose? ~ NSR

height = 512; % in px
width = 512; % in px

ref=double(max(max(I)));
noise = randn(height,width)*var*ref+mu;
Idouble = double(I);
Idouble_n = Idouble + noise;
In = uint8(Idouble_n);

d=100;
figure()
subplot(121)
imshow(I(1:d,1:d));
title('I')
set(gca,'FontSize',30);

subplot(122)
imshow(In(1:d,1:d));
title('In - manual')
set(gca,'FontSize',30);

%% testing homemade denoising function

Jn = gaussian_noise(J,0,0.1);

figure()
subplot(121)
imshow(J(1:d,1:d));
title('J')
set(gca,'FontSize',30);

subplot(122)
imshow(Jn(1:d,1:d));
title('Jn - manual')
set(gca,'FontSize',30);







