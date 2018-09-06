# Created on 18/04/18 by jdutheil

# Read the statistics:
stats.model <- read.table("chr9.model-statistics.csv", header = TRUE, stringsAsFactors = FALSE)
stats.model$Mid <- with(stats.model, (Stop + Start) / 2)

stats.model$GCobs.hs <- with(stats.model, (Counts.hs.G + Counts.hs.C) / (Counts.hs.A + Counts.hs.C + Counts.hs.G + Counts.hs.T))
stats.model$GCobs.pp <- with(stats.model, (Counts.pp.G + Counts.pp.C) / (Counts.pp.A + Counts.pp.C + Counts.pp.G + Counts.pp.T))
stats.model$GCobs.pt <- with(stats.model, (Counts.pt.G + Counts.pt.C) / (Counts.pt.A + Counts.pt.C + Counts.pt.G + Counts.pt.T))
stats.model$GCobs.gg <- with(stats.model, (Counts.gg.G + Counts.gg.C) / (Counts.gg.A + Counts.gg.C + Counts.gg.G + Counts.gg.T))
stats.model$GCobs.pa <- with(stats.model, (Counts.pa.G + Counts.pa.C) / (Counts.pa.A + Counts.pa.C + Counts.pa.G + Counts.pa.T))
stats.model$GCobs.all <- with(stats.model, (Counts.all.G + Counts.all.C) / (Counts.all.A + Counts.all.C + Counts.all.G + Counts.all.T))

# Compare GC content in all extant species:
library(corrgram)
corrgram(stats.model[, c("GCobs.hs", "GCobs.pp", "GCobs.pt", "GCobs.gg", "GCobs.pa")],
         order=TRUE, lower.panel=panel.pts,
         upper.panel=panel.ellipse, text.panel=panel.txt,
         main="GC content")

# => all extremely correlated, we take the average

library(reshape2)
library(ggplot2)
library(cowplot)

stats.gc <- stats.model[, c("Mid", "GCobs.all", "MLModelFit.HKY85.theta_1", "MLModelFit.Full.theta")]
stats.gc <- melt(stats.gc, id.vars = "Mid")
stats.gc$GC <- factor(stats.gc$variable,
                      levels = c("GCobs.all", "MLModelFit.HKY85.theta_1", "MLModelFit.Full.theta"),
                      labels = c("Observed", "Equilibrium", "Ancestral"))
p.gc <- ggplot(stats.gc, aes(x = Mid/1e6, y = value))
p.gc <- p.gc + geom_point(aes(col = GC), alpha = 0.5) + geom_smooth(aes(col = GC))
p.gc <- p.gc + theme(legend.position = "top") + ylab("Value") + xlab("Position (Mb)")
p.gc

d1 <- stats.model[, c("Mid", "MLModelFit.HKY85.theta1_1")]; names(d1)[2] <- "Value"; d1$Param <- "A / (A + T)"; d1$Type <- "Equilibrium"
d2 <- stats.model[, c("Mid", "MLModelFit.HKY85.theta2_1")]; names(d2)[2] <- "Value"; d2$Param <- "G / (G + C)"; d2$Type <- "Equilibrium"
d3 <- stats.model[, c("Mid", "MLModelFit.Full.theta1")]; names(d3)[2] <- "Value"; d3$Param <- "A / (A + T)"; d3$Type <- "Ancestral"
d4 <- stats.model[, c("Mid", "MLModelFit.Full.theta2")]; names(d4)[2] <- "Value"; d4$Param <- "G / (G + C)"; d4$Type <- "Ancestral"
d5 <- stats.model[, c("Mid", "MLModelFit.HKY85.kappa_1")]; names(d5)[2] <- "Value"; d5$Param <- "Ts / Tv"; d5$Type <- ""
stats.op <- rbind(d1, d2, d3, d4, d5)

p.op <- ggplot(stats.op, aes(x = Mid / 1e6, y = Value))
p.op <- p.op + geom_point(aes(col = Type), alpha = 0.5) + geom_smooth(aes(col = Type))
p.op <- p.op + scale_color_manual(values = c(Ancestral = "#619CFF", Equilibrium = "#00BA38", "black"))
p.op <- p.op + facet_grid(Param+Type~., scales = "free_y") + guides(color = FALSE) + xlab("Position (Mb)")
p.op

pp <- plot_grid(p.op, p.gc, labels = "AUTO", nrow = 1)
pp

ggsave(pp, filename = "Parameters.pdf", width = 12, height = 8)


# Compare the trees:
library(ape)
trees <- read.tree(file = "chr9.trees.dnd")

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
p.t1 <- get.tree.plot(av.trees[[1]], 767)
p.t2 <- get.tree.plot(av.trees[[2]], 55)
p.t3 <- get.tree.plot(av.trees[[3]], 54)
p.t4 <- get.tree.plot(av.trees[[4]], 3)
p.t5 <- get.tree.plot(av.trees[[5]], 4)

p.t <- plot_grid(p.t0, p.t1, p.t2, p.t3, p.t4, p.t5, nrow = 2, labels = "AUTO")
p.t

ggsave(p.t, filename = "Topologies.pdf", width = 12*0.8, height = 8*0.8)
