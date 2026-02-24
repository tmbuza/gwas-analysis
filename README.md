# GWAS Analysis --- Free Track

This repository contains the **GWAS Free Track** from Complex Data
Insights (CDI).

The purpose of this guide is not only to demonstrate how to run a
genome-wide association study (GWAS), but to teach how to reason through
results in a disciplined and defensible way.

------------------------------------------------------------------------

## Scope

The free track walks through the structured GWAS reasoning chain:

Study Design → Phenotype Definition → Genotype Quality Control →
Population Structure → Association Testing → Calibrated Biological
Claims

The emphasis is on interpretation discipline rather than software
complexity.

------------------------------------------------------------------------

## Repository Structure

    index.qmd                         # Cover (front page only)
    01-preface-and-setup.qmd          # Gateway and reasoning chain
    02-study-design-and-phenotypes.qmd
    03-genotype-qc-and-population-structure.qmd
    04-association-testing-concepts.qmd
    05-visualizing-and-validating-signals.qmd
    06-from-association-to-biological-claims.qmd

    assets/
      css/
      images/

    scripts/R/
      cdi-gwas-simulate-data.R
      generate-demo-data.R
      cdi-gwas-theme.R

------------------------------------------------------------------------

## Demo Data (Simulated in R)

This guide uses fully simulated GWAS data for clarity and
reproducibility.

To generate the dataset:

``` bash
Rscript scripts/R/generate-demo-data.R
```

This creates:

-   demo-genotypes.csv
-   demo-variants.csv
-   demo-covariates.csv
-   demo-phenotype.csv
-   demo-truth.csv
-   Missingness summaries

All files are written to the `/data` directory.

The dataset includes:

-   Hardy-Weinberg-consistent genotype simulation\
-   Population structure via principal components\
-   Controlled missingness\
-   Known causal variants (for teaching evaluation)

------------------------------------------------------------------------

## Rendering

From the project root:

``` bash
quarto render
```

Rendered output is written to `/docs`.

------------------------------------------------------------------------

## Deployment

This repository is rendered and deployed via GitHub Pages.

Rendered output from the `/docs` directory is published at:

https://gwas.complexdatainsights.com

Deployment workflow:

1.  Run `quarto render`
2.  Commit changes
3.  Push to `main`
4.  GitHub Pages serves the `/docs` directory

------------------------------------------------------------------------

## What Is Not Covered Here

Advanced topics such as:

-   Fine mapping\
-   Polygenic risk scores\
-   Replication strategy\
-   Power calculations\
-   Functional annotation\
-   Multi-omics integration

are addressed in the premium guide.

------------------------------------------------------------------------

## Purpose

This repository is part of the CDI applied bioinformatics series. It emphasizes structured learning, reproducible workflows, and disciplined interpretation across complex biological data.
