function [areas] = compute_areas_attr_fn(masks)
% masks: NxRxC
areas = zeros(size(masks, 1), 1);
for i=1:size(masks, 1)
    areas(i) = sum(sum(masks(i, :, :) > 0));
end
end

