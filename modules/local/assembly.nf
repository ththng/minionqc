// TODO nf-core: If in doubt look at other nf-core/modules to see how we are doing things! :)
//               https://github.com/nf-core/modules/tree/master/modules/nf-core/
//               You can also ask for help via your pull request or on the #modules channel on the nf-core Slack workspace:
//               https://nf-co.re/join
// TODO nf-core: A module file SHOULD only define input and output files as command-line parameters.
//               All other parameters MUST be provided using the "task.ext" directive, see here:
//               https://www.nextflow.io/docs/latest/process.html#ext
//               where "task.ext" is a string.
//               Any parameters that need to be evaluated in the context of a particular sample
//               e.g. single-end/paired-end data MUST also be defined and evaluated appropriately.
// TODO nf-core: Software that can be piped together SHOULD be added to separate module files
//               unless there is a run-time, storage advantage in implementing in this way
//               e.g. it's ok to have a single module for bwa to output BAM instead of SAM:
//                 bwa mem | samtools view -B -T ref.fasta
// TODO nf-core: Optional inputs are not currently supported by Nextflow. However, using an empty
//               list (`[]`) instead of a file can be used to work around this issue.

process ASSEMBLY {
    // tag "$meta.id"
    label 'process_single'

    container "https://depot.galaxyproject.org/singularity/flye:2.9.2--py39hd65a603_2"

    input:
    tuple val (qc_mode), path (preprocessed_reads)
    each nano_mode
    
    output:
    //tuple val ("${qc_mode}_${nano_mode}"), path ("${qc_mode}_${nano_mode}/assembly.fasta")
    //path "${qc_mode}_${nano_mode}/assembly.fasta"

    path assembly_renamed

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    // def prefix = task.ext.prefix ?: "${meta.id}"

    assembly = qc_mode + "_" + nano_mode + "/assembly.fasta"
    assembly_renamed = qc_mode + "_" + nano_mode + "_assembly.fasta"

    """
    flye -v
    flye --${nano_mode} $preprocessed_reads -g $params.genome_size --out-dir ${qc_mode}_${nano_mode}
    cp $assembly $assembly_renamed
    """
}
