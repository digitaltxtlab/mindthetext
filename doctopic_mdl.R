rm(list = ls())
wd <- '/home/kln/projects/geertz/mystic_anthro/code'
dd <- '/home/kln/projects/geertz/mystic_anthro/data'
setwd(wd)
load(paste(dd,'/data_cor_mat.RData',sep = ""))

library(topicmodels)
seed <- 1234
## parameter estimation
#maxk <- 100
#perplexity.v <- vector(mode = "numeric", length = maxk-50)
#for(k in 50:maxk){
#  mdl.lda <- LDA(avila.mat, k = k, method = 'VEM', control = list(seed = seed))
#  perplexity.v[k-49] <- perplexity(mdl.lda)
#  print(paste('evaluating k =',as.character(k)))
#  }
#plot(2:maxk,perplexity.v)
k <- 50
av_mdl <- LDA(avila.mat, k = k, method = 'VEM', control = list(seed = seed))
gz_mdl <- LDA(geertz.mat, k = k, method = 'VEM', control = list(seed = seed))

# inspect models
load(paste(dd,'/lda_mdl.RData',sep = ""))
print(terms(gz_mdl,10))
print(topics(gz_mdl,2))

print(terms(av_mdl,10))
print(topics(av_mdl,2))
### export model
# terms
write.csv(data.frame(terms(gz_mdl,10)),paste(dd,'/lda_terms_gz.txt',sep = ""))
write.csv(data.frame(terms(av_mdl,10)),paste(dd,'/lda_terms_av.txt',sep = ""))
## posteriors
load(paste(dd,'/data_cor_mat.RData',sep = ""))
# gz
gz_post.l <- posterior(gz_mdl, geertz.mat)
gz_theta.mat <- as.matrix(gz_post.l$topics)
gz_theta_row.v <- rownames(gz_theta.mat)
write.csv(gz_theta.mat, file = paste(dd,'/lda_theta_gz.csv',sep = ""), row.names = TRUE)
write.csv(gz_theta_row.v, file = paste(dd,'/lda_theta_gz_rows.csv',sep = ""), row.names = TRUE)
# av
av_post.l <- posterior(av_mdl, avila.mat)
av_theta.mat <- as.matrix(av_post.l$topics)
av_theta_row.v <- rownames(av_theta.mat)
write.csv(av_theta.mat, file = paste(dd,'/lda_theta_av.csv',sep = ""), row.names = TRUE)
write.csv(av_theta_row.v, file = paste(dd,'/lda_theta_av_rows.txt',sep = ""), row.names = TRUE)
## beta weights
# gz
gz_beta.mat <- as.matrix(gz_post.l$terms)
gz_beta_col.v <- colnames(gz_beta.mat)
write.csv(gz_beta.mat, file = paste(dd,'/lda_beta_gz.csv',sep = ""), row.names = TRUE)
write.csv(gz_beta_col.v, file = paste(dd,'/lda_beta_gz_col.txt',sep = ""), row.names = TRUE)
# av
av_beta.mat <- as.matrix(av_post.l$terms)
av_beta_col.v <- colnames(av_beta.mat)
write.csv(av_beta.mat, file = paste(dd,'/lda_beta_av.csv',sep = ""), row.names = TRUE)
write.csv(av_beta_col.v, file = paste(dd,'/lda_beta_av_col.txt',sep = ""), row.names = TRUE)
# matlab file
library('R.matlab')
filename <- paste(dd,'/lda_weights.mat', sep = "")
writeMat(filename, theta_gz = gz_theta.mat, theta_av = av_theta.mat, beta_gz = gz_beta.mat, beta_av = av_beta.mat)



