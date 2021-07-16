img = imreadbw("/Users/hpj123/Desktop/Vorlesung/Computer Vision/Exercise/ex04/img1.jpg");
mat = img2mat(img, 752, 480);

imgnew = zeros(768, 1024);
matnew = img2mat(imgnew, 768, 1024);

w = 0.92646;
K1 = [388.6 0 343.7; 0 389.4 234.6; 0 0 1];
Knew = [250 0 512; 0 250 384; 0 0 1];



uv = [matnew(:,1) matnew(:,2) ones(768*1024, 1)]';
piXHomo = Knew^-1 * uv;
piX = piXHomo(1:2, :);
square = piX.^2;
r = sqrt(square(1,:)+square(2,:));
g = atan(2*tan(w/2).*r)./(w.*r);
piXHomoNew = [g.*piX; piXHomo(3,:)];
uvd = K1*[g.*piX; piXHomo(3,:)];

[X,Y] = meshgrid(1:752, 1:480);
INew = interp2(X,Y,img,uvd(1,:),uvd(2,:));
matnew(:,3)=INew';

imgnew = mat2img(matnew, 480, 752);


%read img as matrix [x, y, intensity]
function mat = img2mat(img, sizex, sizey)
i=1;
mat = zeros(sizey*sizex, 3);
for y = 1:size(img,1)
    for x = 1:size(img,2)
        mat(i,:) = [x, y, img(y,x)];
        i = i+1;
    end
end

end




%reconstruct image from matrix
function img2 = mat2img(imgmat, ysize, xsize)
img2 = zeros(ysize, xsize);
for i = 1:size(imgmat, 1)
    x = imgmat(i,1);
    y = imgmat(i,2);
    img2(y, x) = imgmat(i,3);
end
end
