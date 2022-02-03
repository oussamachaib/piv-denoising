 close('all');
% clear;
% clc;

%figure();
imtitle = 'l21113xxxx001';
path = 'images/DLR/';
ext = '/*.im7';
%v = loadvec(fullfile(path,imtitle,ext));
%showf(v)

v2 = VideoWriter(string(imtitle)+'.avi');
v2.FrameRate = 50;

open(v2);

figure()
for i = 1:length(v)
w=flip(v(i).w,2)';
x=v(i).x;
y=v(i).y;
imshow(w,[]);
text(10,50,('i = '+string(i)+'/'+length(v)),'Color','w','FontSize',20,'Interpreter','latex');
%axis on;
title(imtitle,'Interpreter','latex', 'FontSize',20)
pos = get(gca, 'Position');
pos(1) = 0.055;
pos(3) = 1;
pos(4) = .80;
set(gca, 'Position', pos)
%set(findall(gcf,'-property','FontSize'),'FontSize',20);
frame = getframe(gcf);
writeVideo(v2,frame);
drawnow;
end


close(v2);