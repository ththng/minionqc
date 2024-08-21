## Introduction

**nf-core/minionqc** is a bioinformatics pipeline that applies the filtering tools Chopper and PRINSEQ to sequencing data (fastq format), assembles these preprocessed reads using Flye and compares the resulting assemblies using QUAST.

1. The pipeline filters reads using Chopper (https://github.com/wdecoster/chopper) or PRINSEQ (https://prinseq.sourceforge.net/manual.html) or does not apply any filtering. Filtering is done on the minimum average phred score of the reads using the thresholds 13, 15, 16 and 17.
2. It assembles the preprocessed sequencing data using Flye (https://github.com/fenderglass/Flye). Three assemblies are done for one fastq file, using the Flye options nano-raw, nano-corr and nano-hq, respectively.
3. Finally, it compares the resulting assemblies using QUAST (https://github.com/ablab/quast).

## Usage

All data needed to run this pipeline are provided through an external link. There you can find the folder `data` which is supposed to replace the empty [data](data) folder from this repo.
In this folder you will find:
- A samplesheet and sequencing data.
- The reference genome and the genomic features file. They are used in the QUAST process. They are set in the [nextflow.config](nextflow.config) file to be used in the pipeline.
- The estimated genome size that is provided to Flye can also be found as parameter in the [nextflow.config](nextflow.config) file.

If you want to use these default data, you can run the pipeline as follow:<br>
You need to be in the root folder of this project (`nf-core-minionqc`) to run the pipeline using

```bash
nextflow run main.nf -profile singularity
```
<br>

To run the pipeline with your own input data, you can provide your own data and prepare a samplesheet that looks as follows:

`samplesheet.csv`:

```csv
sample,fastq
sampleId,pathToSample.fastq.gz
```

Each row represents a fastq file.

Additionally you can provide your own estimated genome size, reference genome and genomic features file.

To use your own data, you can provide them as parameters (or simply replace the respective default values in the [nextflow.config](nextflow.config) file)
```bash
nextflow run main.nf \
  -profile singularity \
  --input pathToSampleshee/samplesheet.csv \
  --quast_refseq pathToRefseq/refseq.fna \
  --quast_features pathToGenomic/genomic.gff \
  --genome_size <your estimated genome size>
```

## Pipeline output

As the desired output is the report created by QUAST, the report can be found in the [results/quast/quast_results](results/quast/quast_results) folder after a successful run.

## Own work
Since the project was created using nf-core it still contains some boilerplate code. The own work can be found in the folders [workflows](workflows), [subworkflows/local](subworkflows/local) and [modules/local](modules/local) (Except for the files [samplesheet_check.nf](modules/local/samplesheet_check.nf) and [input_check.nf](subworkflows/local/input_check.nf) - they only were adjusted to the specific needs of this pipeline). The only boilerplate config files that were used are [nextflow.config](nextflow.config) and [modules.config](conf/modules.config).

This pipeline uses code and infrastructure developed and maintained by the [nf-core](https://nf-co.re) community, reused here under the [MIT license](https://github.com/nf-core/tools/blob/master/LICENSE).

> The nf-core framework for community-curated bioinformatics pipelines.
>
> Philip Ewels, Alexander Peltzer, Sven Fillinger, Harshil Patel, Johannes Alneberg, Andreas Wilm, Maxime Ulysse Garcia, Paolo Di Tommaso & Sven Nahnsen.
>
> Nat Biotechnol. 2020 Feb 13. doi: 10.1038/s41587-020-0439-x.
> In addition, references of tools and data used in this pipeline are as follows:

