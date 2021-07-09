function attrs = computeAggregatePerData(raw_attrs)
    
     if isfield(raw_attrs, 'background_colors')
         attrs.bg_color = aggregate_attribute_fn(raw_attrs.background_colors, 'hist', 1:12);
         
         attrs.classes = aggregate_attribute_fn(raw_attrs.classname,'hist',1:4);
     end
    
    attrs.area = aggregate_attribute_fn(raw_attrs.area);
    
    attrs.aspect_ratio = aggregate_attribute_fn(raw_attrs.aspect_ratios);
    
    attrs.orientation = aggregate_attribute_fn(raw_attrs.orientations, 'hist', [(-5) (5) (85) (95) (175) (185)]);
    if ~isnan(attrs.orientation)
        attrs.orientation = [attrs.orientation(1) + attrs.orientation(5), attrs.orientation(2) + attrs.orientation(4), attrs.orientation(3)];
        attrs.orientation = (attrs.orientation ./ [10 160 10]);
        attrs.orientation = attrs.orientation ./ sum(attrs.orientation);
    else
        attrs.orientation = [nan nan nan];
    end
    attrs.color = aggregate_attribute_fn(raw_attrs.colors, 'hist', 1:12);
    
    attrs.homogeneity = aggregate_attribute_fn(raw_attrs.homogeneity);
    
    attrs.r0 = aggregate_attribute_fn(raw_attrs.local_simmetry);
    
    attrs.t = aggregate_attribute_fn(raw_attrs.traslation_simmetry);
    
    tmp_trasl_isto = aggregate_attribute_fn(raw_attrs.traslation_histogram, 'hist2d');
    if isstruct(tmp_trasl_isto)
        attrs.th = aggregate_attribute_fn(tmp_trasl_isto.orientations, 'hist', [deg2rad(-5) deg2rad(5) deg2rad(85) deg2rad(95) deg2rad(175) deg2rad(185)]);
        attrs.th = [attrs.th(1) + attrs.th(5), attrs.th(2) + attrs.th(4), attrs.th(3)];
        attrs.th = (attrs.th ./ [10 160 10]);
        attrs.th = attrs.th ./ sum(attrs.th);
    else
        attrs.th = [nan nan nan];
    end
end

