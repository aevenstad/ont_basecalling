process DOROADO_BASECALL {
    tag "${params.sample_id}"
    publishDir "${params.outdir}", mode: 'copy'

    input:
    file pod5

    output:
    path("${params.sample_id}_basecalled.fastq.gz")             , emit: fastq
    path "versions.yml"                                         , emit: versions

    script:
    """
    ${params.dorado} basecaller ${params.dorado_mode} \\
    --emit-fastq \\
    --device cuda:0 \\
    --kit-name ${params.barcode_kit} \\
    ${pod5} | \\
    gzip > ${params.sample_id}_basecalled.fastq.gz

    VER=\$(${params.dorado} --version 2>&1)
    echo "dorado: \$VER" > versions.yml
    """
}

process DORADO_DEMUX {
    tag "${params.sample_id}"
    publishDir "${params.outdir}", mode: 'copy'

    input:
    path fastq

    output:
    path("demux_fastq")

    script:
    """
    ${params.dorado} demux \\
    --kit-name ${params.barcode_kit} \\
    --emit-fastq \\
    --output-dir demux_fastq \\
    ${fastq}
    """
}

workflow {
    pod5_dir = Channel.fromPath(params.pod5)

    println "Running dorado basecalling in '${params.dorado_mode}' mode (this step might take a while)"
    println "Basecalling pod5 files in:                   ${params.pod5}"    

    DOROADO_BASECALL(pod5_dir)
    fastq_ch = DOROADO_BASECALL.out.fastq

    println "Demultiplexing barcodes using kit:           ${params.barcode_kit}"
    DORADO_DEMUX(fastq_ch)
}
