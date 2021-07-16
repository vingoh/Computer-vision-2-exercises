%question 1
img = imread('/Users/hpj123/Desktop/Vorlesung/Computer Vision/Exercise/ex01/lena.png');
%imshow(img);
img_size = size(img);
gray = rgb2gray(img);
min_gray = min(gray(:));
max_gray = max(gray(:));
img_blur = imgaussfilt(img, 2);
imwrite(img_blur, 'blur.jpg');
%{
subplot(1,3,1), imshow(img), title('oringin');
subplot(1,3,2), imshow(gray), title('gray');
subplot(1,3,3), imshow(img_blur), title('gaussian blurred');
%}

%question 2
A = [2,2,0; 0,8,3];
b = [5; 15];
x = A\b; %caution! here is "\" 
B = A;
A(1,2) = 4;
c = 0;
for i = -4:4:4
    c = c + i * A' * b;
end
%disp(c);

%question 3
t1 = [1,2;2,2;3,2];
t2 = [1,2;2,2;3,3];
diff = approxequal(t1, t2, 0.5);
%disp(diff);

%question4
s = addprimes(1,3);
disp(s);










function diff = approxequal(x,y,e)
    diff = all(abs(x-y) < e);
end

function sum_prime = addprimes(s,e)
    sum_prime = 0;
    for i = s:e
        if isprime(i)
            sum_prime = sum_prime + i;
        end
    end
end














