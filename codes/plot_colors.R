# Global plot palettes (macaron / pastel). Source after ggplot2 / Seurat.
# Main and sub share one hue family; subtypes are tints of the parent.

group_col <- c(
  CTRL = "#7EB8E8",
  ACI = "#F07A7A"
)

annot_main_col <- c(
  HSPC = "#9DCE8A",
  B = "#8BB7EA",
  Plasma = "#C9A0E0",
  T = "#F4A8B8",
  NK = "#7ED4C4",
  `Mono/DC` = "#F0D46A",
  pDC = "#F2B88C",
  `Pre-Neut` = "#F5B87A",
  Neut = "#F08A7A",
  Ery = "#E8A0C0"
)

# Same family as the parent in annot_main_col.
annot_sub_col <- c(
  # HSPC (matcha)
  HSC = "#7EC07A",
  MEP = "#B5E0A0",
  GMP = "#C8ECA8",
  MDP = "#8BC47A",
  # B (blueberry)
  `Pro-B` = "#6A9FE0",
  `Large Pre-B` = "#7AABEA",
  `Small Pre-B` = "#9CC4F0",
  `Trans B` = "#B0D2F5",
  `Naive B` = "#C5E0FA",
  `Memory B` = "#5B94DC",
  # Plasma / pDC (same hex as main; single subtype)
  Plasma = unname(annot_main_col["Plasma"]),
  pDC = unname(annot_main_col["pDC"]),
  # T (strawberry)
  `CD4 Tnaive` = "#F8C4D0",
  `CD4 Tcm` = "#F0A0B4",
  `CD4 Treg` = "#E888A0",
  `CD8 Tnaive` = "#F8D0C8",
  `CD8 Tem` = "#F0A898",
  `CD8 CTL` = "#E89080",
  `CD8 NKT` = "#E8A8A0",
  MAIT = "#F4B8A8",
  gdT = "#E8B0B8",
  # NK (mint)
  `CD56bright NK` = "#A8E8DC",
  `CD56dim NK` = "#5EC4B4",
  # Mono/DC (lemon)
  `CD14 Mono` = "#E8C84A",
  `CD16 Mono` = "#F5E08A",
  cDC2 = "#D4B84A",
  # Pre-Neut (mango)
  Promyelocyte = "#F8CC9A",
  `MMP8 Pre-Neut` = "#F0A862",
  `MMP9 Pre-Neut` = "#E89850",
  # Neut (grapefruit)
  `S100A12 Neut` = "#F4A090",
  `SLC8A1 Neut` = "#E87868",
  `ISG15 Neut` = "#F49A88",
  # Ery (raspberry cream)
  `Early Ery` = "#F4C0D8",
  `Late Ery` = "#DC88B0"
)

# milo: negative logFC = CTRL-enriched, positive = ACI-enriched
milo_div_col <- c(
  low = unname(group_col["CTRL"]),
  mid = "#FFF6F0",
  high = unname(group_col["ACI"])
)

umap_trunc_axis <- function(upper = unit(5, "cm")) {
  ggh4x::guide_axis_truncated(
    trunc_lower = unit(0, "npc"),
    trunc_upper = upper
  )
}

theme_umap_short <- function(title_size = 20) {
  ggplot2::theme(
    aspect.ratio = 1,
    plot.title = ggplot2::element_blank(),
    axis.line = ggplot2::element_line(
      arrow = ggplot2::arrow(type = "closed", length = ggplot2::unit(0.40, "cm")),
      linewidth = 1
    ),
    axis.title = ggplot2::element_text(size = title_size, hjust = 0.06)
  )
}

plot_umap_short <- function(
    obj,
    group.by,
    cols,
    reduction = "umap",
    label = TRUE,
    label.size = 4,
    pt.size = 0.1,
    alpha = 0.1,
    raster = FALSE,
    raster.dpi = c(3000, 3000),
    title = NULL,
    legend = FALSE
) {
  axis <- umap_trunc_axis()
  dim_args <- list(
    object = obj,
    reduction = reduction,
    group.by = group.by,
    pt.size = pt.size,
    alpha = alpha,
    raster = raster,
    raster.dpi = raster.dpi,
    label = label,
    label.size = label.size
  )
  if (!is.null(cols)) dim_args$cols <- cols
  p <- do.call(Seurat::DimPlot, dim_args) +
    theme_umap_short() +
    ggplot2::xlab("UMAP-1") +
    ggplot2::ylab("UMAP-2") +
    ggplot2::scale_x_continuous(breaks = NULL) +
    ggplot2::scale_y_continuous(breaks = NULL) +
    ggplot2::guides(x = axis, y = axis)
  if (isFALSE(legend)) {
    p <- p + ggplot2::guides(color = "none")
  }
  if (!is.null(title)) {
    p <- p +
      ggplot2::ggtitle(title) +
      ggplot2::theme(plot.title = ggplot2::element_text(size = 24))
  }
  p
}
