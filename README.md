mitoProtocol
======

mitoProtocol is an example read processing protocol that utilizes `bwa mem`, `samtools`, `IGV`, `seqkit`, and a `custom R script` for mitochondrial DNA (mtDNA) sequence viewing and analysis. Example data were obtained from NCBI SRA using `fastq-dump`.

Step 1: Obtaining source data
------

The [NCBI SRA Toolkit](https://trace.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?view=software) (Compiled binaries of June 27, 2018, version 2.9.1-1 release) was first downloaded and installed locally to obtain source data from SRA. Sequence data were obtained from accession # [SRR4420340](https://trace.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?run=SRR4420340 ), corresponding to the following study published in [PLos ONE](http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0167600). The sample with the highest mean coverage value was selected for processing.

In the terminal, within the top-level folder `mitoProtocol/`:

```bash
~/sratoolkit.2.9.1-1-mac64/bin/fastq-dump SRR4420340
```

Reference mitochondrial genome data were manually copied from NCBI Nucleotide, accession # [NC_012920.1](https://www.ncbi.nlm.nih.gov/nuccore/NC_012920.1?report=fasta), and moved to directory `mitoProtocol/mito_genome`.

Step 2: Data processing for viewing in IGV
------

[Samtools](http://www.htslib.org/) (v1.8) and [bwa](http://bio-bwa.sourceforge.net/) (v0.7.17) were downloaded from the [bioconda](https://bioconda.github.io/) repository using [conda](https://conda.io/docs/index.html), by entering `conda install samtools` and `conda install bwa` in the terminal, respectively.

*NOTE: Although [poretools](http://poretools.readthedocs.io/en/latest/) was used for FASTA data processing in the original protocol, it was not used for this example protocol. Original study data was filtered by strand length using `poretools`, e.g. `poretools fasta --max-length 3875`*.

To sort and index **SRR4420340** against reference mitochondrial genome **NC_012920.1**, with both FASTA/FASTQ files located in `mito_sample/`:

```bash
cd mito_sample/
bwa index NC_012920.1.fasta
bwa mem mito_genome/NC_012920.1.fasta mito_sample/SRR4420340.fastq | samtools sort -o SRR4420340_sorted.bam
samtools index SRR4420340_sorted.bam
```

Sorted BAM file **SRR4420340_sorted.bam** is now viewable using [IGV](https://software.broadinstitute.org/software/igv/download). For this protocol, version 2.4.11 was used.

Step 3: Data processing for analysis using seqkit
------

[SeqKit](https://bioinf.shenwei.me/seqkit/download/) version 0.8.1 was downloaded from bioconda via `conda install -c bioconda seqkit`. Example template motif file **mtnd1_3308** was created in `motif_templates/` using `vim` to screen example mtDNA data for variant **NC_012920.1:m.3308T>G (GRCh38)** in gene **MTND1**, which has been [previously observed in patients with Sudden Infant Death Syndrome (SIDS)](https://www.ncbi.nlm.nih.gov/clinvar/variation/9729/#supporting-observations)

To find strand lengths and motifs from source FASTQ data using `seqkit`:

```bash
seqkit locate mito_sample/SRR4420340.fastq -P -f motif_templates/mtnd1_3308 > mito_output_1.tsv
seqkit fx2tab mito_sample/SRR4420340.fastq -H -l -n -i > mito_output_2.tsv
```

To collect and merge output `seqkit` data (.tsv format):

```bash
mkdir output_data
mv mito_output_1.tsv output_data/
mv mito_output_2.tsv output_data/
```

In MS Excel, column 1 of “mito_output_2.tsv” was then manually renamed to ‘seqID’ for simple merging of the two output .tsv files via `Rscript join_mito_data.R`. [R base version 3.4.3](https://www.r-project.org/) was using in conjunction with [RStudio version 1.1.383](https://www.rstudio.com/) for script writing.

Final output file is then viewable under filename **mito_joined.tsv** in `mitoProtocol/output_data`.
