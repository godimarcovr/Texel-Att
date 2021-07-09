function [cimg_cut] = compute_dominantbgcolors_attr_fn(masks, img)
%masks: NxRxC
%img RxCx3
persistent w2c;

if isempty(w2c)
    load('w2c.mat');
end

cimg = im2c(double(img), w2c, 0);
cimg_cut = cimg(sum(masks,1) == 0);

end

