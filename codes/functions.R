
# set.seed(123)
# b_cell_col <- scales::hue_pal()(7) %>% sample
# names(b_cell_col) <- c("Small Pre-B", "Transitional B", "Naive B", "UnSwMB", "SwMB", "ABC", "Plasma cell")
# 
# set.seed(111)
# myeloid_cell_col <- scales::hue_pal()(6) %>% sample
# names(myeloid_cell_col) <- c("CD14 monocyte", "CD16 monocyte", "Macrophage", "cDC1", "cDC2", "pDC")
# 
# set.seed(123)
# neut_cell_col <- scales::hue_pal()(5) %>% sample
# names(neut_cell_col) <- c("MMP9 Neut", "S100A12 Neut", "SLC8A1 Neut", "TXNIP Neut", "ISG15 Neut")
# 
# set.seed(123)
# hspc_cell_col <- scales::hue_pal()(7)
# names(hspc_cell_col) <- c("HSC", "Pro-B", "Large Pre-B", "CMP", "GMP", "MDP", "NP")
# 
# 
# set.seed(123)
# nk_cell_col <- scales::hue_pal()(3) %>% sample
# names(nk_cell_col) <- c("CD56bright NK", "CD56dim NK", "Adaptive NK")
# 
# 
# set.seed(123)
# t_cell_sub_col <- scales::hue_pal()(17) %>% sample
# names(t_cell_sub_col) <- c("CD4 Tnaive", "CD4 Tcm", "CD4 Tem/Th1", "CD4 Tem/Th2-like", "CD4 Tem/Th17", "CD4 CTL", "CD4 Treg", "CD4 IFN-T",
#                            "CD8 Tnaive", "CD8 Tcm", "CD8 Tem", "CD8 CTL", "CD8 Tem/NK-like", "CD8 CTL/NK-like", "CD8 IFN-T", "MAIT", "gdT")
# 
# # CD4 Tnaive          CD4 Tcm      CD4 Tem/Th1 CD4 Tem/Th2-like     CD4 Tem/Th17          CD4 CTL         CD4 Treg        CD4 IFN-T       CD8 Tnaive          CD8 Tcm          CD8 Tem 
# # "#F166E8"        "#D09400"        "#D277FF"        "#FF61C7"        "#00BCD6"        "#E7851E"        "#45B500"        "#89AC00"        "#B2A100"        "#00B3F2"        "#00C087" 
# # CD8 CTL  CD8 Tem/NK-like  CD8 CTL/NK-like        CD8 IFN-T             MAIT              gdT 
# # "#F8766D"        "#28A3FF"        "#FF689E"        "#00BC51"        "#00C0B2"        "#9C8DFF" 
# 
# t_cell_main_col <- t_cell_sub_col[c(4, 11, 16, 17)]
# names(t_cell_main_col) <- c("CD4 T cell", "CD8 T cell", "MAIT", "gdT")
# 
# cd4t_cell_col <- t_cell_sub_col[1:8]
# cd8t_cell_col <- t_cell_sub_col[9:15]
# 
# # CD4 Tnaive          CD4 Tcm      CD4 Tem/Th1 CD4 Tem/Th2-like     CD4 Tem/Th17          CD4 CTL         CD4 Treg        CD4 IFN-T       CD8 Tnaive          CD8 Tcm 
# # "#F166E8"        "#D09400"        "#D277FF"        "#FF61C7"        "#00BCD6"        "#E7851E"        "#45B500"        "#89AC00"        "#B2A100"        "#00B3F2" 
# # CD8 Tem          CD8 CTL  CD8 Tem/NK-like  CD8 CTL/NK-like        CD8 IFN-T             MAIT              gdT 
# # "#00C087"        "#F8766D"        "#28A3FF"        "#FF689E"        "#00BC51"        "#00C0B2"        "#9C8DFF"
# 
# 
# set.seed(123)
# sc_cell_col <- scales::hue_pal()(10) %>% sample
# names(sc_cell_col) <- c("HSPC", "B", "Plasma", "Neut", "NP", "Mono/Mac/DC", "pDC", "T/NK", "Ery")
# 
# 
# sc_tissue_col <- c("BM" = "#4DBBD57F", "Blood" = "#E64B357F")
# 
# disease_col <- ggsci::pal_npg("nrc", alpha = 1)(9)[c(2, 1, 3, 8)]
# names(disease_col) <- c("CTRL", "ACT", "REM", "REL")
# 
# 
# sc_tissue_col3 <- c("BM" = "#4DBBD57F", "Blood" = "#E64B357F", "CSF" = "#3C54887F")
# 
# disease_col <- ggsci::pal_npg("nrc", alpha = 1)(9)[c(2, 1, 3, 6)]
# names(disease_col) <- c("CTRL", "NMOSD", "MS", "MG")


# remove_doublet <- 
#   function(seurat_obj) {
#     
#     require(Seurat)
#     require(scDblFinder)
#     require(Matrix)
#     
#     counts_mat <- as(seurat_obj[["RNA"]]$counts, "dgCMatrix")
#     
#     sce <- as.SingleCellExperiment(seurat_obj)
#     counts(sce) <- counts_mat # 确保用的是内存矩阵
#     
#     sce <- scDblFinder(sce, clusters = T)
#     
#     res <- data.frame(
#       scDblFinder.class = sce$scDblFinder.class,
#       scDblFinder.score = sce$scDblFinder.score,
#       row.names = colnames(sce))
#     
#     return(res)}



# milor <- function(tissue, group){
#   
#   suppressMessages(require(miloR))
#   suppressMessages(require(SingleCellExperiment))
#   suppressMessages(require(BiocParallel))
#   
#   seurat_obj <- readRDS("data/rdata/dimensionality_reduction/seurat_obj_final.rds") %>% 
#     subset(tissue %in% tissue) %>% subset(group %in% group)
#   seurat_obj[["RNA"]]$counts <- as(object = seurat_obj[["RNA"]]$counts, Class = "dgCMatrix")
#   seurat_obj[["RNA"]]$data <- NULL
#   seurat_obj[["RNA"]]$scale.data <- NULL
#   
#   traj_milo <- Milo(seurat_obj %>% as.SingleCellExperiment())
#   # rm(seurat_obj)
#   
#   # reducedDimNames(traj_milo)
#   traj_milo <- buildGraph(traj_milo, k = 10, d = 20, reduced.dim = "HARMONY")
#   traj_milo <- makeNhoods(traj_milo, prop = 0.1, k = 10, d = 20, refined = TRUE, reduced_dims = "HARMONY")
#   # plotNhoodSizeHist(traj_milo)
#   traj_milo <- countCells(traj_milo, meta.data = data.frame(colData(traj_milo)), samples = "sample")
#   # head(nhoodCounts(traj_milo))
#   
#   traj_design <- 
#     data.frame(colData(traj_milo))[, c("sample", "patient", "tissue", "chemistry", "group")] %>% 
#     distinct() %>% remove_rownames %>% column_to_rownames("sample")
#   # identical(rownames(traj_design), colnames(nhoodCounts(traj_milo)))
#   
#   traj_milo <- calcNhoodDistance(traj_milo, d = 20, reduced.dim = "HARMONY")
#   da_results <- testNhoods(traj_milo, design = ~ group, design.df = traj_design, reduced.dim = "HARMONY", BPPARAM = MulticoreParam(16))
#   # ggplot(da_results, aes(PValue)) + geom_histogram(bins = 50)
#   da_results <- annotateNhoods(traj_milo, da_results, coldata_col = "main_annotation")
#   # ggplot(da_results, aes(main_annotation_fraction)) + geom_histogram(bins = 50)
#   da_results$main_annotation <- ifelse(da_results$main_annotation_fraction < 0.7, "Mixed", da_results$main_annotation)
#   
#   # traj_milo <- buildNhoodGraph(traj_milo)
#   return(da_results)}


# ROIE <- function(crosstab){
#   rowsum.matrix <- matrix(0, nrow = nrow(crosstab), ncol = ncol(crosstab))
#   rowsum.matrix[,1] <- rowSums(crosstab)
#   colsum.matrix <- matrix(0, nrow = ncol(crosstab), ncol = ncol(crosstab))
#   colsum.matrix[1,] <- colSums(crosstab)
#   allsum <- sum(crosstab)
#   roie <- divMatrix(crosstab, rowsum.matrix %*% colsum.matrix / allsum)
#   row.names(roie) <- row.names(crosstab)
#   colnames(roie) <- colnames(crosstab)
#   return(roie)}
# 
# divMatrix <- function(m1, m2){
#   dim_m1 <- dim(m1)
#   dim_m2 <- dim(m2)
#   if( sum(dim_m1 == dim_m2) == 2 ){
#     div.result <- matrix(rep(0,dim_m1[1] * dim_m1[2]) , nrow = dim_m1[1] )
#     row.names(div.result) <- row.names(m1)
#     colnames(div.result) <- colnames(m1)
#     for(i in 1:dim_m1[1]){
#       for(j in 1:dim_m1[2]){
#         div.result[i,j] <- m1[i,j] / m2[i,j]}}   
#     return(div.result)}
#   else{
#     warning("The dimensions of m1 and m2 are different")}}
# 
# 
# plot_GO_dot <-
#   function(x,
#            title,
#            size_limit,
#            color_limit,
#            number = 1:10, color){
#     
#     # char_len <- sapply(x$Description, nchar)
#     # x <- x[char_len<40,]
#     x <- x[number,]
#     x <- x[complete.cases(x),]
#     gr <- do.call(rbind, strsplit(x$GeneRatio, '/'))
#     x$GeneRatio <- DOSE::parse_ratio(x$GeneRatio)
#     x$Description <- factor(x$Description, levels = x$Description[order(x$GeneRatio)])
#     x$log_p_value <- -log10(x$p.adjust)
#     
#     p <- ggplot(x, aes(x = GeneRatio, y = Description)) +
#       geom_point(aes(size = GeneRatio, fill = log_p_value), color = "grey40", shape = 21) + theme_bw() + #add colors
#       labs(size = "Gene Ratio", fill = expression(paste("-Log"[10], " adj. P-value"))) +
#       # scale_y_discrete(labels = scales::label_wrap(40)) +
#       scale_fill_gradient(low="white", high=color, limits = color_limit,
#                           guide = guide_colourbar(direction = "horizontal", barwidth = 5, barheight = 0.6)) +
#       scale_size(limits = size_limit) + ggtitle(title) +
#       theme(panel.border = element_rect(colour = "black", linewidth = 1),
#             legend.title = element_text(size = 10),
#             axis.title.x = element_blank(), axis.title.y = element_blank(),
#             aspect.ratio=1, axis.line.x = element_blank(), axis.line.y = element_blank(),
#             plot.title = element_text(size = 13, face="bold", hjust = 0.5),
#             axis.text.x = element_text(size = 11, colour = "black"),
#             axis.text.y = element_text(size = 12, colour = "black"))
#     return(p)
#   }
# 
# 
# 
# volcano_plot <- 
#   function(x, 
#            select_lab,
#            title, 
#            xlim,
#            logfc_threshold = 0,
#            legendPosition = "bottom"){
#     suppressMessages(require(EnhancedVolcano))
#     
#     keyvals <- ifelse(
#       x$avg_log2FC < -logfc_threshold & x$p_val_adj < 0.05, 'royalblue',
#       ifelse(x$avg_log2FC > logfc_threshold & x$p_val_adj < 0.05, 'red2',
#              'grey60'))
#     
#     names(keyvals)[keyvals == 'red2'] <- 'Up'
#     names(keyvals)[keyvals == 'grey60'] <- 'Non-sig'
#     names(keyvals)[keyvals == 'royalblue'] <- 'Down'
#     
#     volcano_plot <- EnhancedVolcano(x,
#                                     lab = x$gene,
#                                     selectLab = select_lab,
#                                     x = 'avg_log2FC', y = 'p_val_adj',
#                                     title = title,
#                                     xlim = xlim,
#                                     FCcutoff = logfc_threshold,
#                                     subtitle = NULL,
#                                     drawConnectors = TRUE,
#                                     # axisLabSize = 20,
#                                     # labSize = 5,
#                                     # caption = bquote(~Log[2]~ "Fold Change cutoff = 1; Adjusted p-value cutoff = 0.05"),
#                                     caption = NULL,
#                                     max.overlaps = 1000,
#                                     ylab = bquote(~-Log[10] ~ 'adjusted P-value'),
#                                     pCutoff = 0.05,
#                                     legendPosition = legendPosition,
#                                     colCustom = keyvals)
#     # theme(aspect.ratio = 0.7)
#     # ggsave(file, width = 6, height = 5.5)
#     return(volcano_plot)
#   }

