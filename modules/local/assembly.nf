// TODO nf-core: A module file SHOULD only define input and output files as command-line parameters.
//               All other parameters MUST be provided using the "task.ext" directive, see here:
//               https://www.nextflow.io/docs/latest/process.html#ext
//               where "task.ext" is a string.
//               Any parameters that need to be evaluated in the context of a particular sample
//               e.g. single-end/paired-end data MUST also be defined and evaluated appropriately.

process ASSEMBLY {
    tag "$meta.id"
    label 'process_low'

    container "https://depot.galaxyproject.org/singularity/flye:2.9.2--py39hd65a603_2"

    input:
    tuple val (meta), val (prefix), path (preprocessed_reads)
    each nano_mode
    
    output:
    //tuple val (meta), path ("*.fasta")
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
    flye --${nano_mode} $preprocessed_reads -g $params.genome_size --out-dir ${prefix_nano} $args
    mv $assembly $assembly_renamed
    gzip $assembly_renamed
    """
}
