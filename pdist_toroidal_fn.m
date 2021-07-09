function dists = pdist_toroidal_fn(coords2, imgsize, coords)
if nargin < 3
    coords = coords2;
end

h = imgsize(1);
w = imgsize(2);
new_coords = [coords2; 
    coords2 + [0 -h]; 
    coords2 + [w -h];
    coords2 + [w 0];
    coords2 + [w h];
    coords2 + [0 h];
    coords2 + [-w h];
    coords2 + [-w 0];
    coords2 + [-w -h];
    ]; 
new_dists = pdist2(coords, new_coords);
n_points = size(coords2, 1);
dists = new_dists(:, 1:n_points);
for f=2:9
    dists = min(dists, new_dists(:, (n_points * (f - 1)) + 1: n_points * f));
end

end

