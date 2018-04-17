# Created on 14/04/18 by jdutheil
require(ggplot2)
require(cowplot)

# Read the statistics:
stats.div <- read.table("dpgp3_Chr2L_10indv.diversity_statistics.txt", header = TRUE, stringsAsFactors = FALSE)
stats.div$Mid <- with(stats.div, (Stop + Start) / 2)

# Filter windows with too many unresolved positions:
stats.div <- subset(stats.div, SiteFrequencySpectrum.Unresolved < 1000)

# Look at the site frequency spectrum:
sfs <- stats.div[, c("SiteFrequencySpectrum.Bin2", "SiteFrequencySpectrum.Bin3", "SiteFrequencySpectrum.Bin4", "SiteFrequencySpectrum.Bin5", "SiteFrequencySpectrum.Bin6")]
sfs <- colSums(sfs)
dat.sfs <- data.frame(Frequency = c("1/10", "2/10", "3/10", "4/10", "5/10"),
                      Count = sfs)

p.sfs <- ggplot(dat.sfs, aes(x = Frequency, y = Count))
p.sfs <- p.sfs + geom_col() + ylab("Number of sites") + ggtitle("Site frequency spectrum")
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

p <- plot_grid(p.sfs, p.div, p.tdh, labels = "AUTO", nrow = 1, align = "h")
p

ggsave(p, filename = "DrosopĥilaDiversity.pdf", width = 14, height = 6)
