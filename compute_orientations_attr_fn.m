function orientations = compute_orientations_attr_fn(masks)
%masks: NxRxC
orientations = zeros(size(masks, 1), 1);

for i=1:size(orientations, 1)
    tmp_mask = squeeze(masks(i, :, :));
    if max(tmp_mask(:)) == 0
        orientations(i) = nan;
        continue;
    end
    tmp_props = regionprops(tmp_mask, 'Orientation');
    orientations(i) = tmp_props.Orientation;
end

orientations = orientations(~isnan(orientations));

end

