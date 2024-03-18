function [Q, N, check] = planeIntersect(coeff_1, coeff_2)
    % Q : A point on the intersecting line of 2 planes
    % N : Directional vector of intesecting line

    % for plane: z = ax + by + c
    % coeff = [a b c]
    a1 = coeff_1(1);
    b1 = coeff_1(2);
    c1 = coeff_1(3);
    p1 = [0; 0; c1]; % a point on Plane 1


    a2 = coeff_2(1);
    b2 = coeff_2(2);
    c2 = coeff_2(3);
    p2 = [0; 0; c2]; % a point on Plane 2

    n1 = [-a1; -b1; 1]; % normal vector of Plane 1
    n2 = [-a2; -b2; 1]; 

    N = cross(n1, n2);  % vector of the intersecting line
    v21 = p1 - p2; % vector from point 2 to point 1

    if norm(N) < 1e-6 % two planes are near parallel
        if (dot(n1, v21) == 0)
            check = 1;  % Planes coincide
            print("Planes Coincide");
            return
        else
            check = 0;  % Planes disjoint
            print("Planes Disjoint");
            return
        end
    end
    
    check = 2; % Planes intersect

    maxc = find(abs(N) == max(abs(N))); % position for max coordinate

    d1 = -dot(n1, p1);
    d2 = -dot(n2, p2);

    switch maxc
        case 1                                  % when x = 0
            q1 = 0;
            q2 = (d2*n1(3) - d1*n2(3))/ N(1);
            q3 = (d1*n2(2) - d2*n1(2))/ N(1);
        case 2                                  % when y = 0
            q1 = (d1*n2(3) - d2*n1(3))/ N(2);
            q2 = 0;
            q3 = (d2*n1(1) - d1*n2(1))/ N(2);
        case 3                                  % when z = 0
            q1 = (d2*n1(2) - d1*n2(2))/ N(3);
            q2 = (d1*n2(1) - d2*n1(1))/ N(3);
            q3 = 0;
    end
    
    Q = [q1; q2; q3];   % point on the intersecting line
end