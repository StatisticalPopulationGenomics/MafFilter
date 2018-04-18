# Created on 14/04/18 by jdutheil
require(ggplot2)
require(cowplot)
library(plyr)

# Read the statistics:
stats.div <- read.table("dpgp3_Chr2L_10indv.diversity_statistics.txt", header = TRUE, stringsAsFactors = FALSE)
stats.div$Mid <- with(stats.div, (Stop + Start) / 2)

# Filter windows with too many unresolved positions:
stats.div <- subset(stats.div, SiteFrequencySpectrum.Unresolved < 1000)

# Look at the data filtering steps:
stats1 <- read.table("dpgp3_Chr2L_10indv.statistics1.txt", header = TRUE, stringsAsFactors = FALSE)
stats2 <- read.table("dpgp3_Chr2L_10indv.statistics2.txt", header = TRUE, stringsAsFactors = FALSE)
stats3 <- read.table("dpgp3_Chr2L_10indv.statistics3.txt", header = TRUE, stringsAsFactors = FALSE)
summary(stats1$BlockLength)
summary(stats2$BlockLength)
summary(stats3$BlockLength)
summary(stats.div$BlockLength)
stats1$Step <- 1
stats2$Step <- 2
stats3$Step <- 3
stats.div$Step <- 4
f <- c("Step", "BlockLength")
stats <- rbind(stats1[,f], stats2[,f], stats3[,f], stats.div[,f])
stats$Step <- factor(stats$Step, levels = 1:4, labels = c("Start", "Alignment\nfiltering", "Merge", "Diversity\nestimation"))
stats.sum <- ddply(.data = stats, .variables = "Step", .fun = summarize,
                   Me = median(BlockLength),
                   Lo = quantile(BlockLength, probs = 0.25),
                   Up = quantile(BlockLength, probs = 0.75),
                   Sum = sum(BlockLength),
                   Count = length(BlockLength))

#p.len <- ggplot(stats.sum, aes(x = Step, y = Me/1000))
#p.len <- p.len + geom_errorbar(aes(ymin = Lo/1000, ymax = Up/1000)) + geom_point() + xlab("") + ylab("Length of blocks (kb)")
#p.len

p.len <- ggplot(stats, aes(x = as.factor(Step), y = BlockLength/1000))
p.len <- p.len + geom_boxplot() + xlab("") + ylab("Length of blocks (kb)")
p.len

p.sum <- ggplot(stats.sum, aes(x = Step, y = Sum/1e6))
p.sum <- p.sum + geom_col() + ylab("Total alignment size (Mb)") + xlab("")
p.sum

p.cnt <- ggplot(stats.sum, aes(x = Step, y = Count))
p.cnt <- p.cnt + geom_col() + ylab("Number of blocks") + xlab("")
p.cnt

# Look at the site frequency spectrum:
sfs <- stats.div[, c("SiteFrequencySpectrum.Bin2", "SiteFrequencySpectrum.Bin3", "SiteFrequencySpectrum.Bin4", "SiteFrequencySpectrum.Bin5", "SiteFrequencySpectrum.Bin6")]
sfs <- colSums(sfs)
dat.sfs <- data.frame(Frequency = c("1/10", "2/10", "3/10", "4/10", "5/10"),
                      Count = sfs)
# Expected frequency spectrum:
theta <- mean(stats.div$SequenceDiversityStatistics.TajimaPi)
allen <- sum(stats.div$BlockLength)
sfs.theo <- numeric(5)
for (i in 1:5) sfs.theo[i] <- theta * allen * (1 / i + 1/(10 - i))
dat.sfs$Frequency.theo <- sfs.theo
library(reshape2)
dat.sfs2 <- melt(dat.sfs, id.vars = "Frequency")
dat.sfs2$SFS <- factor(dat.sfs2$variable, levels = c("Count", "Frequency.theo"), labels = c("Observed", "Expected"))

p.sfs <- ggplot(dat.sfs2, aes(x = Frequency, y = value))
p.sfs <- p.sfs + geom_col(aes(fill = SFS), position="dodge") + ylab("Number of sites") + ggtitle("Site frequency spectrum")
p.sfs <- p.sfs + scale_fill_manual(values = c("grey35", "orange"))
p.sfs <- p.sfs + theme(legend.position = c(0.6, 0.9), legend.title = element_blank())
p.sfs

# Diversity along the chromosome arm:
p.div <- ggplot(stats.div, aes(x = Mid/1e6, y = SequenceDiversityStatistics.TajimaPi))
p.div <- p.div + geom_point(col = "black", alpha = 0.5)
p.div <- p.div + geom_smooth(col = "orange")
p.div <- p.div + xlab("Position (Mb)") + ylab("Mean pairwise heterozygosity")
p.div <- p.div + ggtitle("Diversity along chromosome 2L\n(10 kb windows)")
p.div

# Distribution of Tajima's D:
p.tdh <- ggplot(stats.div, aes(x = SequenceDiversityStatistics.TajimaD, y = ..density..))
p.tdh <- p.tdh + geom_histogram()
# Fit a normal distribution for comparison:
m <- mean(stats.div$SequenceDiversityStatistics.TajimaD)
s <- sd(stats.div$SequenceDiversityStatistics.TajimaD)
x <- seq(-1.5, 1, by = 0.01)
dat.norm <- data.frame(x=x, y=dnorm(x, mean = m, sd = s))
p.tdh <- p.tdh + geom_line(data = dat.norm, aes(x=x, y=y), col = "orange")
p.tdh <- p.tdh + xlab("Tajima's D") + ylab("Density")
p.tdh <- p.tdh + ggtitle("Distribution of Tajima's D\n(10 kb windows)")
p.tdh

# Tajima's D along the chromosome:
p.tdd <- ggplot(stats.div, aes(x = Mid/1e6, y = SequenceDiversityStatistics.TajimaD))
p.tdd <- p.tdd + geom_point(col = "black", alpha = 0.5)
p.tdd <- p.tdd + geom_smooth(col = "orange")
p.tdd <- p.tdd + xlab("Position (Mb)") + ylab("Tajima's D")
p.tdd <- p.tdd + ggtitle("Tajima's D along chromosome 2L\n(10 kb windows)")
p.tdd

p <- plot_grid(p.sum + coord_flip() + scale_x_discrete(limits = rev(levels(stats.sum$Step))),
               p.cnt + coord_flip() + scale_x_discrete(limits = rev(levels(stats.sum$Step))),
               p.len + coord_flip() + scale_x_discrete(limits = rev(levels(stats.sum$Step))),
               p.sfs, p.tdh, p.tdd, NULL, NULL, p.div, labels = c("A", "B", "C", "D", "E", "F", "", "", "G"),
               nrow = 3, align = "hv")
p

ggsave(p, filename = "DrosophilaDiversity.pdf", width = 14, height = 14)
