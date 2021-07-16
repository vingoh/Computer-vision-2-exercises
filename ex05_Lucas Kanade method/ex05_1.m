I = imreadbw("/Users/hpj123/Desktop/Vorlesung/Computer Vision/Exercise/ex05/img1.png");
kernel = fspecial('gaussian', double(uint8(7.3)), 1);
[M11, M12, M22] = getM(I, 2);

function [M11, M12, M22] = getM(img, sigma)

[Gx, Gy] = imgradientxy(img, 'central');
k = double(uint8(4*sigma+1));
kernel = fspecial('gaussian', k, sigma);
M11 = conv2(Gx.^2, kernel, 'same');
M12 = conv2(Gx.*Gy, kernel, 'same');
M22 = conv2(Gy.^2, kernel, 'same');

end