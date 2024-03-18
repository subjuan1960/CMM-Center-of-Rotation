function [E, e] = residualErr(P, G)
% Outputs: E, e
% E: [e1; e2; ... em] (m x 1) Error vector with radius
% e: error function of least squares in matrix form

% Inputs: P, G
% P: [Px Py Pz] (m x 3) position data
% G: [u; v; w; r] (4 x 1) guess of rot center 

    G_fill = repmat(G, 1, size(P,1)); % makes G_fill same size as P
    P = P';
    e_r = vecnorm(P(1:2,:) - G_fill(1:2,:)) - G(3);  % error of radius
    E = e_r';
    e = E'*E;
end
