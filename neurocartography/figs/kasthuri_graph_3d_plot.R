library(igraph)

gfile = '/Users/gkiar/Downloads/kasthuri_graph_v4.graphml'
g <- read.graph(gfile, format='graphml')

# If no centroid attribute use the commented out line below, and comment code up to the g$layout line
g$layout <- layout.kamada.kawai(g, dim=3, sigma = vcount(g), kkconst = vcount(g)**2/20)

# centroids <- get.vertex.attribute(g, 'centroid')

layouts <- matrix(nrow = length(centroids), ncol = 3)
for (i in 1:length(centroids)) {
  temp <- na.omit(as.numeric(unlist(strsplit(unlist(centroids[i]), "[^0-9.]+"))))
  layouts[i,] <- temp
}

g$layout <- layouts

rglplot(g, layout = g$layout, vertex.label = NA, vertex.size = 3, vertex.color='tomato1', edge.color='paleturquoise1')
rgl.snapshot('/Users/gkiar/code/ocp/ndpaper2016/parse/kasthuri_graph_new.png', fmt = 'png')

rgl.postscript('/Users/gkiar/code/ocp/ndpaper2016/parse/kasthuri_graph_new.pdf', fmt = 'pdf')
  
