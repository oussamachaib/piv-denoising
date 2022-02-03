figure()
subplot(231)
imshow(I(1:50,1:50))
title('Original','Interpreter','latex')

subplot(232)
imshow(In(1:50,1:50))
title('Noisy','Interpreter','latex')

subplot(233)
imshow(Id(1:50,1:50))
title('Wavelet ('+string(wfilter)+', '+string(lvl)+', '+string(method)+', '+string(tr)+')','Interpreter','latex');

subplot(234)
imshow(Id1(1:50,1:50))
title('Median','Interpreter','latex')


subplot(235)
imshow(Id2(1:50,1:50))
title('Mean (k=3x3)','Interpreter','latex')

subplot(236)
imshow(Id3(1:50,1:50))
title('Wiener (k=3x3)','Interpreter','latex')

sgtitle('$\sigma = $'+string(stdev),'Interpreter','latex') 

set(findall(gcf,'-property','FontSize'),'FontSize',20)

%saveas(gcf,'figures/denoising/img_'+imname+'_sigma'+string(stdev)+'.jpg')


