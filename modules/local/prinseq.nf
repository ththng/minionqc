
process PRINSEQ {
    tag "$meta.id"
    label 'process_single'

    container "https://depot.galaxyproject.org/singularity/prinseq:0.20.4--hdfd78af_5"

    input:
    tuple val (meta), path (reads)
    each quality_score

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
