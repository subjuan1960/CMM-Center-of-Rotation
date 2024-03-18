function [P,E] = outFilter(P, G)
    % P = [Px Py Pz];
    % use residualErr to find E = [e1; e2; ... em]
    % sort E in ascending order and remove the one with largest error
    [E, ~] = residualErr(P,G);

    % Median absolute deviation ( median|x - median(x)| )
    e_med = median(E);
    E_diff = abs(E - e_med);
    MAD = median(E_diff); 

    % find positions in E_diff that does not satisfy cond and delete
    % in both E_diff and P

    % Outlier if : |e_i - median(E)| >= c * sigma
    sig = MAD / 0.6745; % refer to Huber 1981 for 0.6745
    c = 2.1; % constant in range of 2-3
    cond = c * sig;
    del_idx = find(E_diff >= cond);
    for i = del_idx
        E(i) = [];
        P(i,:) = [];
    end
end