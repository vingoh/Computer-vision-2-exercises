
img1 = imread("/Users/hpj123/Desktop/Vorlesung/Computer Vision/Exercise/ex06/batinria0.tif");
img2 = imread("/Users/hpj123/Desktop/Vorlesung/Computer Vision/Exercise/ex06/batinria1.tif");

gcf = 8;

K1 = [844.310547 0 243.413315; 0 1202.508301 281.529236; 0 0 1];
K2 = [852.721008 0 252.021805; 0 1215.657349 288.587189; 0 0 1];

%figure;
%imshow(img1);
%[x1,y1] = ginput(gcf);

%imshow(img2);
%[x2,y2] = ginput(gcf);

[x1,y1,x2,y2] = getpoints2();
pts1 = K1 \ [x1 y1 ones(size(x1,1),1)]';  %x1' = K1*pts1, pts1 = [x/z;y/z;z/z] in camera cordinate
pts2 = K2 \ [x2 y2 ones(size(x1,1),1)]';
ki=zeros(size(x1,1), 9); 

for i=1:size(x1,1)
    
    ki(i,:)=kron(pts1(:,i),pts2(:,i));

end

[Uki, Ski, Vki] = svd(ki);
E = reshape(Vki(:,9), 3, 3);
[UE, SE, VE] = svd(E);

SE(1,1) = 1;SE(2,2) = 1;SE(3,3) = 0;
if det(UE)<0
    UE = -UE;
end
if det(VE)<0
    VE = -VE;
end

Rzp = [0 -1 0; 1 0 0; 0 0 1];
Rzn = Rzp';

R1 = UE*Rzp'*VE';
R2 = UE*Rzn'*VE';
Tcap1 = UE*Rzp*SE*UE';
Tcap2 = UE*Rzn*SE*UE';
T1 = [-Tcap1(2,3); Tcap1(1,3); -Tcap1(1,2)];
T2 = [-Tcap2(2,3); Tcap2(1,3); -Tcap2(1,2)];


nPoint = size(x1,1);
check(R1, T1, pts1, pts2);
check(R1, T2, pts1, pts2);
check(R2, T1, pts1, pts2);
check(R2, T2, pts1, pts2);

function [] = check(R, T, pts1, pts2)
nPoint = size(pts1,2);
M = zeros(3*nPoint, nPoint+1);

for i = 1:nPoint
    x1i = pts1(:,i);
    x2i = pts2(:,i);
    x2icap = [0 -x2i(3) x2i(2); x2i(3) 0 -x2i(1); -x2i(2) x2i(1) 0];
    M(i:i+2, i) = x2icap*R*x1i;
    M(i:i+2, nPoint+1) = x2icap*T;

end

[V, ~] = eig(M'*M);
lambda1 = V(1:nPoint, 1);   %n*1
gamma = V(nPoint+1, 1);
if gamma < 0
    gamma = -gamma;
    lambda1 = -lambda1;
end

X1 = pts1 .* repmat(lambda1', 3, 1);
X2 = repmat(lambda1',3,1) .* (R*pts1) + gamma*repmat(T,1,nPoint);
lambda2 = X2(3,:);

lambda1
lambda2'
%X1sol = [pts1(1:2, :); ones(1, nPoint)].* repmat(lambda1', 3, 1);
%X2sol = R * X1sol + repmat(T, 1, nPoint);

if sum(lambda1 < 0)==0 && sum(lambda2 < 0)==0
    R
    T
    figure
    plotCamera('Location',[0 0 0],'Orientation',eye(3),'Opacity',0, 'Size', 0.2, 'Color', [1 0 0]) % red
    plotCamera('Location', -R'*T,'Orientation',R,'Opacity',0, 'Size', 0.2, 'Color', [0 1 0]) % green
    
    axis equal
    grid on
    xlabel('x')
    ylabel('y')
    zlabel('z')
end    


end

function [x1,y1,x2,y2] = getpoints2()

x1 = [
   10.0000
   92.0000
    8.0000
   92.0000
  289.0000
  354.0000
  289.0000
  353.0000
   69.0000
  294.0000
   44.0000
  336.0000
  ];

y1 = [ 
  232.0000
  230.0000
  334.0000
  333.0000
  230.0000
  278.0000
  340.0000
  332.0000
   90.0000
  149.0000
  475.0000
  433.0000
    ];
 
x2 = [
  123.0000
  203.0000
  123.0000
  202.0000
  397.0000
  472.0000
  398.0000
  472.0000
  182.0000
  401.0000
  148.0000
  447.0000
    ];

y2 = [ 
  239.0000
  237.0000
  338.0000
  338.0000
  236.0000
  286.0000
  348.0000
  341.0000
   99.0000
  153.0000
  471.0000
  445.0000
    ];

end
