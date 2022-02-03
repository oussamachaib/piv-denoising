
%% Plot original, noisy, denoised image

function [] = noiseplot(I,In,Id)
figg=figure();
subplot(131)
imshow(I);
title('Original');
ylabel('y [px]');
xlabel('x [px]');
subplot(132)
imshow(In);
title('Noisy')
xlabel('x [px]');
subplot(133)
imshow(Id);
title('Denoised')
xlabel('x [px]');
set(gca,'FontSize',12);
figg.Position = [150 250 1500 500];
end
