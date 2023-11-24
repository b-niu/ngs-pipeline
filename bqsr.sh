# GATK is installed using miniconda3.

gatk --java-options {RAM} \
  BaseRecalibrator \
  -R {ENV.REF_FASTA} \
  -I {self.dedup_bam} \
  --known-sites {ENV.DBSNP} \
  --known-sites {ENV.MILLS_INDEL} \
  -O {self.bqsr_table} \
  -L {BED} -ip {IP}

# IP means BED interval padding.

gatk --java-options {RAM} \
  ApplyBQSR \
  -bqsr {self.bqsr_table} \
  -I {self.dedup_bam} \
  -O {self.recal_bam} \
  -R {ENV.REF_FASTA}
  
