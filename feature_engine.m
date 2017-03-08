kill
cd('~/projects/geertz/mystic_anthro/')
load('data/features.mat')
% feature content
n = 10;
betamax = zeros(size(beta,1),n);
termmax = cell(size(betamax));
for i = 1:size(beta,1)
    %i = 1
    [v,idx] = sort(beta(i,:),'descend');
    betamax(i,:) = v(1:n);
    termmax(i,:) = terms(idx(1:n))';
end
disp(termmax')
% class information
g = cell2mat(regexp(docs,'g_'));
class_num = [zeros((length(docs)-length(g)),1);g]; % Avila = 0
class_cell = cell(size(class_num,1),1);
    class_cell(class_num == 0) = {'avila'};
    class_cell(class_num == 1) = {'geertz'};
% samples (balanced prior)    
n1 = sum(class_num == 0);
n2 = sum(class_num == 1);
rng(1234,'twister');
i1 = randi([1 n1],n2,1);  
i2 = find(class_num == 1);
% training data
X = [theta(i1,:); theta(i2,:)];
y = [class_num(i1);class_num(i2)];
ystr = [class_cell(i1);class_cell(i2)];
% # feature importance in classification
t = size(X,2);
err = zeros(1,t);
f = figure(1);
for i = 1:t
    mdl = fitcnb(X(:,i),ystr,'Distribution','kernel');
    err(i) = resubLoss(mdl,'LossFun','ClassifErr');
    subplot(t/2,2,i), plot(X(:,i),'*k')
    vline(size(X,1)/2+.5)
    title(strcat('Feat: ',num2str(i),' Err: ',num2str(err(i))))
end
% plot resubstitution error
f2 = figure(2);
ax = [1 2 4 6 8 9];
ay = zeros(size(err)); ay(ax) = err(ax);
gx = [3 5 7 10];
gy = zeros(size(err)); gy(gx) = err(gx);
x = 1:length(err);
h1 = bar(x,ay);
    h1.FaceColor = [.75 .75 .75];
    h1.EdgeColor = h1.FaceColor;
hold on
h2 = bar(x,gy);
    h2.FaceColor = [.25 .25 .25];
    h2.EdgeColor = h2.FaceColor;
xlim([.25 10.75])
% add mean lines
am = mean(ay(ax)); gm = mean(gy(gx));
al = hline(am); gl = hline(gm);
al.Color = h1.FaceColor; gl.Color = h2.FaceColor; 
al.LineWidth = 1.5; gl.LineWidth = al.LineWidth;
al.LineStyle = '--'; gl.LineStyle = al.LineStyle;
uistack(al,'down'); uistack(gl,'down');
xlabel('Topic ID','interpreter','latex')
ylabel('Error', 'interpreter', 'latex')

plotCorrect

legend('TA','AWG'); legend boxoff
saveFig('/home/kln/Documents/ms/mind_text/figures/fig1.png')
%%
% wrapper for feature selection 
x = X;
Y = [];
y = zeros(2,size(X,2));
feat = zeros(1,size(X,2));
for j = 1:size(X,2)
    err = zeros(1,size(x,2));
    for i = 1:size(x,2)
        mdl = fitcnb([Y x(:,i)],ystr,'Distribution','kernel');
        err(i) = resubLoss(mdl,'LossFun','ClassifErr');
    end
    [~,idx] = min(err);
    tmp = zeros(1,size(X,2)); 
    for ii = 1:size(X,2)
        tmp(ii) = isequal(x(:,idx),X(:,ii));
    end
    y(1,j) = find(tmp == 1); % feature number
    y(2,j) = min(err); % error
    Y = [Y x(:,idx)]; %#ok<AGROW>
    x(:,idx) = [];
end
