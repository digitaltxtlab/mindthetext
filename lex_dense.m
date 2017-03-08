kill
dd = '/home/kln/projects/geertz/mystic_anthro/data';
datapath = {strcat(dd,'/avila_data/avila_txt'); ...
    strcat(dd,'/geertz_data/geertz_txt')};
% ttr and lexical entropy
[lexden_cell, lexent_cell] = deal(cell(numel(datapath)));
doclen = cell(size(datapath));
for j = 1:numel(datapath)
    [dtm, ~, docstokens] = tdmVanilla(datapath{j});
    len = sum(dtm,2);
    [lexden, lexent] = deal(zeros(numel(docstokens),2));
    slicelen = 250;
    for i = 1:numel(docstokens)
        doc = docstokens{i};
        slices = slice_token(doc, slicelen);
        [ttrbar, ttrsd] = ttr_slices(slices);
        [entbar, entsd] = entropy_slices(slices);
        lexden(i,1) = ttrbar;
        lexden(i,2) = ttrsd;
        lexent(i,1) = entbar;
        lexent(i,2) = entsd;
    end
    lexden_cell{j} = lexden;
    lexent_cell{j} = lexent;
    doclen{j} = len;
end
%
%save('lexden_cell', 'lexent_cell', 'slicelen','datapath')
%
%load('/home/kln/projects/geertz/mystic_anthro/data/lex_dense.mat')
clc
disp(slicelen)
for ii = 1:size(lexden_cell,1)
    disp(datapath{ii})
    disp('TTR:')
    disp(mean(lexden_cell{ii,1}))
    disp('Lexical Entropy')
    disp(mean(lexent_cell{ii,1}))
end

disp('median document length')
disp(median([doclen{1}; doclen{2}]))

% test
x = lexden_cell{1}(:,1);
y = lexden_cell{2}(:,1);
[h,p,ci,stats] = ttest2(y,x);
% test
x = lexent_cell{1}(:,1);
y = lexent_cell{2}(:,1);
[h,p,ci,stats] = ttest2(y,x)
% effect size
X = [mean(lexent_cell{1,1}); mean(lexent_cell{2,1})];
sdp = sqrt((X(1,2)^2 + X(2,2)^2)/2);
d =  (X(2,1) - X(1,1))/sdp;
disp('Effect size')
disp(d)

