# GWAS Analysis --- Free Track

This repository contains the **free GWAS guide** from Complex Data
Insights (CDI).

The focus is not only how to run a genome-wide association study,\
but how to reason through the results.

------------------------------------------------------------------------

## What This Guide Covers

The free track walks through the structured reasoning chain behind GWAS:

Study Design → Phenotype Definition → Genotype QC → Population Structure
→ Association Testing → Calibrated Claims

The goal is interpretation discipline, not just computation.

------------------------------------------------------------------------

## Structure

    index.qmd                         # Cover (front page only)
    01-preface-and-setup.qmd          # Gateway and reasoning chain
    02-study-design-and-phenotypes.qmd
    03-genotype-qc-and-population-structure.qmd
    04-association-testing-concepts.qmd
    05-visualizing-and-validating-signals.qmd
    06-from-association-to-biological-claims.qmd

------------------------------------------------------------------------

## Reproducibility

This guide uses fully simulated GWAS data in R for clarity and teaching
purposes.

To generate the demo dataset:

``` bash
Rscript scripts/R/generate-demo-data.R
```

This creates:

-   demo-genotypes.csv\
-   demo-variants.csv\
-   demo-covariates.csv\
-   demo-phenotype.csv\
-   demo-truth.csv\
-   Missingness summaries

All files are written to the `/data` directory.

------------------------------------------------------------------------

## Rendering the Guide

From the project root:

``` bash
quarto render
```

Output will be generated in the `/docs` directory.

------------------------------------------------------------------------

## Scope of the Free Track

The free guide covers:

-   Conceptual foundations\
-   QC logic\
-   Population structure reasoning\
-   Basic association modeling\
-   Signal interpretation discipline

Advanced topics such as fine-mapping, polygenic risk scores, replication
studies, and multi-omics integration are reserved for the premium guide.

------------------------------------------------------------------------

## License

This repository contains educational material and simulated datasets for
instructional use.
