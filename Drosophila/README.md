Data from DPGP3 http://www.johnpool.net/genomes.html (accessed 28/02/18)
Unpack all, remove mac file and reorganize in folders.

Get list of all individuals:
```{bash}
ls -ls dpgp3_sequences/Chr2L | grep -Po --only-matching "Z\w*(?=_C)"
```

We take 10 randomly:
ZI152
ZI173
ZI190
ZI199
ZI211
ZI219
ZI253
ZI344
ZI374
ZI490
and we created a Maf file from the pseudogenomes. For the sake of this example,
we only use Chr2L, but the script can be edited to include other chromosomes as well:

```{bash}
python createMaf.py
```
This creates file `dpgp3_Chr2L_10indv.maf.gz`. As this files contains only one long block,
     we split it up for later processing:

```{bash}
maffilter param=MafFilter-Split.bpp
```
This step takes a bit of time (~10min), as the full block as to be loaded in memory at once.
The resulting file, named `dpgp3_Chr2L_10indv.split.maf.gz` is used for further analyses and is included in this directory.


