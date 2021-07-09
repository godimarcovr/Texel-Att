clear all

files = dir(fullfile(pwd,'attributes','*.mat'));
dest_folder = 'attributes-aggregate-pred';
raw_attrs = cell(1, size(files, 1));
wb = waitbar(0.0, 'Loading data...');
for i=1:size(files, 1)
    tmp = load(fullfile(files(i).folder, files(i).name));
    raw_attrs{i} = tmp.attr;
    waitbar(i/size(files, 1), wb);
end
close(wb);

attrs = cell(1, numel(raw_attrs));
wb = waitbar(0.0, 'Data Aggregation...');
parfor i=1:numel(raw_attrs)
   i
   attrs{i} = computeAggregatePerData(raw_attrs{i});

   attrs{i}.circle = computeAggregatePerData(raw_attrs{i}.circle);

   attrs{i}.line = computeAggregatePerData(raw_attrs{i}.line);

   attrs{i}.polygon = computeAggregatePerData(raw_attrs{i}.polygon);

   attrs{i}.name_img = raw_attrs{i}.name_img;
   %waitbar(i/size(raw_attrs, 2), wb);
end
close(wb);

wb = waitbar(0.0, 'Saving data...');
for i=1:numel(attrs)
   attr = attrs{i};
   save(fullfile(pwd,dest_folder,[attrs{i}.name_img,'.mat']),'attr','-v7.3');
   waitbar(i/size(attrs, 2), wb);
end
close(wb);


attr_matrix  = zeros(numel(attrs),102);
attrs_names = fieldnames(attrs{1}.circle)';
global_attrs_names = {'classes','bg_color'};
labels = cell(1,102);
c = 1;
wb = waitbar(0.0, 'Matrix creation...');
for i=1:numel(attrs)
    tmp_row = [];
    
    for g=global_attrs_names
        g = g{1};
        tmp_row = [tmp_row attrs{i}.(g)];
        if i==1
            for j = 1:size(attrs{i}.(g),2)
                labels(c) = {g};
                c = c+1;
            end
        end
    end
    
    for a = attrs_names
        a = a{1};
        if size(attrs{i}.(a)(:)',2) == 2
            attrs{i}.(a) = attrs{i}.(a)(1);
            
        end
        tmp_row = [tmp_row attrs{i}.(a)(:)'];
        if i==1
            for j = 1:size(attrs{i}.(a)(:)',2)
                labels(c) = {a};
                c = c+1;
            end
        end
        
    end
    for a = attrs_names
        a = a{1};
        if size(attrs{i}.circle.(a)(:)',2) == 2
            attrs{i}.circle.(a) = attrs{i}.circle.(a)(1);
        end
        tmp_row = [tmp_row attrs{i}.circle.(a)(:)'];
        if i==1
            for j = 1:size(attrs{i}.(a)(:)',2)
                labels(c) = strcat('circle-',{a});
                c = c+1;
            end
        end
    end
    for a = attrs_names
        a = a{1};
        if size(attrs{i}.line.(a)(:)',2) == 2
            attrs{i}.line.(a) = attrs{i}.line.(a)(1);
        end
        tmp_row = [tmp_row attrs{i}.line.(a)(:)'];
        if i==1
            for j = 1:size(attrs{i}.(a)(:)',2)
                labels(c) = strcat('line-',{a});
                c = c+1;
            end
        end
    end
    for a = attrs_names
        a = a{1};
        if size(attrs{i}.polygon.(a)(:)',2) == 2
            attrs{i}.polygon.(a) = attrs{i}.polygon.(a)(1);
        end
        tmp_row = [tmp_row attrs{i}.polygon.(a)(:)'];
        if i==1
            for j = 1:size(attrs{i}.(a)(:)',2)
                labels(c) = strcat('polygon-',{a});
                c = c+1;
            end
        end
    end
    attr_matrix(i,:) = tmp_row;
    waitbar(i/size(attrs, 2), wb);
end
close(wb);

save('matrixAttributesAntonPred.mat','attr_matrix','labels','-v7.3');
















