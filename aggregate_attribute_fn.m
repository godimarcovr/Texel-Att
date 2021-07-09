function aggregated = aggregate_attribute_fn(attributes, mode, bins)
%attributes: Nx1

if nargin < 2
    mode = 'meanstd'; %else 'histogram'
end

if strcmp(mode, 'hist') && nargin < 3
    bins = linspace(min(attributes, [], 1), max(attributes, [], 1), 4);
end

if any(isnan(attributes))
    if strcmp(mode, 'meanstd') 
        aggregated = [nan nan];
        return;
    end
    if strcmp(mode, 'hist') 
        aggregated = repmat([nan],1,numel(bins)-1);
        return;
    end
    aggregated = nan;
    return
end

if numel(size(attributes)) > 2
    return
end

if size(attributes, 1) == 1
    attributes = attributes';
end

switch mode
    case 'meanstd'
        aggregated = [mean(attributes, 1) std(attributes, 1)];
    case 'hist'
        aggregated = histcounts(attributes(:, 1), bins) ./ numel(attributes(:, 1));
    case 'hist2d'
        if size(attributes, 2) < 2
            attributes = reshape(attributes, [1 2]);
        end
        assert(size(attributes, 2) == 2);
        if size(attributes, 1) > 20000
            randinds = randperm(size(attributes, 1));
            attributes = attributes(randinds(1:20000), :);
        end
        
        dists1 = pdist(attributes(:, 1));
        dists2 = pdist(attributes(:, 2));
        
        aggregated.orientations = zeros(size(attributes, 1), 1);
        offset_x = max(- ceil(min(attributes(:, 1))), 0) + 1;
        hough_counts = zeros(ceil(max(attributes(:, 2))), ceil(max(attributes(:, 1))) + offset_x);
        for i=1:size(attributes, 1)
%             hough_counts(ceil(attributes(i, 2)), ceil(attributes(i, 1)) + offset) = hough_counts(ceil(attributes(i, 2)), ceil(attributes(i, 1)) + offset) + 1;
            aggregated.orientations(i) = atan2(attributes(i, 2), attributes(i, 1));
        end
%         gfilter = fspecial('gaussian', 40, 10);
%         aggregated.hist2d = imfilter(hough_counts, gfilter);
%         aggregated.offset = offset;
end
    
end

