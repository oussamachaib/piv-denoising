piv1=imread('images/piv-synth1.png');

piv1g=im2gray(piv1);

piv1g=imbinarize(im2gray(piv1g));

figure(1)
imshow(piv1g);
title('piv1')
xlabel('x [px]')
ylabel('y [px]')
set(gca,'FontSize',20);
set(gcf,'Position',[400 250 500 500]);

figure(2)
hist=histogram(piv1g);
%xlim([100 inf])
ylim([0 60])
%axis tight
xlabel('grayscale')
ylabel('intensity')
set(gca,'FontSize',20);
set(gcf,'Position',[600 250 500 500]);

