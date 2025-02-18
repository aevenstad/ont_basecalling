process DOROADO_BASECALL {
    tag "${params.sample_id}"
    publishDir "${params.output_dir}/dorado/", mode: 'copy'

    input:
    file pod5

    output:
    path("${params.sample_id}_basecalled.fastq.gz")             , emit: fastq
    path "versions.yml"                                         , emit: versions

    script:
    """
    ${params.dorado} basecaller sup \\
    --emit-fastq \\
    --device cuda:0 \\
    ${pod5} |\\
    gzip > ${params.sample_id}_basecalled.fastq.gz
    """
}

process DORADO_DEMUX {
    tag "${params.sample_id}"
    publishDir "${params.output_dir}/dorado/", mode: 'copy'

    input:
    path fastq

    output:
    path("demux_fastq")

    script:
    """
    ${params.dorado} demux \\
    --kit-name ${params.barcode_kits} \\
    --emit-fastq \\
    --output-dir demux_fastq \\
    ${fastq}
    """
}

workflow {
    pod5_dir = Channel.fromPath(params.pod5)
    
    DOROADO_BASECALL(pod5_dir)
    fastq_ch = DOROADO_BASECALL.OUT.fastq

    DORADO_DEMUX(fastq_ch)
}