# ONT Basecalling
A simple Nextflow pipeline to do basecalling and demultiplexing of Oxford Nanopore raw data.

  
Current steps:
* Basecalling with `Dorado v0.9.1` in `sup` mode
* Demultiplexing with `dorado demux`


## TODO
* Configure to use singularity container for Dorado
* Improve info printed to terminal
* Run QC after demultiplexing?
* Check fastqs?
