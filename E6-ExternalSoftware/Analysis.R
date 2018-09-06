# Created on 18/04/18 by jdutheil

# Compare the trees:
library(ape)
trees <- read.tree(file = "chr9_realigned.trees.dnd")

# Consensus tree (majority rule)
ctree <- consensus(trees, p = 0.5)
plot(ctree)

# Sort all topologies:
tree.classes <-list()
tree.classes[[1]] <- list()
tree.classes[[1]][[1]] <- reorder(trees[[1]])
for (i in 2:length(trees)) {
  tr <- trees[[i]]
  new.class <- TRUE
  for (j in 1:length(tree.classes)) {
    if (dist.topo(tr, tree.classes[[j]][[1]]) == 0) {
      # Append to existing class:
      tree.classes[[j]][[length(tree.classes[[j]]) + 1]] <- reorder(tr)
      new.class <- FALSE
    }
  }
  if (new.class) {
    # Create a new class:
    j <- length(tree.classes) + 1
    tree.classes[[j]] <- list()
    tree.classes[[j]][[1]] <- reorder(tr)
  }
}

lapply(tree.classes, length)
plot(tree.classes[[1]][[1]])
plot(tree.classes[[2]][[1]])
plot(tree.classes[[3]][[1]])
plot(tree.classes[[4]][[1]])
plot(tree.classes[[5]][[1]])

# Compute average branch lengths per classes:
library(plyr)
library(phangorn)
av.tree <- function(trees) {
  avt <- trees[[1]]
  avt$edge.length <- colMeans(ldply(trees, function(tree) return(tree$edge.length)))
  return(midpoint(avt))
}

av.trees <- llply(tree.classes, av.tree)
class(av.trees) <- "multiPhylo"

# Make a figure:
library(ggtree)
library(cowplot)

get.tree.plot <- function(tree, freq) {
  p <- ggplot(tree, aes(x, y)) + theme_tree(plot.title = element_text(hjust = 0.5)) + xlim(0, 0.025)
  p <- p + geom_tree(layout = "rectangular") + geom_treescale(x = 0, y = 4.5)
  p <- p + geom_tiplab()
  p <- p + ggtitle(paste(freq, "trees"))
  return(p)
}

p.t0 <- ggplot(ctree, aes(x, y)) + xlim(0, 5) +
  geom_tree(layout = "rectangular") +
  ggtitle("Consensus topology") +
  theme_tree(plot.title = element_text(hjust = 0.5)) +
  geom_tiplab()
p.t1 <- get.tree.plot(av.trees[[1]], 852)
p.t2 <- get.tree.plot(av.trees[[2]], 85)
p.t3 <- get.tree.plot(av.trees[[3]], 58)
p.t4 <- get.tree.plot(av.trees[[4]], 2)
p.t5 <- get.tree.plot(av.trees[[5]], 2)

p.t <- plot_grid(p.t0, p.t1, p.t2, p.t3, p.t4, p.t5, nrow = 2, labels = "AUTO")
p.t

ggsave(p.t, filename = "Topologies.pdf", width = 12*0.8, height = 8*0.8)
