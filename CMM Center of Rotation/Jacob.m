function J = Jacob(P, G, E)
% Output : J
% J: jacobian of error matrix

% Inputs : P, G, E
% P: [Px Py Pz] (m x 3) position data
% G: [u; v; w; r] (4 x 1) guess of rot center 
%     u, v, w is x, y, z pos; r is circle radius
% E: [e1; e2; ... em] (m x 1) Error vector with radius


    Jx = -(P(:,1) - G(1))./(E+G(3));
    Jy = -(P(:,2) - G(2))./(E+G(3));
    Jo = -ones(size(Jx));
    J = [Jx Jy Jo]; % (i * 3)
end