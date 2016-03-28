#! /usr/bin/Rscript
###
### Benchmark image generation
###
### Jesse Leigh Patsolic 
### 2016 <jesse@cis.jhu.edu>
### S.D.G 
#


require(ggplot2)
require(foreach)

baseURLread<-"https://raw.githubusercontent.com/neurodata/ocp-journal-paper/gh-pages/Results/CSV/ndstore/read/"

baseURLwrite<-"https://raw.githubusercontent.com/neurodata/ocp-journal-paper/gh-pages/Results/CSV/ndstore/write/"

Threads <- c(1,2,4,8,16,32)
size <- c(0.5,2^c(0:11))

readFiles <- paste0(baseURLread,"read_",Threads,"_threads.csv")
writeFiles <- paste0(baseURLwrite,"write_",Threads,"_threads.csv")


datRead <- foreach(i = 1:length(Threads),.combine='rbind') %do% {
  tmp <- read.csv(readFiles[i],header=FALSE)  
  colnames(tmp) <- c("Size", paste0("test",1:(ncol(tmp)-1),"_",Threads[i]))

  st <- stack(tmp[,-1])
  st$values <- (Threads[i]*size/1024)/st$values # Converted to GB
  th<-data.frame(size=size,threads=Threads[i],st)
}


datWrite <- foreach(i = 1:length(Threads),.combine='rbind') %do% {
  tmp <- read.csv(writeFiles[i],header=FALSE)  
  colnames(tmp) <- c("Size", paste0("test",1:(ncol(tmp)-1),"_",Threads[i]))

  st <- stack(tmp[,-1])
  st$values <- (Threads[i]*size/1024)/st$values # Converted to GB
  th<-data.frame(size=size,threads=Threads[i],st)
}


datRead$threads <- as.factor(datRead$threads)
datRead$size <- as.factor(datRead$size)
datRead$ind <- as.factor(datRead$ind)

datWrite$threads <- as.factor(datWrite$threads)
datWrite$size <- as.factor(datWrite$size)
datWrite$ind <- as.factor(datWrite$ind)

ts <- 20

### JLP messed with the colors
cbPalette <- c("#000000", "#56B4E9", "#E69F00","#0072D8", "#FFF000","#470778", "#CC79A7")

p1 <- ggplot(data=datRead,aes(x=size,y=values,group=ind,color=threads)) + 
    geom_line(size=0.8) + 
    geom_point(color='black', size=0.75) + 
    scale_colour_manual(values=cbPalette) + 
    ylab("Throughput (GB/sec)") + 
    xlab("Size of cutout (MB)/thread") + 
    ggtitle("Read throughput across multiple threads.") +
    theme(plot.title=element_text(size=ts),
          axis.title.x=element_text(size=ts),
          axis.title.y=element_text(size=ts),
          legend.title=element_text(size=ts),
          legend.text=element_text(size=ts-2),
          axis.text=element_text(size=ts-2))


pdf("../../Results/Figures/store/ReadThroughputPlot.pdf", height=4,width=10)
print(p1)
dev.off()

png("../../Results/Figures/store/ReadThroughputPlot.png", height=480, width=1200, res=120)
print(p1)
dev.off()

p2 <- ggplot(data=datWrite,aes(x=size,y=values,group=ind,color=threads)) + 
    geom_line(size=0.8) + 
    geom_point(color='black', size=0.75) + 
    scale_y_log10() + 
    scale_colour_manual(values=cbPalette) + 
    ylab("Throughput (GB/sec)") + 
    xlab("Size of cutout (MB)/thread") + 
    ggtitle("Write throughput across multiple threads.") +
    theme(plot.title=element_text(size=ts),
          axis.title.x=element_text(size=ts),
          axis.title.y=element_text(size=ts),
          legend.title=element_text(size=ts),
          legend.text=element_text(size=ts-2),
          axis.text=element_text(size=ts-2))

pdf("../../Results/Figures/store/WriteThroughputPlot.pdf", height=4,width=10)
print(p2)
dev.off()

png("../../Results/Figures/store/WriteThroughputPlot.png", height=480, width=1200, res=120)
print(p2)
dev.off()

#   Time: ~8 hrs
##  Working status: Works!
### Comments: 
####Soli Deo Gloria
