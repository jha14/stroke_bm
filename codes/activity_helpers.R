# Shared helpers for 09 / 10 / 11 activity analyses. Source after tidyverse.

min_cells_sample <- 5

wilcox_ctrl_aci <- function(score, group) {
  group <- factor(as.character(group), levels = c("CTRL", "ACI"))
  ctrl <- score[group == "CTRL"]
  aci <- score[group == "ACI"]
  tibble(
    n_ctrl = length(ctrl),
    n_aci = length(aci),
    median_ctrl = median(ctrl, na.rm = TRUE),
    median_aci = median(aci, na.rm = TRUE),
    delta_aci_minus_ctrl = median(aci, na.rm = TRUE) - median(ctrl, na.rm = TRUE),
    p = if (sum(!is.na(ctrl)) >= 2 && sum(!is.na(aci)) >= 2) {
      wilcox.test(aci, ctrl, exact = FALSE)$p.value
    } else {
      NA_real_
    }
  )
}

star_p <- function(p) {
  dplyr::case_when(
    is.na(p) ~ "",
    p < 0.001 ~ "***",
    p < 0.01 ~ "**",
    p < 0.05 ~ "*",
    TRUE ~ "ns"
  )
}

acts_long_to_wide <- function(acts) {
  acts |>
    dplyr::select(condition, source, score) |>
    tidyr::pivot_wider(names_from = source, values_from = score) |>
    dplyr::rename(barcode = condition)
}

bind_meta_acts <- function(meta, wide) {
  dplyr::inner_join(meta, wide, by = "barcode")
}

features_from_wide <- function(wide) {
  setdiff(colnames(wide), "barcode")
}

cell_group_tests <- function(dat, features, strata_col = NULL) {
  dat$group <- factor(as.character(dat$group), levels = c("CTRL", "ACI"))
  if (is.null(strata_col)) {
    purrr::map_dfr(features, function(ft) {
      wilcox_ctrl_aci(dat[[ft]], dat$group) |>
        dplyr::mutate(feature = ft, .before = 1)
    })
  } else {
    strata <- unique(as.character(dat[[strata_col]]))
    purrr::map_dfr(strata, function(st) {
      sub <- dat[as.character(dat[[strata_col]]) == st, , drop = FALSE]
      purrr::map_dfr(features, function(ft) {
        wilcox_ctrl_aci(sub[[ft]], sub$group) |>
          dplyr::mutate(stratum = st, feature = ft, .before = 1)
      })
    })
  }
}

sample_medians <- function(dat, features, extra_group = NULL) {
  keys <- c("sample", "group", extra_group)
  dat |>
    dplyr::group_by(dplyr::across(dplyr::all_of(keys))) |>
    dplyr::summarise(
      n_cell = dplyr::n(),
      dplyr::across(dplyr::all_of(features), ~ median(.x, na.rm = TRUE)),
      .groups = "drop"
    ) |>
    dplyr::filter(.data$n_cell >= min_cells_sample)
}

sample_group_tests <- function(med, features, strata_col = NULL) {
  cell_group_tests(med, features, strata_col = strata_col) |>
    dplyr::rename(n_sample_ctrl = n_ctrl, n_sample_aci = n_aci)
}

add_fdr <- function(tab, p_col = "p") {
  tab |>
    dplyr::mutate(
      padj = p.adjust(.data[[p_col]], method = "BH"),
      star = star_p(.data$padj)
    )
}

# Patient / sample-level: raw Wilcoxon p, no BH.
add_stars <- function(tab, p_col = "p") {
  tab |>
    dplyr::mutate(star = star_p(.data[[p_col]]))
}

# Wider legend → paler tiles. 98th pct of |x| instead of 90th.
sym_fill_limits <- function(x, p_inner = 0.98) {
  x <- as.numeric(x)
  x <- x[is.finite(x)]
  if (length(x) == 0) return(c(-1, 1))
  L <- as.numeric(stats::quantile(abs(x), probs = p_inner, na.rm = TRUE))
  if (!is.finite(L) || L <= 0) L <- max(abs(x), na.rm = TRUE)
  if (!is.finite(L) || L <= 0) L <- 1
  c(-L, L)
}

print_fill_summary <- function(x, label) {
  x <- as.numeric(x)
  x <- x[is.finite(x)]
  cat(label, "\n")
  print(summary(x))
  q <- stats::quantile(abs(x), probs = c(0.8, 0.9, 0.95), na.rm = TRUE)
  cat("|x| q80 / q90 / q95:", paste(signif(q, 3), collapse = " / "), "\n")
}

# decoupleR sc vignette: rev(RColorBrewer RdBu), white mid.
rd_bu_fill <- function() {
  rev(RColorBrewer::brewer.pal(n = 11, name = "RdBu"))
}

scale_fill_activity <- function(values, midpoint = 0) {
  lim <- sym_fill_limits(values)
  print_fill_summary(values, "heatmap fill")
  pal <- rd_bu_fill()
  ggplot2::scale_fill_gradientn(
    colours = pal,
    limits = lim,
    oob = scales::squish,
    na.value = "white"
  )
}

kruskal_by_type <- function(dat, features, type_col) {
  purrr::map_dfr(features, function(ft) {
    x <- dat[[ft]]
    g <- dat[[type_col]]
    ok <- !is.na(x) & !is.na(g)
    tibble(
      feature = ft,
      n = sum(ok),
      p = if (length(unique(g[ok])) >= 2) {
        kruskal.test(x[ok], g[ok])$p.value
      } else {
        NA_real_
      }
    )
  }) |>
    add_fdr()
}

stage_assoc <- function(dat, features, stage_col) {
  dat[[stage_col]] <- droplevels(factor(dat[[stage_col]]))
  rank_map <- setNames(seq_along(levels(dat[[stage_col]])), levels(dat[[stage_col]]))
  dat$stage_rank <- unname(rank_map[as.character(dat[[stage_col]])])
  purrr::map_dfr(features, function(ft) {
    x <- dat[[ft]]
    r <- dat$stage_rank
    g <- dat[[stage_col]]
    ok <- !is.na(x) & !is.na(r)
    sp <- if (sum(ok) >= 5) {
      suppressWarnings(cor.test(x[ok], r[ok], method = "spearman", exact = FALSE))
    } else {
      list(estimate = NA_real_, p.value = NA_real_)
    }
    tibble(
      feature = ft,
      n = sum(ok),
      rho = unname(sp$estimate),
      p_spearman = sp$p.value,
      p_kruskal = if (length(unique(g[ok])) >= 2) {
        kruskal.test(x[ok], g[ok])$p.value
      } else {
        NA_real_
      }
    )
  }) |>
    dplyr::mutate(
      padj_spearman = p.adjust(.data$p_spearman, method = "BH"),
      padj_kruskal = p.adjust(.data$p_kruskal, method = "BH")
    ) |>
    dplyr::arrange(dplyr::desc(abs(.data$rho)), .data$padj_kruskal)
}

mean_by <- function(dat, features, cols) {
  dat |>
    dplyr::group_by(dplyr::across(dplyr::all_of(cols))) |>
    dplyr::summarise(
      dplyr::across(dplyr::all_of(features), ~ mean(.x, na.rm = TRUE)),
      .groups = "drop"
    )
}

# decoupleR sc vignette: ScaleData on activity assay, then mean per group.
scale_features <- function(dat, features) {
  dat |>
    dplyr::mutate(dplyr::across(dplyr::all_of(features), function(x) {
      s <- stats::sd(x, na.rm = TRUE)
      if (!is.finite(s) || s == 0) {
        return(rep(0, length(x)))
      }
      as.numeric(scale(x))
    }))
}

mean_by_scaled <- function(dat, features, cols) {
  mean_by(scale_features(dat, features), features, cols)
}

plot_heatmap_mean <- function(mean_df, features, row_col, col_col = NULL) {
  long <- mean_df |>
    tidyr::pivot_longer(dplyr::all_of(features), names_to = "feature", values_to = "mean")
  long$feature <- factor(long$feature, levels = features)
  if (!is.null(col_col)) {
    p <- ggplot(long, aes(x = .data[[col_col]], y = .data$feature, fill = .data$mean))
  } else {
    p <- ggplot(long, aes(x = .data[[row_col]], y = .data$feature, fill = .data$mean))
  }
  p +
    geom_tile(color = "white", linewidth = 0.4) +
    scale_fill_activity(long$mean) +
    theme_classic() +
    theme(
      axis.text.x = element_text(angle = 45, hjust = 1, size = 11),
      axis.text.y = element_text(size = 11),
      axis.title = element_blank()
    )
}

plot_group_box <- function(dat, feature, title = NULL) {
  dat$group <- factor(as.character(dat$group), levels = c("CTRL", "ACI"))
  p <- ggplot(dat, aes(x = .data$group, y = .data[[feature]], fill = .data$group)) +
    geom_boxplot(outlier.size = 0.4, width = 0.65) +
    scale_fill_manual(values = group_col) +
    theme_classic() +
    theme(legend.position = "none") +
    xlab(NULL) +
    ylab(feature)
  if (!is.null(title)) p <- p + ggtitle(title)
  p
}

cache_ok <- function(path, barcodes) {
  if (!file.exists(path)) return(FALSE)
  obj <- qs2::qs_read(path, nthreads = 10)
  if (!is.data.frame(obj) || !"barcode" %in% colnames(obj)) return(FALSE)
  identical(sort(obj$barcode), sort(as.character(barcodes)))
}

# ggdotchart lollipop (arhgap35 analysis.R cytosig_fc / progeny_degs).
plot_lollipop_delta <- function(tab, title, p_col = "p", ylab = "ACI − CTRL") {
  df <- tab |>
    dplyr::arrange(dplyr::desc(.data$delta_aci_minus_ctrl)) |>
    dplyr::mutate(
      source = .data$feature,
      score = .data$delta_aci_minus_ctrl,
      x = dplyr::row_number(),
      color = dplyr::case_when(
        is.na(.data[[p_col]]) | .data[[p_col]] >= 0.05 ~ "N.S.",
        .data$delta_aci_minus_ctrl > 0 ~ "Significant up",
        TRUE ~ "Significant down"
      )
    )
  max_abs <- max(abs(df$score), na.rm = TRUE)
  if (!is.finite(max_abs) || max_abs == 0) max_abs <- 1
  df <- df |>
    dplyr::mutate(
      y = ifelse(.data$score > 0, -max_abs / 30, max_abs / 30),
      hjust = ifelse(.data$score > 0, 1, 0)
    )
  df$source <- factor(df$source, levels = df$source)
  ggpubr::ggdotchart(
    df,
    x = "source",
    y = "score",
    sorting = "none",
    dot.size = 5,
    color = "color",
    add = "segments",
    title = title,
    shape = 19
  ) +
    ggplot2::geom_text(
      ggplot2::aes(label = .data$source, x = .data$x, y = .data$y, hjust = .data$hjust),
      vjust = 0.5, size = 4, angle = 90
    ) +
    ggplot2::geom_hline(yintercept = 0) +
    ggplot2::scale_color_manual(
      values = c(
        "Significant up" = "#B2182B",
        "N.S." = "grey",
        "Significant down" = "#2166AC"
      )
    ) +
    ggplot2::ylab(ylab) +
    ggplot2::theme(
      axis.text.x = ggplot2::element_blank(),
      axis.ticks.x = ggplot2::element_blank(),
      axis.title.y = ggplot2::element_text(size = 15),
      axis.text.y = ggplot2::element_text(size = 13),
      axis.line.x = ggplot2::element_blank(),
      axis.title.x = ggplot2::element_blank(),
      legend.position = "bottom",
      legend.title = ggplot2::element_blank(),
      plot.title = ggplot2::element_text(face = "bold", size = 15, vjust = 0)
    )
}

plot_score_hist <- function(long, subtype_col, bins = 40, title = NULL, rug = NULL) {
  long$group <- factor(as.character(long$group), levels = c("CTRL", "ACI"))
  long[[subtype_col]] <- droplevels(factor(long[[subtype_col]]))
  if (is.null(rug)) rug <- nrow(long) <= 2000
  p <- ggplot(long, aes(x = .data$score, fill = .data$group)) +
    geom_histogram(
      aes(y = after_stat(density)),
      bins = bins,
      position = "identity",
      alpha = 0.5,
      color = NA
    )
  if (isTRUE(rug)) {
    p <- p +
      geom_rug(
        aes(color = .data$group),
        alpha = 0.6, sides = "b", show.legend = FALSE
      ) +
      scale_color_manual(values = group_col)
  }
  p <- p +
    facet_grid(
      stats::as.formula(paste(subtype_col, "~ pathway")),
      scales = "free_x"
    ) +
    scale_fill_manual(values = group_col) +
    theme_classic() +
    theme(
      strip.text = element_text(size = 8),
      axis.text = element_text(size = 7),
      legend.position = "top"
    ) +
    xlab("PROGENy mlm") +
    ylab("Density")
  if (!is.null(title)) p <- p + ggtitle(title)
  p
}
