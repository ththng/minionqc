
process CHOPPER {
    tag "$meta.id"
    label 'process_single'

    container "https://depot.galaxyproject.org/singularity/chopper:0.5.0--hdcf5f25_2"

    input:
    tuple val (meta), path (reads)
    each quality_score

    output:
    tuple val (meta), val (prefix), path ("*.fastq.gz")

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    prefix = "${meta.id}_chopper_${quality_score}"

    """
    chopper -V
    zcat $reads | chopper -q $quality_score $args | gzip > ${prefix}.fastq.gz
    """
}
