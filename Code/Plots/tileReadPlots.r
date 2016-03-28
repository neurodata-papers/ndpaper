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

## Read data from github csv file
tileDat <- read.csv("https://raw.githubusercontent.com/neurodata/ocp-journal-paper/gh-pages/Results/CSV/ndtilecache/1024_1024_4threads_ndtilecache.csv",head=FALSE, stringsAsFactors=FALSE)

## Fix some errors 
tileDat[488,] <- 0.624686002731
tileDat[1216,] <-0.210937023163

tileDat <- tileDat[,1]
tileDat <- as.numeric(tileDat)
Tile<- 1:length(tileDat)

dat <- data.frame(Tile,Time=tileDat*1e3)

ts <- 20 # set base text size
p1 <- ggplot(data=dat,aes(x=Tile,y=Time)) + 
        geom_line() + 
        scale_y_log10() + 
        ylab("Time (ms)") + 
        xlab("Slice # (4 512X512 tiles per slice)") + 
        ggtitle("Tile Read Speed")+
        theme(plot.title=element_text(size=ts),
          axis.title.x=element_text(size=ts),
          axis.title.y=element_text(size=ts),
          legend.title=element_text(size=ts),
          legend.text=element_text(size=ts-2),
          axis.text=element_text(size=ts-2))


### Save plots to files
pdf("../../Results/Figures/store/tile_read_speed.pdf", height=4,width=8)
print(p1)
dev.off()

png("../../Results/Figures/store/tile_read_speed.png", height=480, width=960, res=120)
print(p1)
dev.off()

#   Time: 30 min
##  Working status: Works!
### Comments: 
####Soli Deo Gloria
