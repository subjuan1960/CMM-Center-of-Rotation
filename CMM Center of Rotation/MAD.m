function [P] = outFilter(P, G)
    % P = [Px Py Pz];
    % use residualErr to find E = [e1; e2; ... em]
    % sort E in ascending order and remove the one with largest error
    [E, ~] = residualErr(P,G);
    e_med = median(E);
    E_diff = abs(E - e_med);

    % find positions in E_diff that does not satisfy cond and delete
    % in both E_diff and P
    cond = c * 

end