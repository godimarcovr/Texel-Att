clear all;
files = dir(fullfile('dtd_gt','woven*.mat'));

for i =1:numel(files)
    data_path = fullfile(files(i).folder,files(i).name);
    load(data_path);
    tmp = [];
    if ~iscell(masks)
        continue;
    end
    masks = cat(3,masks{:});
    save(fullfile(files(i).folder,files(i).name),'masks','boxes','-v7.3');
    clear masks boxes tmp
end