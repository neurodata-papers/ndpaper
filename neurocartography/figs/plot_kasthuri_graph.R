library(igraph)

gfile = '/Users/gkiar/Downloads/kasthuri2015_ramon_v4.graphml'
g <- read.graph(gfile, format='graphml')

g$layout <- layout.fruchterman.reingold(g, dim=2, sigma=4*vcount(g))

png('/Users/gkiar/code/ocp/ndpaper2016/casestudy1/kashutri2015_ramon_v4.png', width=1200, height=1200)
plot.igraph(g, vertex.label=NA, vertex.size=2, vertex.color='tomato1', edge.color='black', edge.width=2, edge.arrow.mode='-')

dev.off()
