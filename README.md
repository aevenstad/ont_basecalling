# ONT Basecalling
A simple Nextflow pipeline to do basecalling and demultiplexing of Oxford Nanopore raw data.

  
Current steps:
* Basecalling with `Dorado v0.9.1` in `sup` mode
* Demultiplexing with `dorado demux`

## Usage
The pipeline takes as input the directory with the pod5 raw data.
All basecalled sequences is stored in a compressed fastq file in the output directory:
```
${OUTDIR}/${RUN_ID}_basecalled.fastq.gz
```
This file is then demultiplexed using the barcode kit `SQK-RBK114-24` as default. Demultiplexed fastq files are then stored in the directory 
```
${OUTDIR}/demux_fastq
```

The pipeline can be run using the command:
```
nextflow run ont_basecalling/main.nf --pod5 /path/to/pod5/ --outdir $OUTIR --sample_id $RUN_ID
```


## TODO
* Configure to use singularity container for Dorado
* Improve info printed to terminal
* Run QC after demultiplexing?
* Check fastqs?
