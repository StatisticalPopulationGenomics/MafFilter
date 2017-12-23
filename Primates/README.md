Data downloaded with the command:

MAF file for 19 Mammals (16 Primates) with Human hg38:
rsync -avz --progress rsync://hgdownload.cse.ucsc.edu/goldenPath/hg38/multiz20way/maf/chr9.maf.gz .

GFF for Human hg38:
At UCSC, using the table browser: select Human hg38, group 'Genes and Gene Predictions', track 'NCBI RefSeq', position 'chr9', output format 'GTF'.

We then only keep one transcript per annotation (the first one):
gzcat chr9.gtf.gz | rev | uniq -f 7 | rev > chr9.gtf.nodup.gtf
Note: gzcat is for mac, use zcat on linux

We then only keep CDS of at least 1kb:
cat chr9.nodup.gtf | awk -F"\t" '{ if ($5-$4 > 1000 && $3 == "CDS" ) { print } }' > chr9.CDS1kb.gtf

wc -l chr9.CDS1kb.gtf
=> 146 CDS
