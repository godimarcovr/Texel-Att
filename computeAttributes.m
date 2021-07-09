clear all;
addpath('ColorNaming');

imgs_all = dir(fullfile(pwd, 'images', '*.jpg'));
data_files_folder = '<detection_file_path>';
attr_files_folder = 'attributes';

step = 100;
attributes = cell(1,numel(imgs_all));
for s=1:step:numel(imgs_all)
    parfor i = s:min(numel(imgs_all),s+step-1)
        img_path = fullfile(imgs_all(i).folder,imgs_all(i).name);
        img = imread(img_path);
        classname = strsplit(imgs_all(i).name,'-');
        classname = classname{1};
        name = replace(imgs_all(i).name,'.jpg','');
        data_file_path = fullfile(data_files_folder,[name,'.mat']);
        data = load(data_file_path);
        
        attributes{i}.name_img = name;
        
        attributes{i}.classname = classname;
        
        attributes{i}.area = compute_areas_attr_fn(data.masks);
        
        if size(data.boxes) == 0
            continue;
        end
   
        attributes{i}.aspect_ratios = compute_aspectratios_attr_fn(data.boxes);
        
        attributes{i}.colors = compute_dominantcolors_attr_fn(data.masks,img);
        
        attributes{i}.background_colors = compute_dominantbgcolors_attr_fn(data.masks,img);
        
        attributes{i}.orientations = compute_orientations_attr_fn(data.masks);
        
        attributes{i}.homogeneity = compute_homogeneity_attr_fn(img,data.masks);
        
        attributes{i}.local_simmetry = compute_r0_attr_fn(data.boxes,img,4);
        
        attributes{i}.traslation_simmetry = compute_t_attr_fn(data.boxes,img,4);
        
        attributes{i}.traslation_histogram = compute_traslisto_attr_fn(data.boxes,img);
        

    end
    for i = s:min(numel(imgs_all),s+step-1)
        attr = attributes{i};
        save(fullfile(pwd,attr_files_folder,[attributes{i}.name_img,'.mat']),'attr');
    end
    
end

