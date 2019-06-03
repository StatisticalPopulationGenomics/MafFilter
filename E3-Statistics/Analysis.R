# Plot block sizes at each analysis step

res1 <- read.table("chr9.statistics1.txt", header = TRUE, stringsAsFactors = FALSE)
hist(log(res1$BlockLength))
table(res1$BlockSize)
nrow(res1)

res2 <- read.table("chr9.statistics2.txt", header = TRUE, stringsAsFactors = FALSE)
hist(log(res2$BlockLength))
table(res2$BlockSize)
nrow(res2)

res3 <- read.table("chr9.statistics3.txt", header = TRUE, stringsAsFactors = FALSE)
res4 <- read.table("chr9.statistics4.txt", header = TRUE, stringsAsFactors = FALSE)

res1$Step <- 1
res2$Step <- 2
res3$Step <- 3
res4$Step <- 4
res <- rbind(res1, res2, res3, res4)
res$Step <- factor(res$Step, levels = rev(1:4), labels = rev(c("Start", "Subset", "Merge", "Extract CDS")))
library(plyr)
resn <- ddply(res, "Step", summarize, BlockNumber = length(BlockLength))
library(ggplot2)
pnumber <- ggplot(resn, aes(x = Step, y = BlockNumber)) + geom_col() +
  scale_y_log10(labels = scales::comma) + ylab("Number of blocks") + xlab("Analysis step") + coord_flip()
pnumber

rlen <- ddply(res, "Step", summarize, TotalLength = sum(BlockLength)/1000)
library(ggplot2)
ptotlen <- ggplot(rlen, aes(x = Step, y = TotalLength)) + geom_col() +
  scale_y_log10(labels = scales::comma) + ylab("Alignment length (kb)") + xlab("") + coord_flip()
ptotlen

psize <- ggplot(res, aes(x = Step, y = BlockSize)) + geom_boxplot() +
  ylab("Number of sequences in blocks") + xlab("") + coord_flip()
psize

plength <- ggplot(res, aes(x = Step, y = BlockLength)) + geom_boxplot() + 
  scale_y_log10() + xlab("") + ylab("Length of blocks (bp)") + coord_flip()
plength

library(cowplot)
p <- plot_grid(pnumber, psize, plength, ptotlen, ncol = 2, labels = "AUTO", align = "h")
p

ggsave(p, filename = "BlockStatistics.pdf", width=9, height=6)
