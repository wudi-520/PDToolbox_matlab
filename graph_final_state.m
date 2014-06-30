function z = graph_final_state()

global G

cc=hsv(G.P);
n = max(G.S);
figure(12)
clf 
hold on

x = vec2mat(G.X(end, :), max(G.S));

for p = 1 : G.P
    plot(1:1:G.S(p), x(p, :), 'color', cc(p, :))
end

hold off
