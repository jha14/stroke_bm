# stroke_bm

颅骨骨髓单细胞转录组。先有急性脑梗死（ACI）5 例，再按性别、年龄匹配选对照（CTRL）6 例。样本表和读图说明见报告首页。

**报告：** https://jha14.github.io/stroke_bm/

分析顺序：00–06 质控与命名，07 组成，08 粒系发育，09–11 通路 / 转录因子 / 细胞因子，12 拟时间与活性对齐，13 HSC 命运。组间看每个样本一个点。

**重要限制：** 两组不是同一实验室、同一批次同时取的样本。CTRL 全是 5′ 文库，ACI 全是 3′ 文库，分组和平台完全叠在一起。后续方向（细胞通讯、补测、功能实验）见报告首页。

## GitHub rendering

- **Pages HTML**: open the link above.
- **`.ipynb`**: GitHub previews notebooks in the file viewer.
- **`.qmd`**: source only; GitHub does not run chunks.

Source is in `codes/`. Rendered HTML is copied to `docs/` for Pages. `data/` and `results/` are not in the repo.

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
| `codes/12_traj_activity.qmd` | Slingshot PT × PROGENy / TF / CytoSig |
| `codes/13_hspc_trajectory.qmd` | HSC → MEP / GMP / MDP trajectory |
| `codes/plot_colors.R` | Shared palettes |
| `codes/activity_helpers.R` | Activity stats / heatmap helpers |

`05_*` numbering follows `annot_main_col` in `plot_colors.R`.

## Run

Root directory of this project. Render Quarto with `quarto render codes/<file>.qmd`. Notebooks use the `pertpy` kernel where noted.
