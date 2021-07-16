[V,F] = openOFF('model.off', '');

V_r = rotate(V, 45, 0, 120); %x first

V_xfirst = rotate(V, 45, 0, 0);
V_xfirst = rotate(V_xfirst, 0, 0, 120);

V_zfirst = rotate(V, 0, 0, 120);
V_zfirst = rotate(V_zfirst, 45, 0, 0);

trans = [0.5 0.2 0]';
V_trans = rotate_extend(V, trans, 90, 0, 0);

P = patch('Vertices', V_trans, 'Faces', F, 'FaceVertexCData',0.3*ones(size(V,1),3));
axis equal;
shading interp;
camlight right;
camlight left;

w = [1; 2; 3];
wCap = w2cap(w);
R = v2Lie(w);
R2 = expm(w2cap(w));
v = Lie2v(R);

t = [1 2 3 4 5 6];
g = t2Lie(t);
back = Lie2t(g);

function [cap] = w2cap(w)
cap = [0       -w(3)   w(2);
        w(3)    0       -w(1);
        -w(2)   w(1)    0];
end

function [g] = t2Lie(t)  %t belongs to R6
w = [t(1); t(2); t(3)];
v = [t(4); t(5); t(6)];
wCap = w2cap(w);

R = v2Lie(w);
T = ((eye(3)-R) * wCap * v + w * w' *v)/(norm(w)*norm(w));

g = [R T; 0 0 0 1];
end

function [t] = Lie2t(g)
R = g(1:3, 1:3);
T = g(1:3, 4);

w = Lie2v(R);
wCap = w2cap(w);
%v = inv((ones(3)-R) * wCap + w * w') * T * norm(w).^2;
v = ((eye(3)-R) * wCap + w * w') \ T * norm(w).^2;

t = [w' v'];
end

function [R] = v2Lie(w)
wCap = w2cap(w);
n = norm(w);
R = eye(3) + wCap/n * sind(n) + wCap*wCap/(n*n) * (1-cosd(n)); 

end

function [w] = Lie2v(R)
n = acos((trace(R)-1)/2);
w = n/(2*sind(n))*[R(3,2)-R(2,3); R(1,3)-R(3,1); R(2,1)-R(1,2)];

end

function [V_rotated] = rotate(V, alpha, beta, gamma)
center = mean(V);
V_c = V - center;
rotation_x = [1     0          0; 
              0     cosd(alpha) -sind(alpha); 
              0     sind(alpha) cosd(alpha)];
rotation_y = [cosd(beta)     0      sind(beta); 
              0             1      0; 
              -sind(beta)    0      cosd(beta)];
rotation_z = [cosd(gamma)    -sind(gamma) 0;
              sind(gamma)    cosd(gamma)  0;
              0             0           1];
rotation = rotation_z * rotation_y * rotation_x;

V_rotated = (rotation * V_c')' + center;


end

function [V_rotated] = rotate_extend(V, trans, alpha, beta, gamma)
center = mean(V);
V_c = V - center;
rotation_x = [1     0          0; 
              0     cosd(alpha) -sind(alpha); 
              0     sind(alpha) cosd(alpha)];
rotation_y = [cosd(beta)     0      sind(beta); 
              0             1      0; 
              -sind(beta)    0      cosd(beta)];
rotation_z = [cosd(gamma)    -sind(gamma) 0;
              sind(gamma)    cosd(gamma)  0;
              0             0           1];
rotation = [rotation_z * rotation_y * rotation_x trans; 0 0 0 1];

V_extend = [V_c ones(size(V_c, 1), 1)];

V_rotated = (rotation * V_extend')';
V_rotated = V_rotated(:, 1:3) + center;

end

