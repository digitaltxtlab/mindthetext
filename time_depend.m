kill
wd = '/home/kln/projects/geertz/mystic_anthro';
load('data/sent_vects.mat')
load('data/kld_vects.mat')
%%
% remove nan elements based on metadata
idx = isnan(kld_cell{1,1}); 
kld_cell{1,1}(idx) = [];
kld_cell{1,2}(idx,:) = [];
a_sent(idx) = [];
% extract kld measures
a_kld = kld_cell{1,2}(:,1);
g_kld = kld_cell{2,2}(:,1);
% remove modeling nan
idx = isnan(a_kld);
a_kld(idx) = []; a_sent(idx) = [];
idx = isnan(g_kld);
g_kld(idx) = []; g_sent(idx) = [];
disp('KLD model')
disp('TA mean and sd: '), disp([nanmean(a_kld), nanstd(a_kld)])
disp('AG mean and sd: '), disp([mean(g_kld), std(g_kld)])
[h, p, ci, stats] = ttest2(g_kld,a_kld);
disp(h)
disp('effect')
disp(cohen_d(a_kld,g_kld));
disp('-----')
disp('labMT model')
disp('TA mean and sd: '), disp([nanmean(a_sent), nanstd(a_sent)])
disp('AG mean and sd: '), disp([mean(g_sent), std(g_sent)])
[h, p, ci, stats] = ttest2(a_sent,g_sent);
disp(h)
% effect size
disp('effect')
disp(cohen_d(g_sent,a_sent));
% center kld
a_kld = a_kld - mean(a_kld);
g_kld = g_kld - mean(g_kld);
% correlation
disp('association patterns')
[ar, ap] = corrcoef([a_kld a_sent]);
disp([ar ap])
[gr, gp] = corrcoef([g_kld g_sent]);
disp([gr gp])
%% delay/lag
ad = finddelay(a_kld,a_sent);
crosscorr(a_kld,a_sent)
gd = finddelay(g_kld,g_sent);
crosscorr(g_kld,g_sent)
%% causation
w = 5; % window
a = .05; % alpha level
% Does sentiment Granger Cause kld?
disp('TA, sent -> kld')
[F,c_v, df1, df2] = granger_cause(a_kld,a_sent,a,w);
disp([F, df1, df2, 1-fcdf(F,df1,df2)])
if F > c_v; disp('H = 1'); else disp('H = 0'); end
disp('AG, sent -> kld')
[F,c_v, df1, df2] = granger_cause(g_kld,g_sent,a,w);
disp([F, df1, df2, 1-fcdf(F,df1,df2)])
if F > c_v; disp('H = 1'); else disp('H = 0'); end
% Does kld Granger Cause sentimen?
disp('TA, kld --> sent')
[F,c_v, df1, df2] = granger_cause(a_sent,a_kld,a,w);
disp([F, df1, df2, 1-fcdf(F,df1,df2)])
if F > c_v; disp('H = 1'); else disp('H = 0'); end
disp('AG, kld --> sent')
[F,c_v, df1, df2] = granger_cause(g_sent,g_kld,a,w);
disp([F, df1, df2, 1-fcdf(F,df1,df2)])
if F > c_v; disp('H = 1'); else disp('H = 0'); end
%% plot annual averages
kill
load('data/plot_data.mat');
X = [kld_plot_data;sent_plot_data{2};sent_plot_data{1}];
% remove posthume work
X{1}(end,:) = [];
X{3}(end,:) = [];
w2 = [-.55 2.25; -.75 1; -.035, .05; -.1 .175];
f2 = figure(2);
for i = 1:numel(X)
    x = X{i}(:,1);
    y = X{i}(:,2);
    e = X{i}(:,3);
    if i >= 3
        y = scaleminusone(y);
        e = X{i}(:,3).*10;
    end
    subplot(2,2,i),
        h = shadedErrorBar(x,y,e);
        h.mainLine.LineStyle = '-';
        h.mainLine.Color = [0 0 0];
        h.mainLine.LineWidth = 1.5;
        h.mainLine.Marker = 'o';
        h.mainLine.MarkerSize = 3;
        h.mainLine.MarkerFaceColor = [1 1 1];
        h.patch.FaceColor = [.9 .9 .9];
        [h.edge(1).Color, h.edge(2).Color] = deal('None');
        set(gca,'xtick',round(linspace(min(x), max(x),5)));
        w = .00075 * max(x);
        xlim([min(x)-w,max(x)+w])
        
        ylim([w2(i,1),w2(i,2)])
        if i >= 3; ylim([-1.15 1.15]); end
        xlabel('Year','interpreter','latex')
        if i <= numel(X)/2
            ylabel('Bits','interpreter','latex')
        else
            ylabel('Polarity','interpreter','latex')
        end
end
figSize(f2,12,23)
plotCorrect
saveFig('/home/kln/Documents/ms/mind_text/figures/fig2.png')

    
    
    
    
    
    
    
    




