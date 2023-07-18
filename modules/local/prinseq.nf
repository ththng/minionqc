// TODO nf-core: A module file SHOULD only define input and output files as command-line parameters.
//               All other parameters MUST be provided using the "task.ext" directive, see here:
//               https://www.nextflow.io/docs/latest/process.html#ext
//               where "task.ext" is a string.
//               Any parameters that need to be evaluated in the context of a particular sample
//               e.g. single-end/paired-end data MUST also be defined and evaluated appropriately.

process PRINSEQ {
    tag "$meta.id"
    label 'process_single'

    container "https://depot.galaxyproject.org/singularity/prinseq:0.20.4--hdfd78af_5"

    input:
    tuple val (meta), path (reads)
    each quality_score

    // TODO nf-core: Where applicable all sample-specific information e.g. "id", "single_end", "read_group"
    //               MUST be provided as an input via a Groovy Map called "meta".
    //               This information may not be required in some instances e.g. indexing reference genome files:
    //               https://github.com/nf-core/modules/blob/master/modules/nf-core/bwa/index/main.nf
    //tuple val(meta), path(bam)

    output:
    tuple val (meta), val (prefix), path ("*.fastq.gz")

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    prefix = "${meta.id}_prinseq_${quality_score}"

    """
    prinseq-lite.pl -version
    zcat $reads | prinseq-lite.pl -fastq stdin -min_qual_mean ${quality_score} -out_good ${prefix} ${args}
    gzip ${prefix}.fastq
    """
}
