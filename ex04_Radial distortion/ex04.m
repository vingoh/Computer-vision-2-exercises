[V,F] = openOFF('model.off', '');

close all;

T = [-0.5 -0.5 1];
V_t = V + T;
VHomo = [V_t ones(size(V, 1), 1)]';
figure;
display(V_t,F);

figure
project(VHomo, 540, 320, 240, 1, 1, 0);
xlim([0, 640]);
ylim([0, 480]);


function project(V, f, ox, oy, sx, sy, stheta)

Ks = [sx stheta ox; 0 sy oy; 0 0 1];
Kf = [f 0 0; 0 f 0; 0 0 1];
p0 = [eye(3) zeros(3,1)];
V2 = [V(1,:)./V(3,:); V(2,:)./V(3,:); ones(1, size(V,2)); ones(1, size(V,2))./V(3,:)];

VProj = Ks * Kf * p0 * V2;

plot(VProj(1,:), VProj(2,:))

end

function display(V,F)
    C = 0.3*ones(size(V,1),3);
    patch('Vertices', V, 'Faces', F, 'FaceVertexCData', C);
    axis equal;
    shading interp;
    camlight right;
    camlight left;
end