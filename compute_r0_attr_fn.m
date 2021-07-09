function [symm_dists] = compute_r0_attr_fn(boxes, img, n_neighbors, avg_angle)
if nargin < 3
    n_neighbors = 4;
end
coords = boxes(:, 1:2) + (boxes(:, 3:4) ./ 2);
opts.imsize = size(img(:, :, 1));
opts.wh = opts.imsize(2:-1:1);

if size(coords, 1) < 10
    symm_dists = nan;
    return
end

while size(coords, 1) > 750
    opts.imsize = ceil(3 * size(img(:, :, 1)) / 4);
    opts.wh = opts.imsize(2:-1:1);
    img = img(1:opts.imsize(1), 1:opts.imsize(2), :);
    coords = coords(coords(:, 1) < opts.wh(1) & coords(:, 2) < opts.wh(2), :);
end

if exist('avg_angle', 'var')
    avg_angle_rad = (avg_angle * 2 * pi) / 360.0;
    s = sign(avg_angle_rad);
    if s == 0
        s = 1;
    end
    perp_angle_rad = avg_angle_rad - (pi / 2) * s;
    coords = [coords * [cos(perp_angle_rad); sin(perp_angle_rad)] zeros(size(coords, 1), 1)];
end

% dists = squareform(pdist(coords));
dists = pdist_toroidal_fn(coords, opts.imsize);
k = n_neighbors;
symm_scores = [];
for p=1:size(coords, 1)
    p_coord = coords(p, :);
    [neigh_dists, neigh_inds] = sort(dists(p, :));
    neigh_inds = neigh_inds(2:k+1);
    neigh_dists = neigh_dists(2:k+1);
    binds_no_p = true(1, size(coords, 1));
    binds_no_p(p) = false;
    allother_dists_all = inf(k, size(coords, 1));
    count = 0;
    for p2=neigh_inds
        count = count + 1;
        binds_no_pp2 = binds_no_p;
        binds_no_pp2(p2) = false;
        p2_coord = coords(p2, :);
        diff_vect = p2_coord - p_coord;
        inv_diff_vect = -diff_vect;
        symm_coord = p_coord + inv_diff_vect;
        allother_coords = coords;
        allother_coords([p, p2], :) = [];
        symm_coord = mod(symm_coord, opts.wh); %toroidale
%         allother_dists = pdist2(symm_coord, allother_coords);
        allother_dists_all(count, binds_no_pp2) = pdist_toroidal_fn(allother_coords, opts.imsize, symm_coord);
%         symm_scores = [symm_scores min(allother_dists(:))];
    end
    
    np_assign = 0;
    while np_assign < k
        [dist_val, dist_ind] = min(allother_dists_all(:));
        [dist_r, dist_c] = ind2sub(size(allother_dists_all), dist_ind);
        symm_scores = [symm_scores dist_val];
        allother_dists_all(dist_r, :) = [];
        allother_dists_all(:, dist_c) = [];
        np_assign = np_assign + 1;
    end
end

sorted_dists = sort(dists, 2);
mean_neigh_dist = mean(sorted_dists(:, 2));

symm_dists = symm_scores./ mean_neigh_dist;
%symm_score = symm_score ./ norm(opts.imsize);
end

