\#! /bin/bash
set -e

#prelim mapping followed by minion pipeline for set of barcodes

runname=$1
ref=$2
files=${runname}_all-BC*.fastq

echo -e "sample\treads\tmapped\tbasesCovered\tbasesCoveredx20\tbasesCoveredx100" > $runname"_bc_mappingstats".txt

for f in $files
do
time(
bc=${f//[!0-9]/} ##I think this doesn't work for bc>9
mkdir -p ~/pipeline_output/minion_output/$runname/BC$bc

rabies_prelimMap.sh $ref $runname $bc

artic minion --normalise 200 --threads 4 --scheme-directory '/home2/kb157b/pipeline_output/primer-schemes' --read-file $runname"_all-BC"$bc.fastq --nanopolish-read-file $runname"_all.fastq" $runname"_prelim"/bc$bc $bc"prelimMapped"
)

#summary mapping stats
reads=$(samtools view $bc"prelimMapped.sorted.bam" | cut -f 1 | sort | uniq | wc -l) 
mapped=$(samtools view -F 4 $bc"prelimMapped.sorted.bam" | cut -f 1 | sort | uniq | wc -l) 
basesCovered=$(samtools depth $bc"prelimMapped.trimmed.sorted.bam" | awk '($3>0)' |wc -l)
basesCoveredx20=$(samtools depth $bc"prelimMapped.trimmed.sorted.bam" | awk '($3>=20)' |wc -l) 
basesCoveredx100=$(samtools depth $bc"prelimMapped.trimmed.sorted.bam" | awk '($3>=100)' |wc -l) 
echo -e $runname"_bc"$bc"\t"$reads"\t"$mapped"\t"$basesCovered"\t"$basesCoveredx20"\t"$basesCoveredx100 >>$runname"_bc_mappingstats".txt


#organise output files
mv $bc"prelimMapped"* ~/pipeline_output/minion_output/$runname/BC$bc

done
mkdir -p ~/pipeline_output/archived
mv $runname* ~/pipeline_output/archived

