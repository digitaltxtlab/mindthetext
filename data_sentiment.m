% labMT scores for avila and geertz
dd = '/home/kln/projects/geertz/mystic_anthro/data';
load(strcat(dd,'/vspc_data.mat'))
%
% avila
disp('initiate avila sentiment matrix')
sent_av = zeros(size(dtm_av,1),1);
for i = 1:length(sent_av)
    disp(strcat('Sentiment Vector:',' ', num2str(i)))
    sent_av(i) = vect2sent(dtm_av(i,:),voc_av(:,2));
end
hist(sent_av)
% geertz
disp('initiate geertz sentiment matrix')
sent_gz = zeros(size(dtm_gz,1),1);
for i = 1:length(sent_gz)
    disp(strcat('Sentiment Vector:',' ', num2str(i)))
    sent_gz(i) = vect2sent(dtm_gz(i,:),voc_gz(:,2));
end
% save(strcat(dd,'/av_gz_sentiment.mat'),'sent_av','sent_gz')
disp('sentiment matrices exported')




