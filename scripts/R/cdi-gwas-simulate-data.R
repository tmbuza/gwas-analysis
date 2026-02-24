simulate_gwas_data <- function(
  n = 200,
  m = 2000,
  maf_min = 0.05,
  n_causal = 8,
  effect_mean = 0.25,
  effect_sd = 0.12,
  seed = 123,

  # Missingness controls
  sample_missing_mean = 0.02,   # average per-sample missingness
  sample_missing_sd = 0.03,     # variability across samples
  snp_missing_mean = 0.01,      # average per-SNP missingness
  snp_missing_sd = 0.02,        # variability across SNPs
  pc1_missing_slope = 0.00      # 0 = no structure-driven missingness
){
  set.seed(seed)

  # -----------------------------
  # Sample metadata
  # -----------------------------
  sample_id <- paste0("sample-", sprintf("%03d", seq_len(n)))

  covar <- data.frame(
    sample_id = sample_id,
    age = round(stats::rnorm(n, mean = 45, sd = 12)),
    sex = sample(c("F", "M"), size = n, replace = TRUE),
    stringsAsFactors = FALSE
  )

  # -----------------------------
  # Population structure (PCs)
  # -----------------------------
  PC1 <- stats::rnorm(n)
  PC2 <- 0.6 * PC1 + stats::rnorm(n, sd = 0.8)

  covar$PC1 <- PC1
  covar$PC2 <- PC2

  # -----------------------------
  # Variant map
  # -----------------------------
  maf <- stats::runif(m, min = maf_min, max = 0.5)
  chr <- sample(1:22, size = m, replace = TRUE)
  pos_raw <- sample(1:1e6, size = m, replace = TRUE)
  pos <- ave(pos_raw, chr, FUN = function(x) sort(x))
  snp_id <- paste0("rs", seq_len(m))

  variants <- data.frame(
    snp_id = snp_id,
    chr = chr,
    pos = pos,
    maf = maf,
    stringsAsFactors = FALSE
  )

  # -----------------------------
  # Genotypes under HWE: 0/1/2
  # -----------------------------
  G <- matrix(0, nrow = n, ncol = m)
  for (j in seq_len(m)){
    p <- maf[j]
    probs <- c((1 - p)^2, 2 * p * (1 - p), p^2)
    G[, j] <- sample(0:2, size = n, replace = TRUE, prob = probs)
  }
  colnames(G) <- snp_id
  rownames(G) <- sample_id

  # -----------------------------
  # Inject missingness (NA)
  # -----------------------------
  # Per-sample missing rates
  s_miss <- stats::rnorm(n, mean = sample_missing_mean, sd = sample_missing_sd)
  s_miss <- pmin(pmax(s_miss, 0), 0.60)

  # Optional: make missingness slightly correlated with PC1
  if (!is.null(pc1_missing_slope) && pc1_missing_slope != 0){
    pc_scaled <- as.numeric(scale(PC1))
    s_miss <- s_miss + pc1_missing_slope * pc_scaled
    s_miss <- pmin(pmax(s_miss, 0), 0.60)
  }

  # Per-SNP missing rates
  v_miss <- stats::rnorm(m, mean = snp_missing_mean, sd = snp_missing_sd)
  v_miss <- pmin(pmax(v_miss, 0), 0.60)

  # Combined missing probability matrix (outer sum, clipped)
  miss_prob <- outer(s_miss, v_miss, "+")
  miss_prob <- pmin(miss_prob, 0.80)

  U <- matrix(stats::runif(n * m), nrow = n, ncol = m)
  G[U < miss_prob] <- NA_integer_

  # -----------------------------
  # True causal effects + phenotype
  # -----------------------------
  causal_idx <- sample(seq_len(m), size = n_causal, replace = FALSE)
  beta <- stats::rnorm(n_causal, mean = effect_mean, sd = effect_sd)

  # Use NA-safe dosage (mean-impute for generating trait only)
  G_imp <- G
  for (j in seq_len(m)){
    if (anyNA(G_imp[, j])){
      mu <- mean(G_imp[, j], na.rm = TRUE)
      if (is.nan(mu)) mu <- 0
      G_imp[is.na(G_imp[, j]), j] <- mu
    }
  }

  lp <- 0.02 * covar$age + 0.10 * (covar$sex == "M") + 0.35 * covar$PC1
  lp <- lp + as.numeric(G_imp[, causal_idx, drop = FALSE] %*% beta)

  y <- lp + stats::rnorm(n, sd = 1.0)

  pheno <- data.frame(
    sample_id = sample_id,
    trait = y,
    stringsAsFactors = FALSE
  )

  list(
    genotypes = G,
    variants = variants,
    covariates = covar,
    phenotype = pheno,
    causal_snps = snp_id[causal_idx],
    missingness = list(
      per_sample = data.frame(sample_id = sample_id, missing_rate = s_miss, stringsAsFactors = FALSE),
      per_snp = data.frame(snp_id = snp_id, missing_rate = v_miss, stringsAsFactors = FALSE)
    )
  )
}