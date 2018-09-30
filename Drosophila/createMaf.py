#! /usr/bin/python
# Create a MAF file from pseudo-genomes

import sys
import gzip

#Pick 10 individuals randomly
individuals = [ "ZI152", "ZI173", "ZI190", "ZI199", "ZI211", "ZI219", "ZI253", "ZI344", "ZI374", "ZI490" ]
#chromosomes = [ "X", "2L", "2R", "3L", "3R" ]
chromosomes = [ "2L" ]

with gzip.open("dpgp3_Chr2L_10indv.maf.gz", 'w') as maf:
  maf.write("##maf version=1\n")
  maf.write("#Generated from 10 pseudo genomes\n\n")

  for chrm in chromosomes:
    print("creating block for chromosome %s:" % chrm)
    maf.write("a\n")
    for indv in individuals:
      print("* adding individual %s..." % indv)
      with open("dpgp3_sequences/Chr%s/%s_Chr%s.seq" % (chrm, indv, chrm), 'r') as seqfile:
        seq = seqfile.read() 
        maf.write("s %s.%s\t0\t%d\t+\t%d\t%s\n" % (indv, chrm, len(seq), len(seq), seq))
    maf.write("\n")

print("Done.\n")

