# stroke_bm

Skull bone-marrow scRNA-seq (CTRL vs ACI).

**Reports (GitHub Pages):** https://jha14.github.io/stroke_bm/

## GitHub rendering

- **Pages HTML**: open the link above. Colleagues can read the Quarto/notebook reports in a browser.
- **`.ipynb`**: GitHub also previews notebooks in the file viewer.
- **`.qmd`**: GitHub shows source only; it does not run chunks.

Source stays in `codes/`. Rendered HTML is copied to `docs/` for Pages. `data/` and `results/` are not in the repo.

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
