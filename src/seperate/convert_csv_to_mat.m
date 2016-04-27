clear;
clc;
fid = fopen('historydata_node_10_trans.csv');
%fid = fopen('temp.csv');
data = textscan(fid, '%[^\n]');
len = length(data{1});
width = 20;
block_size = 10000;
data_mat = cell(len, width);
j = 1 - block_size;
for i = 1 : len
    data{1}{i} = strcat(data{1}{i}, '\N');
    data_tmp = textscan(data{1}{i}, '%s', 'delimiter', ',');
    for k = 1 : min(width, length(data_tmp{1, 1}))
        data_mat{i,k} = data_tmp{1, 1}{k};
    end
    if mod(i, block_size) == 0
        data_block = cell(block_size, width);
        j = i - block_size + 1;
        for j1 = 1 : block_size
            for i1 = 1 : width
                data_block{j1, i1} = data_mat{j + j1 -1, i1};
            end
        end
        save(['~/datasets/hangzhoujiahe/treated_data/historydata_node_10_trans_', num2str(j), '_to_', num2str(i) ,'.mat'], 'data_block', '-v7.3');
        display(['~/datasets/hangzhoujiahe/treated_data/historydata_node_10_trans_', num2str(j), '_to_', num2str(i) ,'.mat', ' saved successfully!']);
    end
end

j = j + block_size;
if j ~= len
    data_block = cell(len - j + 1, width);
    for j1 = 1 : len - j + 1
        for i1 = 1 : width
            data_block{j1, i1} = data_mat{j + j1 -1, i1};
        end
    end
    save(['~/datasets/hangzhoujiahe/treated_data/historydata_node_10_trans_', num2str(j), '_to_', num2str(len) ,'.mat'], 'data_block', '-v7.3');
    display(['~/datasets/hangzhoujiahe/treated_data/historydata_node_10_trans_', num2str(j), '_to_', num2str(len) ,'.mat', ' saved successfully!']);
end

save(['~/datasets/hangzhoujiahe/treated_data/historydata_node_10_trans.mat'], 'data_mat', '-v7.3');
display(['~/datasets/hangzhoujiahe/treated_data/historydata_node_10_trans.mat saved successfully!']);