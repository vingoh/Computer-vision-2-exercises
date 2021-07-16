I1 = imreadbw("/Users/hpj123/Desktop/Vorlesung/Computer Vision/Exercise/ex05/img1.png");
I2 = imreadbw("/Users/hpj123/Desktop/Vorlesung/Computer Vision/Exercise/ex05/img2.png");
sigma = 2;

[vx, vy] = getFlow(I1, I2, sigma);


subplot(1,3,1);
set (gcf,'Position',[500,500,1500,500], 'color','w');
imagesc(vx);
axis image


subplot(1,3,2);
imagesc(vy);
axis image

subplot(1,3,3);
imagesc(I1)
colormap(gca, 'gray')
axis image
hold on
% plot arrows with true scale
quiver(vx, vy, 0)
title('flow')

function [vx, vy] = getFlow(I1, I2, sigma)

[M11, M12, M22, q1, q2] = getMq(I1, I2, sigma);

% TODO calc flow (w/o loop).

vx = (M22.*q1-M12.*q2)./(M11.*M22 - M12.^2);
vy = (M11.*q2-M12.*q1)./(M11.*M22 - M12.^2);

end

function [M11, M12, M22, q1, q2] = getMq(I1, I2, sigma)

[Gx, Gy] = imgradientxy(I1, 'central');
It = I2 - I1;

k = double(uint8(4*sigma+1));
kernel = fspecial('gaussian', k, sigma);
M11 = conv2(Gx.^2, kernel, 'same');
M12 = conv2(Gx.*Gy, kernel, 'same');
M22 = conv2(Gy.^2, kernel, 'same');

q1 = conv2(Gx.*It, kernel, 'same');
q2 = conv2(Gy.*It, kernel, 'same');

end