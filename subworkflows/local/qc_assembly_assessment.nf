//
// Workflow containing the application of the different qc tools, genome assembly and quality assessment for one sample
//

include { CHOPPER                     } from '../../modules/local/chopper'
include { PRINSEQ                     } from '../../modules/local/prinseq'
include { NOQC                        } from '../../modules/local/noqc'
include { ASSEMBLY                    } from '../../modules/local/assembly'
include { QUAST                       } from '../../modules/local/quast'

workflow QC_ASSEMBLY_ASSESSMENT {
    take:
    sample

    main:
    //
    // MODULE: CHOPPER
    //
    chopper_ch = CHOPPER(sample, params.quality_modes)

    //
    // MODULE: PRINSEQ
    //
    prinseq_ch = PRINSEQ(sample, params.quality_modes)

    //
    // MODULE: NOQC
    //
    noqc_ch = NOQC(sample)

    // Concatenate all items emitted by the different QC Tools
    qc_output_ch = chopper_ch
        .concat(prinseq_ch, noqc_ch)

    //
    // MODULE: FLYE ASSEMBLY
    //
    assembly_ch = ASSEMBLY (qc_output_ch, params.nano_modes)

    // Collect all assembly.fasta files to one object, that is solely emitted
    collected_assemblies_ch = assembly_ch
        .collect()

    //
    // MODULE: QUAST ANALYSIS
    //
    quast_refseq_ch = Channel.fromPath(params.quast_refseq)
    quast_features_ch = Channel.fromPath(params.quast_features)
    quast_output_ch = QUAST(collected_assemblies_ch, quast_refseq_ch, quast_features_ch)
}