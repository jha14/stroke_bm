# stroke_bm

颅骨骨髓单细胞转录组（对照 CTRL 6 例 vs 急性脑梗死 ACI 5 例）。

**请合作者先打开报告首页（中文导读）：** https://jha14.github.io/stroke_bm/

科学问题：急性脑梗后颅骨骨髓中性粒细胞是否扩增；扩增之后通路、转录因子和细胞因子响应有没有变。00–06 是质控和注释，07 看组成，08–11 看中性粒状态。

**怎么读 p 值和热图：** 见首页。一句话：组间结论看**患者级**（每例一个点），不要看细胞级 Wilcoxon。

## GitHub rendering

- **Pages HTML**: open the link above. Colleagues can read the Quarto/notebook reports in a browser.
- **`.ipynb`**: GitHub also previews notebooks in the file viewer.
- **`.qmd`**: GitHub shows source only; it does not run chunks.

Source stays in `codes/`. Rendered HTML is copied to `docs/` for Pages. `data/` and `results/` are not in the repo.

## Layout

| Path | Content |
|------|---------|
| `codes/00_qc.qmd` | QC |
| `codes/01_clustering.qmd` | Clustering |
| `codes/02_marker_plot.qmd` | Marker plots |
| `codes/03_1_prediction.qmd` | h5ad export for CellTypist |
| `codes/03_2_celltypist.ipynb` | CellTypist |
| `codes/04_annotation.qmd` | Level-1 annotation |
| `codes/05_1_hspc.qmd` | HSPC |
| `codes/05_2_b_plasma.qmd` | B / Plasma |
| `codes/05_3_tnk.qmd` | T / NK |
| `codes/05_4_myeloid.qmd` | Mono/DC / pDC |
| `codes/05_5_neutrophil.qmd` | Pre-Neut / Neut |
| `codes/05_6_erythrocyte.qmd` | Ery |
| `codes/06_final.qmd` | Merge final object |
| `codes/07_1_composition.qmd` | Sample proportions, Wilcoxon, miloR |
| `codes/07_2_sccoda.ipynb` | scCODA / tascCODA (conda `pertpy`) |
| `codes/08_neut_trajectory.qmd` | GMP + neutrophil CytoTRACE2, DM, PHATE, slingshot |
| `codes/09_progeny.qmd` | PROGENy mlm (all cells + neutrophil lineage) |
| `codes/10_neut_decouple.qmd` | Neutrophil CollecTRI ulm |
| `codes/11_cytosig.qmd` | CytoSig (conda `cytosig`) |
| `codes/plot_colors.R` | Shared palettes |
| `codes/activity_helpers.R` | Activity stats / heatmap helpers |

`05_*` numbering follows `annot_main_col` in `plot_colors.R`.

## Run

Root directory of this project. Render Quarto with `quarto render codes/<file>.qmd`. Notebooks use the `pertpy` kernel where noted.
