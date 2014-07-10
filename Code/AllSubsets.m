%% Back to Main
% * <file:///Users/sumangiri/Desktop/FSM/Code/Energy%20estimation%20v2/html/main_file_v2.html Back to Main>

function S = AllSubsets(V)
% 9/4/04: [Reza Mahani]

% Lists all subsets of a set given by the vector V of length

% Assumption: No "nan" in V.

% I use a "recursive" algorithm, AllSubsets call itself on
%one-element-smaller subsets.

% CALL: S = AllSubsets(V)

[m n] = size(V);

V=V(:)';

S = nan*zeros(2^n,n); % initialization

%

i0 = 1;

%

if max(m,n)==1

    S(i0,:) = V;

    return

end

if n==2

    S(i0:i0+2,:) = [V ; V(1) nan ; nan V(2)];

    return

end

for i=1:(n-1)

    S1 = AllSubsets(V(i+1:n));

    S(i0:i0+2^(n-i)-1,i:n) = [ones(2^(n-i),1)*V(i) , S1];

    i0 = i0 + 2^(n-i);

end

S(i0,n) = V(n);

return 