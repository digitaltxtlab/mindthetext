kill
cd('~/projects/geertz/mystic_anthro/')
run('code/lda_import.m')
load('data/metadata.mat')
% reorganize theta matrices on metadata and build structured object
theta = struct('av',theta_av(meta_av_mat(:,2),:), ...
    'gz',theta_gz(meta_gz_mat(:,2),:));
% KL-div for time ordered theta matrices
f = fieldnames(theta);
kld_cell = cell(numel(f),2);
for i = 1:numel(f)
    X = theta.(f{i});
    kld = zeros(size(X,1),2);
    for ii = 1:size(X,1)
        p = X(1:(ii-1),:);
        q = X(ii,:);
        kld(ii,1) = mean(KLDiv(p,q));
        kld(ii,2) = std(KLDiv(p,q));
    end
    kld_cell{i,2} = kld;
end
kld_cell{1,1} = meta_av_mat(:,3);
kld_cell{2,1} = meta_gz_mat(:,3);
save('data/kld_vects.mat','kld_cell')% store with nan
% remove nan from av
idx = isnan(kld_cell{1,1}); 
kld_cell{1,1}(idx) = [];
kld_cell{1,2}(idx,:) = [];
clear i ii X p q idx;
% plot
s = 10; % smoothing factor
f = figure(1);
kld_plot_data = cell(2,1);
for i = 1:2
    w = nanmean(kld_cell{i,2}(:,1));
    y = kld_cell{i,2}(:,1);
    yw = smooth(y-w,s);
    yw = y-w;
    e = smooth(kld_cell{i,2}(:,1) - nanmean(kld_cell{i,2}(:,1)),s);
    e = smooth(kld_cell{i,2}(:,1)/sqrt(length(y)),s);
    x = 1:length(y);
    subplot(2,2,i), h = plot(yw);
        h.Color = [0 0 0];
        h.LineWidth = 1.25;
    %subplot(2,2,i), h2 = shadedErrorBar(x,yw,e);
        xlim([min(x)-.2,max(x)+.2]);
        %set(gca,'xtick',round(linspace(1, length(x),5)), ...
        %    'xticklabel',round(linspace(min(kld_cell{i,1}), max(kld_cell{i,1}),5)))
        xlabel('Time-ordered Index','interpreter','latex')
        ylabel('$Bits$','interpreter','latex')
    % annual averages
    yr = unique(kld_cell{i,1});
    
    ybar = zeros(numel(yr),2);
    for ii = 1:numel(yr)
        idx = kld_cell{i,1} == yr(ii);
        ybar(ii,1) = nanmean(y(idx));
        ybar(ii,2) = nanstd(y(idx));
    end
    
    ybar(:,1) = smooth(ybar(:,1)-nanmean(ybar(:,1)),s);
    ybar(:,2) = smooth(ybar(:,2)-nanmean(ybar(:,2)),s);
    ybar(:,2) = smooth(ci95(ybar(:,2)-mean(ybar(:,2)),size(ybar,1)),s);
    %subplot(2,2,i + 2), plot(yr,ybar(:,1))
    subplot(2,2,i + 2), shadedErrorBar(yr,ybar(:,1),ybar(:,2))
        xlim([min(yr)-.2,max(yr)+.2]);
        set(gca,'xtick',round(linspace(min(yr), max(yr),5)));
        xlabel('Year','interpreter','latex')
        ylabel('$Bits_{Avg}$','interpreter','latex')
    disp([yr ybar(:,1)])
    kld_plot_data{i} = [yr, ybar(:,1), ybar(:,2)];
end
figSize(f,10,23)
plotCorrect
%saveFig('/home/kln/Documents/ms/mind_text/figures/fig_kld.png')
%disp(mean)
% save('data/plot_data.mat','kld_plot_data');



