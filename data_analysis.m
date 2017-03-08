kill
dd = '/home/kln/projects/geertz/mystic_anthro/data';
load(strcat(dd,'/metadata.mat'))
load(strcat(dd,'/av_gz_sentiment.mat'))

% vectors
x = meta_gz_mat(:,3);
y = sent_gz(meta_gz_mat(:,2),:);
% year average
yr = unique(x);
y_bar = zeros(length(yr),3);
g_sent = sent_gz(meta_gz_mat(:,2),:); % store
for i = 1:length(yr)
    idx = yr(i) == x;
    y_bar(i,1) = nanmean(y(idx));
    y_bar(i,2) = nanstd(y(idx));
    y_bar(i,3) = sum(idx);
end
g_sent_bar = y_bar(:,1)-nanmean(y_bar(:,1)); % store
f = figure(1);
subplot(2,2,1), 
h1 = plot(smooth(y),'k'); xlim([0 length(y)+1]);
    %set(gca,'xtick',round(linspace(1, length(x),5)), ...
    %'xticklabel',round(linspace(min(x), max(x),5)))
    xlim([0, length(y)+1])
subplot(2,2,3),
h3 = shadedErrorBar(yr,smooth(y_bar(:,1)-nanmean(y_bar(:,1))),smooth(y_bar(:,2))/5);
    xlim([min(yr)-1 max(yr)+1])
    ylim([-.1, .15])
    set(gca,'xtick',linspace(min(yr),max(yr),5))
% vectors
x = meta_av_mat(:,3);
idx = isnan(x); x(idx) = [];
y = sent_av(meta_av_mat(:,2),:);
y(idx) = [];
a_sent = sent_av(meta_av_mat(:,2),:);
% year average
yr = unique(x);
y_bar = zeros(length(yr),3);
for i = 1:length(yr)
    idx = yr(i) == x;
    y_bar(i,1) = nanmean(y(idx));
    y_bar(i,2) = nanstd(y(idx));
    y_bar(i,3) = sum(idx);
end
a_sent_bar = y_bar(:,1) - mean(y_bar(:,1));
subplot(2,2,2),
h2 = plot(y-mean(y),'k'); 
    %set(gca,'xtick',round(linspace(1, length(x),5)), ...
    %'xticklabel',round(linspace(min(x), max(x),5)))
    xlim([0, length(y)+1])
subplot(2,2,4),
ytmp = smooth(y_bar(:,1) - mean(y_bar(:,1)),20);
e = smooth(y_bar(:,2) - mean(y_bar(:,2)),10);
e = smooth(ci90(y_bar(:,2)- mean(y_bar(:,2)),size(y_bar(:,2),1)),20);
ytmp = smooth(y_bar(:,1)-nanmean(y_bar(:,1)),10);
e = smooth(y_bar(:,2)/10,10);
%plot(yr,ytmp)
h4 = shadedErrorBar(yr,ytmp,e);
%h4 = errorbar(yr,smooth(y_bar(:,1)),y_bar(:,2)/5);
    xlim([min(yr)-1 max(yr)+1])
    %ylim([.2 .5])
    set(gca,'xtick',linspace(min(yr),max(yr),5))
figSize(f,10,23)
plotCorrect
%


save(strcat(dd,'/sent_vects.mat'),'a_sent','a_sent_bar','g_sent','g_sent_bar')



