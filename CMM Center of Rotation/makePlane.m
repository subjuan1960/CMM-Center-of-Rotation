function K = makePlane(P)
    % P : position data [x y z] (n x 3)
    % K : coefficients for plane [a; b; c] (z = ax + by + c)
    Px = P(:,1);
    Py = P(:,2);
    Pz = P(:,3);
    Z = Pz;
    M = [Px Py ones(length(Px),1)];
    K = (M'*M)\M'*Z;
end