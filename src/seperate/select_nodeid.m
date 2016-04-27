clc;
clear;


save_path = '/home/star/datasets/hangzhoujiahe/parted_nodeid_idx/';


data_block_int = cell(50000, 20);
load('/home/star/datasets/hangzhoujiahe/treated_data/historydata_node_10_trans_1_to_10000.mat');
display('/home/star/datasets/hangzhoujiahe/treated_data/historydata_node_10_trans_1_to_10000.mat loaded!');
for i = 1 : 10000
    for j = 1 : 20
        data_block_int{i, j} = data_block{i, j};
    end
end
load('/home/star/datasets/hangzhoujiahe/treated_data/historydata_node_10_trans_10001_to_20000.mat');
display('/home/star/datasets/hangzhoujiahe/treated_data/historydata_node_10_trans_10001_to_20000.mat loaded!');
for i = 1 : 10000
    for j = 1 : 20
        data_block_int{10000 + i, j} = data_block{i, j};
    end
end
load('/home/star/datasets/hangzhoujiahe/treated_data/historydata_node_10_trans_20001_to_30000.mat');
display('/home/star/datasets/hangzhoujiahe/treated_data/historydata_node_10_trans_20001_to_30000.mat loaded!');
for i = 1 : 10000
    for j = 1 : 20
        data_block_int{20000 + i, j} = data_block{i, j};
    end
end
load('/home/star/datasets/hangzhoujiahe/treated_data/historydata_node_10_trans_30001_to_40000.mat');
display('/home/star/datasets/hangzhoujiahe/treated_data/historydata_node_10_trans_30001_to_40000.mat loaded!');
for i = 1 : 10000
    for j = 1 : 20
        data_block_int{30000 + i, j} = data_block{i, j};
    end
end
load('/home/star/datasets/hangzhoujiahe/treated_data/historydata_node_10_trans_40001_to_50000.mat');
display('/home/star/datasets/hangzhoujiahe/treated_data/historydata_node_10_trans_40001_to_50000.mat loaded!');
for i = 1 : 10000
    for j = 1 : 20
        data_block_int{40000 + i, j} = data_block{i, j};
    end
end

nodeid = {data_block_int{:,2}}';
nodeid_uni = unique(nodeid);
len_sample = size(data_block_int, 1);
len_nodeid = size(nodeid_uni, 1);

idx = cell(len_nodeid, 1);

for i = 1 : len_nodeid
    idx{i} = [];
    for j = 1 : len_sample
        if strcmp(data_block_int{j, 2}, nodeid_uni{i})
            idx{i} = [idx{i}; j];
        end
    end
end
save([save_path, 'historydata_node_10_trans_part_info.mat'], 'idx', 'nodeid_uni', '-v7.3');
display('historydata_node_10_trans_part_info.mat saved!');

for i = 1 : len_nodeid
   data_sub = cell(length(idx{i}), 20);
   data_nodeid = nodeid_uni{i};
   for j = 1 : length(idx{i})
       for k = 1 : 20
           data_sub{j, k} = data_block_int{idx{i}(j), k};
       end
   end
   save([save_path, 'historydata_node_10_trans_', nodeid_uni{i}, '.mat'], 'data_sub', 'data_nodeid', '-v7.3');
   display([save_path, 'historydata_node_10_trans_', nodeid_uni{i}, '.mat saved!']);
end

