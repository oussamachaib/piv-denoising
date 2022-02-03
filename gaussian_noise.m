
%% Add Gaussian noise with mean mu and variance var to a uint8 image
% The variance in the input corresponds to the real noise variance

function [In] = gaussian_noise(I, mu, var)
h = 512; % in px
w = 512; % in px

[h, w] = size(I);

ref=double(max(max(I)));
gaussian_noise = randn(h,w)*sqrt(var)*ref+mu;
Idouble = double(I);
Idouble_n = Idouble + gaussian_noise;
In = uint8(Idouble_n);
end