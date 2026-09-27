# stroke_bm

Skull bone-marrow scRNA-seq (CTRL vs ACI). Analysis scripts only.

## GitHub rendering

- **`.ipynb`**: GitHub shows executed notebooks in the file viewer.
- **`.qmd`**: GitHub shows source text only. It does **not** run R/Python chunks or produce the HTML report.
- **`.html`**: opening an HTML file on GitHub shows source, not the report. To view Quarto output in a browser, use [GitHub Pages](https://pages.github.com/) or open the HTML locally after `quarto render`.

This repo therefore keeps **source** (`codes/*.qmd`, `codes/*.ipynb`, `codes/*.R`). Rendered HTML, `data/`, and `results/` are not committed.

## Layout

| Path | Content |
|------|---------|
| `codes/00_qc.qmd` … `06_final.qmd` | QC → clustering → annotation → subtypes → merge |
| `codes/03_celltypist.ipynb` | CellTypist |
| `codes/07_composition.qmd` | Sample proportions, Wilcoxon, miloR |
| `codes/07_sccoda.ipynb` | scCODA / tascCODA (conda `pertpy`) |
| `codes/08_neut_trajectory.qmd` | GMP + neutrophil CytoTRACE2, DM, PHATE, slingshot |
| `codes/plot_colors.R` | Shared palettes |
| `codes/functions.R` | Shared helpers |

## Run

Root directory of this project. Render Quarto with `quarto render codes/<file>.qmd`. Notebooks use the `pertpy` kernel where noted.
