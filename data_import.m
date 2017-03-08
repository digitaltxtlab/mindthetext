kill
wd = '/home/kln/projects/geertz/mystic_anthro/code';
%% vector space
% ## data
dd = '/home/kln/projects/geertz/mystic_anthro/data';
cd(dd)
% import data
data = load('av_gz_data.mat');
dtm_gz = data.dtm_gz;
% geertz
file_gz = csv2cell('geertz_file.txt','fromfile');
    file_gz = strrep(file_gz(2:end,:),' ',''); % remove row and strip whitespace
voc_gz = csv2cell('geertz_voc.txt','fromfile');
    voc_gz = strrep(voc_gz(2:end,:),' ','');
% avila
dtm_av = data.dtm_av;
file_av = csv2cell('avila_file.txt','fromfile');
    file_av = strrep(file_av(2:end,:),' ','');
voc_av = csv2cell('avila_voc.txt','fromfile');
    voc_av = strrep(voc_av(2:end,:),' ','');
clear data
%save('vspc_data.mat')
%%
kill
% metadata for avila and geertz
load('/home/kln/projects/geertz/mystic_anthro/data/vspc_data.mat')
load('/home/kln/projects/geertz/mystic_anthro/data/avila_yr.mat')
tmp = file_av(:,2);
meta_av = cell(length(tmp),2);
for i = 1:length(tmp)
    meta_av(i,:) = strsplit(tmp{i},'_');
    meta_av{i,1} = str2num(meta_av{i,1}); %#ok<ST2NM>
end
tmp = file_gz(:,2);
meta_gz = cell(length(tmp),2);
meta_gz(:,1) = num2cell(1:length(tmp))';
for i = 1:length(tmp)
    %meta_gz(i,:) = strsplit(tmp{i},'_');
    l = regexp(tmp{i},'\d+', 'match'); 
    meta_gz{i,2} = str2num(cell2mat(l(end))); %#ok<ST2NM>
end
% concatenate and sort on year for meta and meta_yr for av
meta_mat_col = {'id' 'sort_id' 'sort_yr'};% column names
[y,i] = sort(meta_av_yr(:,2));
class_av = meta_av(i,2); % class information sorted on year
meta_av_mat = [cell2mat(meta_av(:,1)) cell2mat(meta_av(i,1)) y];
tmp = cell2mat(meta_gz);
[y, i ] = sort(tmp(:,2));
meta_gz_mat = [cell2mat(meta_gz(:,1)) i y];
% check sorting result
subplot(2,1,1), plot(meta_av_mat(:,3)); subplot(2,1,2), plot(meta_gz_mat(:,3));
%save('metadata.mat','meta_gz_mat','meta_av_mat','meta_mat_col')


