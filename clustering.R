library(RcppCNPy)

files <- list.files(path="/home/garner1/Work/dataset/readcountLP/U", pattern=NULL, full.names=T, recursive=FALSE)

fmat = matrix(nrow=dim(npyLoad(files[1]))[1], ncol=length(files))
ind = 1
for (x in files){
  # print(x)
  # print(ind)
  # print(dim(npyLoad(x)))
  fmat[1:dim(npyLoad(x))[1],ind] <- npyLoad(x)
  ind = ind + 1
}

temp = t(fmat)
d <- dist(as.matrix(temp), method = "euclidean")
hc1 <- hclust(d, method = "complete" )
par(cex=0.6, mar=c(5, 8, 4, 1))
plot(hc1,hang=0.1,
     label=c("17_C","18_G","20_C","21_B","22_M","23_B","24_C","25_M","1_B"),
     main="Patients clustering")
# label=c("XZ114","XZ115","XZ117","XZ118","XZ119","XZ120","XZ121","XZ122","XZ91")
