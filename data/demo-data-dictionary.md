# Demo GWAS dataset

 Files:
 - `demo-genotypes.csv`: genotype matrix (rows = samples, columns = SNPs; values 0/1/2)
 - `demo-variants.csv`: variant map (`snp_id`, `chr`, `pos`, `maf`)
 - `demo-covariates.csv`: sample covariates (`sample_id`, `age`, `sex`, `PC1`, `PC2`)
 - `demo-phenotype.csv`: quantitative trait (`sample_id`, `trait`)
 - `demo-truth.csv`: teaching label indicating which SNPs were simulated as causal

 Notes:
 - Synthetic dataset intended for learning and demonstration.
 - Includes population structure via PCs so stratification can be discussed clearly.
