function at = computeAttributePerData(data,img)
%COMPUTEATTRIBUTEPERDATA Summary of this function goes here
%   Detailed explanation goes here
        if size(data.boxes,2) > 0
            at.area = compute_areas_attr_fn(data.masks);

            at.aspect_ratios = compute_aspectratios_attr_fn(data.boxes);

            at.colors = compute_dominantcolors_attr_fn(data.masks,img);

            at.orientations = compute_orientations_attr_fn(data.masks);

            at.homogeneity = compute_homogeneity_attr_fn(img,data.masks);

            at.local_simmetry = compute_r0_attr_fn(data.boxes,img,4);

            at.traslation_simmetry = compute_t_attr_fn(data.boxes,img,4);

            at.traslation_histogram = compute_traslisto_attr_fn(data.boxes,img);
        else
            at.area = nan;

            at.aspect_ratios = nan;
            
            at.colors = nan;

            at.orientations = nan;

            at.homogeneity = nan;

            at.local_simmetry = nan;

            at.traslation_simmetry = nan;

            at.traslation_histogram = nan;
        end
end

