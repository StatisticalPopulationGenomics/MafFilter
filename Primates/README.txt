This file is from:

    http://hgdownload.cse.ucsc.edu/goldenPath/hg38/multiz20way/README.txt

This directory contains compressed multiple alignments of the 
following assemblies to the human genome (hg38/GRCh38, Dec. 2013):

Assemblies used in these alignments:                                 (alignment
                                                                           type)

Human - Homo sapiens               Dec. 2013 (GRCh38/hg38)            reference

Baboon - Papio anubis              Mar. 2012 (Baylor Panu_2.0/papAnu2)  syntenic
Bushbaby - Otolemur garnettii      Mar. 2011 (Broad/otoGar3)     reciprocal best
Bonobo - Pan paniscus             May. 2012 (Max-Planck/panPan1) reciprocal best
Chimp - Pan troglodytes            Feb. 2011 (CSAC 2.1.4/panTro4)      syntenic
Crab-eating macaque - Macaca fascicularis
                          Jun 2013 (Macaca_fascicularis_5.0/macFas5)  syntenic
Gibbon - Nomascus leucogenys       Oct. 2012 (GGSC Nleu3.0/nomLeu3)    syntenic
Golden snub-nosed monkey - Rhinopithecus roxellana
                          Oct. 2014 (Rrox_v1/rhiRox1)           reciprocal best
Gorilla - Gorilla gorilla gorilla  May 2011 (gorGor3.1/gorGor3) reciprocal best
Green monkey - Chlorocebus sabaeus
                          Mar. 2014 (Chlorocebus_sabeus 1.1/chlSab2)  syntenic
Marmoset - Callithrix jacchus      Mar. 2009 (WUGSC 3.2/calJac3)     syntenic
Mouse lemur - Microcebus murinus   Jul. 2007 (Broad/micMur1) reciprocal best
Orangutan - Pongo pygmaeus abelii  Jul. 2007 (WUGSC 2.0.2/ponAbe2)   syntenic
Proboscis monkey - Nasalis larvatus
                          Nov. 2014 (Charlie1.0/nasLar1)        reciprocal best
Rhesus - Macaca mulatta            Oct. 2010 (BGI CR_1.0/rheMac3)      syntenic
Squirrel monkey - Saimiri boliviensis Oct. 2011 (Broad/saiBol1) reciprocal best
Tarsier - Tarsius syrichta
                   Sep. 2013 (Tarsius_syrichta-2.0.1/tarSyr2) reciprocal best
Tree shrew - Tupaia belangeri      Dec. 2006 (Broad/tupBel1) reciprocal best
Mouse  -  Mus musculus             Dec. 2011 (GRCm38/mm10) syntenic
Dog  -  Canis lupus familiaris     Sep. 2011 (Broad CanFam3.1/canFam3) syntenic

---------------------------------------------------------------

These alignments were prepared using the methods described in the
track description file:
http://genome.ucsc.edu/cgi-bin/hgTrackUi?db=hg38&g=cons20way
based on the phylogenetic tree: hg38.20way.nh


Files in this directory:
 - hg38.20way.nh - phylogenetic tree used during the multiz multiple alignment
 - hg38.20way.commonNames.nh - same as hg38.20way.nh with the UCSC database
       name replaced by the common name for the species
 - hg38.20way.scientificNames.nh - same as hg38.20way.nh with the UCSC database
       name replaced by the scientific name for the species
 - upstream1000.knownGene.maf.gz - alignments in regions upstream, see below
 - upstream2000.knownGene.maf.gz - alignments in regions upstream, see below
 - upstream5000.knownGene.maf.gz - alignments in regions upstream, see below
 - md5sum.txt - MD5 sum of the files to verify downloads

    See also:
http://genomewiki.ucsc.edu/index.php/Hg38_20-way_conservation_alignment

The "alignments" directory contains compressed FASTA alignments
for the UCSC Known Gene CDS regions of the human genome
(hg38, Dec. 2013) aligned to the assemblies.  Additional
alignment files are provided for RefSeq genes, and the
UCSC Known Gene canonical genes.

The "maf" directory contains the alignments to
the human assembly, with additional annotations to
indicate gap context, and genomic breaks for the
sequence in the underlying genome assemblies.  Beware, the compressed
data size of the files in the 'maf' directory is 12 Gb,
uncompressed is approximately 91 Gb.

The upstream*.maf.gz files contain alignments in regions upstream of
annotated transcription starts for UCSC Known Genes with annotated 5' UTRs.
These files differ from the standard MAF format: they display
alignments that extend from start to end of the upstream region in 
mouse, whether or not alignments actually exist. In situations where no  
alignments exist or the alignments of one or more species are missing, 
dot (".") is used as a placeholder. Multiple regions of an assembly's
sequence may align to a single region in the human sequence; therefore,
only the species name is displayed in the alignment data and no position
information is recorded. The alignment score is always zero in these files.

For a description of multiple alignment format (MAF), see
http://genome.ucsc.edu/goldenPath/help/maf.html.

PhastCons conservation scores for these alignments are available at:
http://hgdownload.cse.ucsc.edu/goldenPath/hg38/phastCons20way

PhyloP conservation scores for these alignments are available at:
http://hgdownload.cse.ucsc.edu/goldenPath/hg38/phyloP20way

---------------------------------------------------------------
To download a large file or multiple files from this directory, we recommend 
that you use rsync or ftp rather than downloading the files via our website.
There is approximately 31 Gb of compressed data in this directory.

Via rsync:
rsync -avz --progress \
	rsync://hgdownload.cse.ucsc.edu/goldenPath/hg38/multiz20way/ ./

Via FTP:
    ftp hgdownload.cse.ucsc.edu 
    user name: anonymous
    password: <your email address>
    go to the directory goldenPath/hg38/multiz20way

To download multiple files from the UNIX command line, use the "mget" command. 
    mget <filename1> <filename2> ...
    - or -
    mget -a (to download all the files in the directory) 
Use the "prompt" command to toggle the interactive mode if you do not want 
to be prompted for each file that you download.

---------------------------------------------------------------
All the files in this directory are freely usable for any 
purpose. For data use restrictions regarding the individual 
genome assemblies, see http://genome.ucsc.edu/goldenPath/credits.html.
---------------------------------------------------------------
