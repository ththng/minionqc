
process QUAST {
    label 'process_single'

    container "https://depot.galaxyproject.org/singularity/quast:5.2.0--py39pl5321heaaa4ec_4"

    input:
    path (assembly)
    path 'refseq'
    path 'features'

    output:
    path "*"

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''

    """
    quast.py $assembly -r $refseq -g $features ${args}
    """
}
