#!/usr/bin/env Rscript

# ------------------------------------------------------------
# GWAS Demo Data Generator
# Synthetic genotype + phenotype + covariates
# ------------------------------------------------------------

args <- commandArgs(trailingOnly = FALSE)
file_arg <- grep("^--file=", args, value = TRUE)

if (length(file_arg) == 0) {
  stop("Cannot determine script path. Run with: Rscript scripts/R/generate-demo-data.R")
}

script_path <- sub("^--file=", "", file_arg)
script_dir  <- dirname(normalizePath(script_path))
project_dir <- normalizePath(file.path(script_dir, "..", ".."))

sim_path <- file.path(project_dir, "scripts", "R", "cdi-gwas-simulate-data.R")

if (!file.exists(sim_path)) {
  stop("Could not find simulator at: ", sim_path, "\nRun this script from the project repository.")
}

data_dir <- file.path(project_dir, "data")
dir.create(data_dir, showWarnings = FALSE, recursive = TRUE)

source(sim_path)

sim <- simulate_gwas_data(
  n = 200,
  m = 2000,
  maf_min = 0.05,
  n_causal = 8,
  seed = 123
)

# -----------------------------
# Basic validation
# -----------------------------
required <- c("genotypes", "variants", "covariates", "phenotype", "causal_snps")
missing <- required[!required %in% names(sim)]
if (length(missing) > 0) stop("Simulator output is missing: ", paste(missing, collapse = ", "))

G <- sim$genotypes

if (nrow(G) != nrow(sim$covariates)) stop("Mismatch: nrow(genotypes) != nrow(covariates).")
if (nrow(G) != nrow(sim$phenotype)) stop("Mismatch: nrow(genotypes) != nrow(phenotype).")

if (!all(rownames(G) == sim$covariates$sample_id)) stop("Mismatch: genotype rownames != covariates sample_id.")
if (!all(rownames(G) == sim$phenotype$sample_id)) stop("Mismatch: genotype rownames != phenotype sample_id.")
if (!all(colnames(G) %in% sim$variants$snp_id)) stop("Mismatch: some genotype SNP IDs not present in variants table.")

# -----------------------------
# Write genotype matrix (wide)
# -----------------------------
geno_df <- data.frame(
  sample_id = rownames(G),
  G,
  check.names = FALSE,
  stringsAsFactors = FALSE
)

utils::write.csv(
  geno_df,
  file = file.path(data_dir, "demo-genotypes.csv"),
  row.names = FALSE
)

# -----------------------------
# Write variants (map)
# -----------------------------
utils::write.csv(
  sim$variants,
  file = file.path(data_dir, "demo-variants.csv"),
  row.names = FALSE
)

# -----------------------------
# Write covariates
# -----------------------------
utils::write.csv(
  sim$covariates,
  file = file.path(data_dir, "demo-covariates.csv"),
  row.names = FALSE
)

# -----------------------------
# Write phenotype
# -----------------------------
utils::write.csv(
  sim$phenotype,
  file = file.path(data_dir, "demo-phenotype.csv"),
  row.names = FALSE
)

# -----------------------------
# Truth (for teaching evaluation)
# -----------------------------
truth_df <- data.frame(
  snp_id = sim$variants$snp_id,
  is_true_causal = sim$variants$snp_id %in% sim$causal_snps,
  stringsAsFactors = FALSE
)

utils::write.csv(
  truth_df,
  file = file.path(data_dir, "demo-truth.csv"),
  row.names = FALSE
)

# -----------------------------
# Data dictionary
# -----------------------------
dict_path <- file.path(data_dir, "demo-data-dictionary.md")
cat(
  "# Demo GWAS dataset\n\n",
  "Files:\n",
  "- `demo-genotypes.csv`: genotype matrix (rows = samples, columns = SNPs; values 0/1/2)\n",
  "- `demo-variants.csv`: variant map (`snp_id`, `chr`, `pos`, `maf`)\n",
  "- `demo-covariates.csv`: sample covariates (`sample_id`, `age`, `sex`, `PC1`, `PC2`)\n",
  "- `demo-phenotype.csv`: quantitative trait (`sample_id`, `trait`)\n",
  "- `demo-truth.csv`: teaching label indicating which SNPs were simulated as causal\n\n",
  "Notes:\n",
  "- Synthetic dataset intended for learning and demonstration.\n",
  "- Includes population structure via PCs so stratification can be discussed clearly.\n",
  file = dict_path
)

cat("GWAS demo dataset generated successfully.\n")
cat("Files written to: ", data_dir, "\n", sep = "")