#!/usr/bin/env bash

# Run a command in docker containers:
docker run --rm -v /data:/data -v /home/:/home/ -v $(pwd):$(pwd) -w $(pwd) \
  -u $(id -u):$(id -g) \
  image_name:imgage_tag \
  command


# Use bwa and sambamba

read_group_info = fr"@RG\tID:group1\tSM:{self.name}\tPL:illumina\tLB:lib1\tPU:unit1"

bwa mem -t {args.threads} -M -R "{self.read_group_info}" {ENV.REF_FASTA} {self.fq1 } {self.fq2} | \
  sambamba view -f bam -S -l 0 -t {args.threads} /dev/stdin | \
  sambamba sort -m {MEMORY_USE}GB --tmpdir . -o {self.output_bam} -l 5 -t {args.threads} /dev/stdin \
  && sambamba index {self.output_bam}
