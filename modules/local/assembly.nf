
process ASSEMBLY {
    tag "$meta.id"
    label 'process_low'

    container "https://depot.galaxyproject.org/singularity/flye:2.9.2--py39hd65a603_2"

    input:
    tuple val (meta), val (prefix), path (preprocessed_reads)
    each nano_mode

    output:
    path ("*.fasta.gz")

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''

    def prefix_nano = "${prefix}_${nano_mode}"
    def assembly = prefix_nano + "/assembly.fasta"
    def assembly_renamed = prefix_nano + "_assembly.fasta"

    """
    flye -v
    flye --${nano_mode} $preprocessed_reads --out-dir ${prefix_nano} $args
    mv $assembly $assembly_renamed
    gzip $assembly_renamed
    """
}
