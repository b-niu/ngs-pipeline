       # config manta
        cmd1 = (f'{ENV.DOCKER_HEAD} '
                f'strelka2:2.9.10 '
                f'configManta.py '
                f'--normalBam {self.normal_bam} '
                f'--tumorBam {self.tumor_bam} '
                f'--referenceFasta {ENV.REF_FASTA} '
                f'--runDir {self.manta_run_dir} ')
        # manta无--targeted参数
        if args.panel in ['idt', 'haplox']:
            cmd1 = cmd1 + f'--exome --callRegions {BED_STRELKA} '
        elif args.panel in ['556', '19', '47']:
            cmd1 = cmd1 + f'--exome --callRegions {BED_STRELKA} '
        elif args.panel == 'wgs':
            cmd1 = cmd1 + f'--callRegions {BED_STRELKA} '
        else:
            logging.error("Bad panel: {args.panel}")
            raise ValueError()
        try:
            ngsfun.shell_run(cmd1)
        except subprocess.CalledProcessError:
            logging.error(f'config MANTA for {self.sample_name} failed')
            ngsfun.create_file(self.manta_error_marker)
            raise RuntimeError()
        # run manta
        cmd2 = (f'{ENV.DOCKER_HEAD} '
                f'strelka2:2.9.10 '
                f'{self.manta_run_dir}/runWorkflow.py -m local -j {args.threads}')

        # config strelka
        cmd1 = (f'{ENV.DOCKER_HEAD} '
                f'strelka2:2.9.10 '
                f'configureStrelkaSomaticWorkflow.py '
                f'--normalBam {self.normal_bam} '
                f'--tumorBam {self.tumor_bam} '
                f'--indelCandidates {self.manta_run_dir}/results/variants/candidateSmallIndels.vcf.gz '
                f'--referenceFasta {ENV.REF_FASTA} '
                f'--runDir {self.strelka_run_dir} ')
        if args.panel in ['idt', 'haplox']:
            cmd1 = cmd1 + f'--exome --callRegions {BED_STRELKA} '
        elif args.panel in ['556', '19', '47']:
            cmd1 = cmd1 + f'--targeted --callRegions {BED_STRELKA} '
        elif args.panel == 'wgs':
            cmd1 = cmd1 + f'--callRegions {BED_STRELKA} '
        else:
            logging.error("Bad panel: {args.panel}")
            raise ValueError()
        try:
            ngsfun.shell_run(cmd1)
        except subprocess.CalledProcessError:
            logging.error(f'config strelka for {self.sample_name} failed')
            ngsfun.create_file(self.strelka_error_marker)
            return 1
        # run strelka
        cmd2 = (f'{ENV.DOCKER_HEAD} '
                f'strelka2:2.9.10 '
                f'{self.strelka_run_dir}/runWorkflow.py -m local -j {args.threads}')
