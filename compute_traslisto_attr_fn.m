function [trasl_isto] = compute_traslisto_attr_fn(boxes, img,avg_angle)
coords = boxes(:, 1:2) + (boxes(:, 3:4) ./ 2);
opts.imsize = size(img(:, :, 1));
opts.wh = opts.imsize(2:-1:1);

if size(coords, 1) < 10
    trasl_isto = nan;
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


% [P1, P2] = meshgrid(1:size(coords, 1), 1:size(coords, 1));
P = nchoosek(1:size(coords, 1), 2); P1 = P(:, 1); P2 = P(:, 2);
trasl_isto = (coords(P1(:), :) - coords(P2(:), :));
trasl_isto(trasl_isto(:, 2) < 0, :) = [];
end

