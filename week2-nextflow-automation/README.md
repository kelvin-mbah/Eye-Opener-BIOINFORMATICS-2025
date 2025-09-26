markdown
# Week 2: Nextflow Automation - The "Aha!" Moment

## From Manual Faustration to Automation Happiness

### The Problem That Drove Me to Nextflow
I finished Week 1 and thought: "If one sample takes me 30 minutes, five samples will take me ~3hrs! There HAS to be a better way."

### Discovering Nextflow
bash
# Installation was surprisingly easy
conda create --name nextflow nextflow
conda activate nextflow

### Downloading Multiple Samples at a GO
I created a sample.txt then paste this accession numbers into it and save it.
ERR5556343
SRR13500958
ERR5743893
ERR5181310
ERR5405022
# download dataset for the sample.txt using forloop:   
for i in $(cat samples.txt);do fastq-dump --split-files $i;done
# for disk space:  
gzip *.fastq
mkdir data
mv *.fastq.gz data

### The Magic of Samplesheets---- (Important for Every run of Nextflow)
Instead of manual file management, i learned about samplesheets.
This simple csv file replaces hours of manual file organization (More Fun: There is a tool that can create it automatically)
# download pythonscript that can generate samplesheet:
wget -L https://raw.githubusercontent.com/nf-core/viralrecon/master/bin/fastq_dir_to_samplesheet.py
# Run the python script:  
python3 fastq_dir_to_samplesheet.py data samplesheet.csv -r1 _1.fastq.gz -r2 _2.fastq.gz  ; cat samplesheet.csv
# Result : what it looks like in the samplesheet.csv
sample,fastq_1,fastq_2
ERR5743893,data/ERR5743893_1.fastq.gz,data/ERR5743893_2.fastq.gz
ERR5556343,data/ERR5556343_1.fastq.gz,data/ERR5556343_2.fastq.gz

### The Nextflow Pipeline That Changed Everything (nf-core/viralrecon)
nextflow run nf-core/viralrecon -profile conda \
--max_memory '3.GB' --max_cpus 4 \
--input samplesheet.csv \
--outdir results/viralrecon \
--protocol amplicon \
--genome 'MN908947.3' \
--primer_set artic \
--primer_set_version 3 \
--skip_kraken2 \
--skip_assembly \
--skip_pangolin \
--skip_nextclade \
--skip_asciigenome \
--platform illumina \
-resume

## Interesting Features
# The Resume feature (Game changer!): 
My first run failed due to memory issues and lack of MTN data. Instead of starting over, it skipped the completed steps and continued from the failure point.
This alone justified why learning nexflow is cool and a must...LOL!
# The Result:
Duration: 41m 24s
CPU hours: 1.4 (83.6% cached)  
Succeeded: 101, Cached: 96

### Problems I Encountered and Learned From
1. Resource Management: Pipeline recommended using 12GB RAM, my laptop has 8GB (3.7GB available in WSL2)
2. File Systems Error: Got multiple error when working with my files saved in /mnt/c/users/admin/onedrive/desktop  (Windows drive). I solved it by moving files to the linux native space ~/ for better performance.
3. FreeBayes found 76 Variants, iVar found 27. This gave me a clear insight that different tools have different sensitivity levels and both are valid!

### What I Realized
Nextflow doesnt replace understanding, it builds on it. 
Automation isnt about avoiding learning the fundamentals, its about applying those fundamentals at scale.
I was happy in the end while my analysis were running without stressing me.
