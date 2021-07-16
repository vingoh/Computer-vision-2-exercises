%create some data and add some error
m = 3;
rng(1); %seed
d1 = rand(m,1);
d2 = rand(m,1);
d3 = rand(m,1);
d4 = 4*d1 - 3*d2 + 2*d3 - 1;
D = [d1, d2, d3, d4];
eps = 1.e-4 * rand;
D = D + eps;

%Single value decomposition
[U, S, V] = svd(D);

%pseudo inverse
s = diag(S);
S_dagger = diag(s)^-1;
S_dagger(4, m) = 0;
D_dagger = V * S_dagger * U';
D_dagger2 = pinv(D);

%compute Dx=b with D_dagger
b = ones(m, 1);
x = D_dagger*b;
disp(x);

v = null(D);
lambda = -100:100;
x_lambda = x + v * lambda;
e_lambda = vecnorm(D*x_lambda - b).^2;
x_norm = vecnorm(x_lambda);

yyaxis left
plot(lambda, e_lambda);
yyaxis right
plot(lambda, x_norm);



