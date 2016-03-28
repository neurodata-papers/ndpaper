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
  avg <- apply(tmp[,-1]/Threads[i],1,mean)
  sx <- apply(tmp[,-1],1,sd)/sqrt(dim(tmp)[2]-1)
  ci <- qt(0.975,df=dim(tmp)[2]-2)*sx
  
  emin <- avg - ci
  emax <- avg + ci
  throughput<-(Threads[i]*size)/avg
  thmin <- (Threads[i]*size)/emax
  thmax <- (Threads[i]*size)/emin

  ### Switch th for throughput
  th<- data.frame(size=size,threads=Threads[i],avg=avg,emin=emin,emax=emax)
  #th <- data.frame(size=size,threads=Threads[i],throughput=throughput, thmin=thmin,thmax=thmax)
}

datWrite <- foreach(i = 1:length(Threads),.combine='rbind') %do% {
  tmp <- read.csv(writeFiles[i],header=FALSE)  
  avg <- apply(tmp[,-1]/Threads[i],1,mean)
  sx <- apply(tmp[,-1],1,sd)/sqrt(dim(tmp)[2]-1)
  ci <- qt(0.975,df=dim(tmp)[2]-2)*sx
  
  emin <- avg - ci
  emax <- avg + ci
  throughput<-(Threads[i]*size)/avg
  thmin <- (Threads[i]*size)/emax
  thmax <- (Threads[i]*size)/emin

  ### Switch th for throughput
  th<- data.frame(size=size,threads=Threads[i],avg=avg,emin=emin,emax=emax)
  #th <- data.frame(size=size,threads=Threads[i],throughput=throughput, thmin=thmin,thmax=thmax)
}


datRead$threads <- as.factor(datRead$threads)
datRead$size <- as.factor(datRead$size)

datWrite$threads <- as.factor(datWrite$threads)
datWrite$size <- as.factor(datWrite$size)

ts <- 20
p1 <-  ggplot(data=datRead,aes(x=size,y=avg,ymin=emin,ymax=emax, group=threads,color=threads)) + 
#p1 <-  ggplot(data=datRead,aes(x=size,y=throughput,ymin=thmin,ymax=thmax, group=threads,color=threads)) + 
    geom_line(size=1.5) + 
    geom_errorbar(width=0.25) +
    #ylab("Throughput (MB/sec)") + 
    ylab("Time (sec)") +
    xlab("Size of cutout (MB)") + 
    #ggtitle("Read throughput across multiple threads.") +
    ggtitle("Read time across multiple threads.") +
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

p2 <-  ggplot(data=datWrite,aes(x=size,y=avg,ymin=emin,ymax=emax,group=threads,color=threads)) + 
#p2 <-  ggplot(data=datWrite,aes(x=size,y=throughput,ymin=thmin,ymax=thmax, group=threads,color=threads)) + 
    geom_line(size=1.5) + 
    geom_errorbar(width=0.25) +
    #ylab("Throughput (MB/sec)") + 
    ylab("Time (sec)") +
    xlab("Size of cutout (MB)") + 
    #ggtitle("Write throughput across multiple threads.") +
    ggtitle("Write time across multiple threads.") +
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

#   Time: ~2 hrs
##  Working status: Works!
### Comments: 
####Soli Deo Gloria
