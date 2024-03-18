function [Q_opt, P_opt, K, r] = rotCenter(iter, P, G)
% Outputs: Q_opt, P_opt, K, r
% Q_opt: optimal location of center
% P_opt: optimal data points post-filtering
% K: coefficients of the plane in which the circular data lie
% r: radius of circle

% Inputs: iter, P, G
% iter: number of iterations specified for LM
% P: [Px Py Pz] (m x 3) position data
% G: [u; v; w; r] (4 x 1) guess of rot center 
    
    K = makePlane(P);
    a = K(1);
    b = K(2);
    c = K(3);

    % normal vector
    n = [-a -b 1]';

    %% plane rotation angles
    zeta = atan2(b,a);
    gamma = acos(1/sqrt(a^2+b^2+1));

    % transform data onto xy-plane
    P = (roty(gamma)*rotz(-zeta)*P')';
    %% plot transformed data points
    figure()
    plot(P(:,1), P(:,2), '*')
    xlabel('X');
    ylabel('Y');
    grid on
    hold on
    axis equal

    %% circle fitting
    G_old = roty(gamma)*rotz(-zeta)*G(1:3);
    G_old = [G_old(1:2); G(4)];
    [E_old e_old] = residualErr(P, G_old);
    
    J_old = Jacob(P,G,E_old);

    X = 10;
    flag = 1;
    while flag
        for i = 1:iter % could change into while loop to check for e
            lambda = 0.00001;
            for j = 1:iter
                G_new = G_old - (J_old'*J_old + lambda*eye(3)) \ J_old'*E_old;
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
        
        temp_len = length(P);

        [P,E] = outFilter(P, G_old); % filter outlier and reduce P, E
        E_old = E;
        J_old = Jacob(P, G_old, E_old);

        if temp_len == length(P)
            flag = 0;
            G_opt = G_old;
        end
    end
    
    plot(P(:,1), P(:,2), 'r.');
    % plotting 
    plot(G_opt(1),G_opt(2),'g*');

    r = G_opt(3);
    Q_opt = [G_opt(1); G_opt(2); mean(P(:,3))];
    Q_opt = rotz(zeta)*roty(-gamma)*Q_opt;
    P_opt = (rotz(zeta)*roty(-gamma)*P')';
    
    % Plot
    % figure()
    % plot3(P(1,:),P(2,:),P(3,:),'.')
    % xlabel('x');
    % ylabel('y');
    % zlabel('z');
    % grid on
    % hold on
    % plot3(Q_opt(1),Q_opt(2),Q_opt(3),'r*')
    % quiver3(Q_opt(1),Q_opt(2),Q_opt(3),100*n(1),100*n(2),100*n(3))
    % grid on 
    % hold on
    % axis equal
    
end