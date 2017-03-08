rm(list = ls())
wd <- '/home/kln/projects/geertz/mystic_anthro/code'
dd <- '/home/kln/projects/geertz/mystic_anthro/data'
setwd(wd)
library('tm')
library('topicmodels')
library('R.matlab')
preprocess <- function(v.cor){
  tmp <- tm_map(v.cor, PlainTextDocument)
  tmp <- tm_map(tmp, removePunctuation)
  tmp <- tm_map(tmp, removeNumbers)
  tmp <- tm_map(tmp, content_transformer(tolower))
  tmp <- tm_map(tmp, removeWords, stopwords("english"))
  tmp <- tm_map(tmp, stemDocument)
  tmp <- tm_map(tmp, stripWhitespace)
  cl.cor <- tm_map(tmp, PlainTextDocument)
  return(cl.cor)
}
docsparse <- function(mindocs,dtm){
  n = length(row.names(dtm))
  sparse <- 1 - mindocs/n;
  dtmreduce <- tm::removeSparseTerms(dtm, sparse)
  return(dtmreduce)
}
print('building corpus')
datapath <- paste(dd,'/merge_data', sep = '')
vcor <- Corpus(DirSource(datapath, encoding  = "UTF-8"), readerControl = list(language="PlainTextDocument"))
docnames <- gsub("\\..*","",names(vcor))
vcor_cl <- preprocess(vcor)
mindoc = floor(.003*length(docnames))
  dtm <- as.matrix(docsparse(mindoc,DocumentTermMatrix(vcor_cl)))
rownames(dtm) <- docnames
print('training model')
seed <- 1234
k <- 10
mdl <- LDA(dtm, k = k, method = 'VEM', control = list(seed = seed))
# theta weights
print('exporting features')
post <- posterior(mdl, dtm)
theta <- as.matrix(post$topics)
theta_row <- rownames(theta)
beta <- as.matrix(post$terms)
beta_col <- colnames(beta)
filename <- paste(dd,'/features.mat', sep = "")
writeMat(filename, theta = theta, beta = beta, docs = theta_row, terms = beta_col)
print('feature extraction finished')
# write.csv(theta, file = paste(dd,'/merge_theta.txt',sep = ""), row.names = TRUE)
# write.csv(theta_row, file = paste(dd,'/merge_theta_rows.txt',sep = ""), row.names = TRUE)
# write.csv(beta, file = paste(dd,'/beta.txt',sep = ""), row.names = TRUE)
# write.csv(beta_col, file = paste(dd,'/beta_col.txt',sep = ""), row.names = TRUE)





