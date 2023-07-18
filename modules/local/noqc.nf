// TODO nf-core: A module file SHOULD only define input and output files as command-line parameters.
//               All other parameters MUST be provided using the "task.ext" directive, see here:
//               https://www.nextflow.io/docs/latest/process.html#ext
//               where "task.ext" is a string.
//               Any parameters that need to be evaluated in the context of a particular sample
//               e.g. single-end/paired-end data MUST also be defined and evaluated appropriately.

process NOQC {
    tag "$meta.id"
    label 'process_single'

    input:
    tuple val (meta), path (reads)

    output:
    tuple val (meta), val (prefix), path ("*.fastq.gz")

    when:
    task.ext.when == null || task.ext.when

    script:
    prefix = "${meta.id}_noqc"

    """
    cp $reads ${prefix}.fastq.gz
    """
}
