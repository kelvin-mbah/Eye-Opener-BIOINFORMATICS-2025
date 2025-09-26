markdown
# Week 1: Manual Bioinformatics Analysis

## The "Hard Way" That Taught Me Fundamentals

### How I Felt
"Wait, I have to run HOW MANY commands just for one sample? This is very stressful!"

### What I Actually Did

#### 1. Download the Data
bash
fastq-dump --split-files ERR5743893

#### 2. Quality Control
fastqc ERR5743893_1.fastq ERR5743893_2.fastq --outdir QC_Reports
multiqc .
WHAT I LEARNED : fastQC shows per-base quality, while multiQC combines all reports beautifully.

#### 3. Mapping- (where things got real)
# Indexing the reference
bwa index MN908947.fasta

# Alignment (this took forever to understand!)
bwa mem MN908947.fasta ERR5743893_1.fastq ERR5743893_2.fastq > Mapping/ERR5743893.sam

# SAM to BAM conversion
samtools view -@ 20 -S -b Mapping/ERR5743893.sam > Mapping/ERR5743893.bam

# Sorting and indexing
samtools sort -@ 4 -o Mapping/ERR5743893.sorted.bam Mapping/ERR5743893.bam
samtools index Mapping/ERR5743893.sorted.bam

#### 4. Variant Calling- (I was excited to do this!)
freebayes -f MN908947.fasta Mapping/ERR5743893.sorted.bam > ERR5743893.vcf
bgzip ERR5743893.vcf
tabix ERR5743893.vcf.gz
bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\t%QUAL\n' ERR5743893.vcf.gz > freebayes_variants.tsv
column -t freebayes_variants.tsv | head -10
WHAT I LEARNED: I can actually use a tool called bcftools to check how many variant and also to convert to a readable TSV file. Also i can aswell use an online IGV tool to see this variant visually.
RESULTS: I found 76 variants and their positions.

### PROBLEM: But then i thought: 'Okay, Great......but how do i analyze 5 samples? Do i really have to repeat this 5 times?'
### Time Spent: 30 minutes
### Samples Analyzed: 1
### Frustration level: Medium
### Key Insights from Working Manually
1. I understand what each tool does by looking them up online and how to install using the anaconda repository
2. Error messages makes sense because i got them with minor error in my file system
3. I appreciated automation after experiencing manual labor
4. Troubleshooting skills developed through pain and frustration.

### Files I Worked With
1. ERR5743893_1.fastq, ERR5743893_2.fastq----Sequencing paired end reads
2. MN908947.fasta -----SARS-COV-2-reference genome
3. ERR5743893.sorted.bam ----- Aligned reads
4. ERR5743893.vcf.gz ------ Variant calls




