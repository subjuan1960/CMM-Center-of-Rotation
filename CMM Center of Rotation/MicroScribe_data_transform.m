clear all; close all; clc
% filename = './micro_test.csv';
% filename = './equidistant2.csv';
filename = './J6_measurements.csv';

M = readtable(filename);
P = M{:,:};
% t = 0.01*1e-3*(1:size(P,1))';

Px = P(:,1);
Py = P(:,2);
Pz = P(:,3);

Z = Pz;
M = [Px Py ones(length(Px),1)];
K = (M'*M)\M'*Z;

a = K(1);
b = K(2);
c = K(3);

% normal vector
n = [-a -b 1]';

%% test plot
xrange = min(Px)-10:max(Px)+10;
yrange = min(Py)-10:max(Py)+10;
[x y] = meshgrid(xrange, yrange);
z = a.*x + b.*y + c;
surf(x,y,z,'FaceAlpha',0.5);
hold on;
plot3(Px, Py, Pz,'r*');

%% circle fitting
zeta = atan2(b,a);
gamma = acos(1/sqrt(a^2+b^2+1));
P = (rot('y',gamma)*rot('z',-zeta)*P')'; % rotation to x-y plane
%%
guess = 10; % initial guess of radius
G_init = [P(1,:)+1 guess]'; % G = [u; v; w; r] (4x1) (u:x|v:y|w:z|r:radius)

G_opt = circleLM(300, P, G_init);

Q_opt = [G_opt(1:2); mean(Pz)];
plot3(G_opt(1),G_opt(2), G_opt(3), 'b*');
hold on;

%% using mean pos to plot center
Px_m = (max(Px)+min(Px))/2;
Py_m = (max(Py)+min(Py))/2;
Pz_m = (max(Pz)+min(Pz))/2;
r_m = vecnorm([max(Px); max(Py); max(Pz)] - [Px_m; Py_m; Pz_m]);
G_m = [Px_m; Py_m; Pz_m; r_m];
plot3(Px_m, Py_m, Pz_m, 'g*');
hold on;

[E_m, e_m] = residualErr(P, G_m);
%% Verify radius
[E_o, e_o] = residualErr(P, G_opt);

%% plot normal vector
%quiver3(Px(1), Py(1), Pz(1), Px(3), Py(3), Pz(3), 'blue')
quiver3(Px_m, Py_m, Pz_m, 10*n(1), 10*n(2), 10*n(3), 'blue')
hold on

%% Functions
% calculates residual error of circle parameters
function [E, e] = residualErr(P, G)
    G_fill = repmat(G, 1, size(P,1)); % makes G_fill same size as P
    e_r = vecnorm(P'-G_fill(1:3,:)) - G(4);  % error of radius
    E = e_r';
    e = E'*E;
end

function J = Jacob(P, G, E)
    Jx = -(P(:,1) - G(1))./(E+G(4));
    Jy = -(P(:,2) - G(2))./(E+G(4));
    Jz = -(P(:,3) - G(3))./(E+G(4));
    Jo = -ones(size(Jz));
    J = [Jx Jy Jz Jo]; % (i * 4)
end

function G_opt = circleLM(iter, P, G)
    % P: [Px, Py, Pz] (m x 3)
    % G:
    [E, e] = residualErr(P, G);
    % calculate Jacobian
    J_old = Jacob(P, G, E);
    
    G_old = G;
    E_old = E;
    e_old = e;

    X = 10;
    for i = 1:iter
        lambda = 0.00001;
        for j = 1:iter
            G_new = G_old - (J_old'*J_old + lambda*eye(4)) \ J_old'*E_old;
            [E_new, e_new] = residualErr(P, G_new);
            lambda = X*lambda;
            if e_new < e_old
                break
            end
        end
        if e_new < e_old
            G_old = G_new;
            [E_old, e_old] = residualErr(P, G_old);
            J_old = Jacob(P, G_old, E_old);
        end
    end
    G_opt = G_old;
    

end