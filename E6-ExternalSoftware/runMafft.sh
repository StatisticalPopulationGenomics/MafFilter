#! /bin/bash
if [ `grep '>' blockIn.fasta | wc -l` == "1" ];
then
  #Only one sequence in block, we pass...
  cp blockIn.fasta blockOut.fasta
else
  mafft --fft --nomemsave --maxiterate 2 --thread -1 blockIn.fasta > blockOut.fasta 2> mafft.log
fi
