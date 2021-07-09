function [symm_dists] = compute_t_attr_fn(boxes, img, n_neighbors,avg_angle)
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

for p1=1:size(coords, 1)
    p1_coord = coords(p1, :);
    [neigh1_dists, neigh1_inds] = sort(dists(p1, :));
    %k vicini di p1
    neigh1_inds = neigh1_inds(2:k+1);
    neigh1_dists = neigh1_dists(2:k+1);
    neigh1_coords = coords(neigh1_inds, :);
    for p2=1:size(coords, 1)
        if p1 == p2
            continue
        end
        p2_coord = coords(p2, :);
        
        diff_vectp1_to_p2 = p2_coord - p1_coord;
        neigh1_to_p2_coord = neigh1_coords + diff_vectp1_to_p2;
        neigh1_to_p2_coord = mod(neigh1_to_p2_coord, opts.wh);
        allother_coords = coords;
        allother_coords(p2, :) = [];
        allother_dists = pdist_toroidal_fn(allother_coords, opts.imsize, neigh1_to_p2_coord);
        
        np12_assign = 0;
        while np12_assign < k
            [dist_val, dist_ind] = min(allother_dists(:));
            [dist_r, dist_c] = ind2sub(size(allother_dists), dist_ind);
            symm_scores = [symm_scores dist_val];
            allother_dists(dist_r, :) = [];
            allother_dists(:, dist_c) = [];
            np12_assign = np12_assign + 1;
        end
        
        
%         [~, np12_inds] = min(allother_dists, [], 1);
%         [~, allother_inds] = sort(allother_dists, 2);
%         np12_inds(allother_inds)
        
        symm_scores= [symm_scores; min(allother_dists, [], 2)];
        
    end
end

sorted_dists = sort(dists, 2);
mean_neigh_dist = mean(sorted_dists(:, 2));

symm_dists = symm_scores./ mean_neigh_dist;
%symm_score = symm_score ./ norm(opts.imsize);
end

