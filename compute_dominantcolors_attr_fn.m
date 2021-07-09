function [dominant_colors] = compute_dominantcolors_attr_fn(masks, img)
%masks: NxRxC
%img RxCx3
persistent w2c;

if isempty(w2c)
    load('w2c.mat');
end

cimg = im2c(double(img), w2c, 0);

dominant_colors = zeros(size(masks, 1), 1);

for i=1:size(masks, 1)
    cimg_cut = cimg(masks(i, :, :) > 0);
    dominant_colors(i) = mode(cimg_cut(:));
end


end

