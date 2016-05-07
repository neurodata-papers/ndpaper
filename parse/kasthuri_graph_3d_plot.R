library(igraph)

gfile = '/Users/gkiar/Downloads/kasthuri_graph_v4.graphml'
g <- read.graph(gfile, format='graphml')

g$layout <- layout.kamada.kawai(g, dim=3, sigma = vcount(g), kkconst = vcount(g)**2/20)

rglplot(g, layout = g$layout, vertex.label = NA, vertex.size = 3, vertex.color='tomato1', edge.color='paleturquoise1')

rgl.postscript('/Users/gkiar/code/ocp/ndpaper2016/parse/kasthuri_graph.pdf', fmt = 'pdf')

