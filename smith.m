function dz = smith(t,z)

global G

% extract matrix of strategies
n = max(G.S);
x_n = vec2mat(z, n);
x = zeros(G.P, n);

diff = zeros(G.P, n, n);
F_excess_a = zeros(G.P, n);
F_excess_b = zeros(G.P, n);

x_dot_v = zeros(G.P* n, 1);

for p = 1 : G.P
    x(p, :) = x_n(p, :) * G.m(p);
end

% calculate fitness of each strategy
F = zeros(G.P, n);
F_order = zeros(G.P, n);

for p = 1 : G.P
    for s = 1 : G.S(p)
        F(p, s) = G.f(x, p, s) ;
    end
    
    % order the strategies by their fitness
    [A, B] = sort( F( p, 1:G.S(p) ) );
    F_order( p, 1:G.S(p) ) = B;

    % create a matrix with values of the difference
    for i=2:G.S(p)
        for j=1:i-1
            ith = F_order(p, i);
            jth = F_order(p, j);
            diff(p,i,j) = F(p,ith) - F(p,jth);
        end
    end
   
    
   for i=1:G.S(p)
       k = F_order(p, i);
       for g = 1: i-1
           gamma = F_order(p, g);
           F_excess_a(p, k) = F_excess_a(p, k) + x(p, gamma) * diff(p, i, g);
       end
       
       for g = i+1: G.S(p)
           F_excess_b(p, k) = F_excess_b(p, k) + diff(p, g, i);
       end 
   end
    
end

% calculate update in the strategy
for p = 1 : G.P
    for s = 1 : G.S(p)
        x_dot_v( (p-1)*n + s) = F_excess_a(p, s) - F_excess_b(p,s) * x_n(p, s);
    end
end

dz = [x_dot_v];

