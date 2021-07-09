function homogeneity = compute_homogeneity_attr_fn(img,masks)
%HOMOGENEITY Summary of this function goes here
%   Detailed explanation goes here
warning off;

N = 10;
size_w = size(img,1)/N;
size_h = size(img,2)/N;
P = zeros(N,N);
centroids = zeros(size(img,1),size(img,2));
for i = 1:size(masks,1)
    mask = squeeze(masks(i,:,:));
    if max(mask(:)) == 0
        continue;
    end
    st = regionprops(mask);
    if size(st,1) > 1
        tmp = vertcat(st.Area);
        [~,ind] = max(tmp);
        st = st(ind);
    end
    centroids(ceil(st.Centroid(1)),ceil(st.Centroid(2))) = 1;
end
for ii=1:N
    for jj = 1:N
        P(ii,jj) = sum(sum(centroids(size_w*(ii-1)+1:size_w*(ii),size_h*(jj-1)+1:size_h*(jj))>0));
         P(ii,jj) =  P(ii,jj);
    end
end
homogeneity = ((P(:) - (size(masks,1))).^2)./size(masks,1);
%homogeneity = 1-tmp_omog;
% imagesc(centroids);
% waitforbuttonpress;

end

