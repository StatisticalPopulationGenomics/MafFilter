# Created on 28/09/18 by jdutheil

anno <- read.table("../Primates/chr9.CDS1kb.gtf", sep = "\t")
tln <- read.table("hg38_to_gorGor3.tln", header = TRUE)
#GTF annotation are 1 based, inclusive [a,b], while maffilter uses 0-based, exclusive coordinates [a,b[
#We convert everything to GFF system:
tln$begin.ref <- tln$begin.ref + 1
tln$begin.target <- tln$begin.target + 1
anno2 <- merge(anno, tln, by.x = c(1,4,5), by.y = c(1,3,4), all = TRUE)
