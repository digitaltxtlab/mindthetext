rm(list = ls())
wd <- '/home/kln/projects/geertz/mystic_anthro/code'
dd <- '/home/kln/projects/geertz/mystic_anthro/data'
setwd(wd)
# packages
library(tm)
# functions
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
# data directory (vanilla utf-8)
dpath_1 <- "/home/kln/projects/geertz/mystic_anthro/data/geertz_data/geertz_txt"
dpath_2 <- "/home/kln/projects/geertz/mystic_anthro/data/avila_data/avila_txt"
#datadir <- "/home/kln/projects/human_futures/data/sandbox"
geertz.cor <- Corpus(DirSource(dpath_1, encoding  = "UTF-8"), readerControl = list(language="PlainTextDocument"))
avila.cor <-  Corpus(DirSource(dpath_2, encoding  = "UTF-8"), readerControl = list(language="PlainTextDocument"))
# import document names
file_1 <- gsub("\\..*","",names(geertz.cor))
file_2 <- gsub("\\..*","",names(avila.cor))
# preprocess quick and dirty
geertz.cl.cor <- preprocess(geertz.cor)
avila.cl.cor <- preprocess(avila.cor)
# vectspc
mindoc = floor(.05*length(file_1))# minimum rep based on smallest corpus
geertz.mat <- as.matrix(docsparse(mindoc,DocumentTermMatrix(geertz.cl.cor)))
rownames(geertz.mat) <- file_1
avila.mat <- as.matrix(docsparse(mindoc,DocumentTermMatrix(avila.cl.cor)))
rownames(avila.mat) <- file_2
# save work space
save.image(file = paste(dd,'/data_cor_mat.RData',sep = ""))

### export
#write.table(geertz.mat, file = paste(dd,'/geertz_mat.csv',sep = ""), row.names = FALSE, col.names = FALSE)
#write.table(avila.mat, file = paste(dd,'/avila_mat.csv',sep = ""), row.names = FALSE, col.names = FALSE)
write.table(rownames(geertz.mat), file = , paste(dd,'/geertz_file.txt',sep = ""))
write.table(colnames(geertz.mat), file = , paste(dd,'/geertz_voc.txt',sep = ""))
write.table(rownames(avila.mat), file = , paste(dd,'/avila_file.txt',sep = ""))
write.table(colnames(avila.mat), file = , paste(dd,'/avila_voc.txt',sep = ""))

library('R.matlab')
filename <- paste(dd,'/av_gz_data.mat', sep = "")
writeMat(filename, dtm_gz = geertz.mat, dtm_av = avila.mat)






