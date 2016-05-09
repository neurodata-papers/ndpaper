# Greg Kiar
# May 5, 2016
# Analyze figure for nd2016 paper

# Open requirements
library(gridExtra)
library(grid)
library(ggplot2)
library(reshape2)

# Prepare general plotting preferences; thank you Jesse
ts <- 22

cbPal1 <- c("#000000", "#56B4E9", "#470778", "#00B800", "#006940")
cbPal2 <- c("#E69F00", "#00B800", "#006940")
cbPal3 <- c("#0072D0", "#00B800", "#006940")

tt <- theme(plot.title=element_text(size=ts+1),
            axis.title.x=element_text(size=ts),
            axis.title.y=element_text(size=ts+1),
            legend.title=element_text(size=ts),
            strip.text=element_text(size=ts),
            legend.text=element_text(size=ts-1),
            axis.text=element_text(size=ts-2))

# Add custom plotting prefs for this data
tt2 <- tt + theme(axis.title.x=element_blank(),
                  strip.background = element_blank(),
                  axis.ticks.x = element_blank(),
                  axis.text.x = element_blank(),
                  legend.title = element_blank())



# Plot 1: FlashGraph Performance
fg <- read.csv('../gkiar/code/ocp/ndpaper2016/analysis/data/FG_speed.csv')
fg <- melt(t(as.data.frame(fg)))
fg <- fg[-c(6,7,13,14),] # Removes non-reproducible columns
colnames(fg) <- c("Tool", "Graph", "seconds")
labs <- c("Giraph","GraphX", "PowerGraph", "FG-SEM (i2.xlarge)", "FG-SEM (i2.8xlarge)")
fgp1 <- ggplot(fg, aes(x=Tool, y=seconds, group=Graph, fill=Tool)) + tt2 + geom_bar(stat='identity', position = position_dodge()) +
        facet_grid(.~Graph, switch="x") + scale_fill_manual(values=cbPal1, labels=labs) + ggtitle('Graph (V=42E6, E=1.5E9) Operations') +
        theme(legend.justification=c(1,0), legend.position=c(0.94,0.787)) + ylab('Computation Time (s)')
fgp1


# Plot 2: FlashMatrix Performance 1
fm1 <- read.csv('../gkiar/code/ocp/ndpaper2016/analysis/data/FM_speed.csv')
tmp <- data.frame(fm1$Spark, fm1$FM.EM, fm1$FM.IM)
rownames(tmp) <- rownames(fm1)
fm1 <- tmp
fm1 <- melt(t(as.data.frame(fm1)))
colnames(fm1) <- c("Tool", "Stat", "seconds")
labs <- c("Spark", "FM-SEM","FM-IM")
fmp1 <- ggplot(fm1, aes(x=Tool, y=seconds, group=Stat, fill=Tool)) + tt2 + geom_bar(stat='identity', position = position_dodge()) +
        facet_grid(.~Stat, switch="x") + scale_fill_manual(values=cbPal2, labels=labs) + scale_y_log10() +
        ggtitle('Matrix (N=1E9, p=32) Operations') + theme(legend.justification=c(1,0), legend.position=c(0.817,0.85)) + ylab('')
fmp1

# Plot 3: FlashMatrix Performance 2
fm2 <- read.csv('../gkiar/code/ocp/ndpaper2016/analysis/data/FM_eigen.csv')
fm2 <- melt(t(as.data.frame(fm2)))
colnames(fm2) <- c("Tool", "Graph", "seconds")
labs <- c("Trilinos","FM-SEM", "FM-IM")
fmp2 <- ggplot(fm2, aes(x=Tool, y=seconds, group=Graph, fill=Tool)) + tt2 + geom_bar(stat='identity', position = position_dodge()) +
        facet_grid(.~Graph, switch="x") + scale_fill_manual(values=cbPal3, labels=labs) + ylab('') +
        ggtitle('Eigensolver on Large Graphs') + theme(legend.justification=c(1,0), legend.position=c(0.736,0.85))
fmp2

# Combine plots
pdf("../gkiar/code/ocp/ndpaper2016/analysis/figs/flashx.pdf",width=27,height=9)

grid.arrange(fgp1,fmp1,fmp2, ncol=3)

dev.off()
