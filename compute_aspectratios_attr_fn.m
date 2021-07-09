function [aspect_ratios] = compute_aspectratios_attr_fn(boxes)
%boxes: Nx4
aspect_ratios = boxes(:, 3) ./  boxes(:, 4);
end

