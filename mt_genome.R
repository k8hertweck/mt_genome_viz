# create circular mt genome visualization

# install and load packages
devtools::install_github("stephenturner/annotables")
library(annotables) # gene and tRNA annotations (grch38)
library(dplyr)

# extract only mtDNA
mt <- grch38 %>%
  filter(chr == "MT")
# clean up gene labels
mt$symbol <- gsub("MT-", "", mt$symbol)
# add colors for protein vs tRNA
mt <- mutate(mt, color=biotype) # add duplicate column with new name
mt$color <- gsub("protein_coding", "fill_color=blue", mt$color)
mt$color <- gsub("Mt_tRNA", "fill_color=green", mt$color)
mt$color <- gsub("Mt_rRNA", "fill_color=purple", mt$color)

# highlight files
# sense
mtSense <- mt %>%
  filter(strand == 1) %>%
  dplyr::select(chr, start, end, color, symbol)
# save to highlight table
mtSenseTrim <- dplyr::select(mtSense, chr, start, end, color)
write.table(mtSenseTrim, "circos/data/highlight_sense.txt", row.names=FALSE, col.names = FALSE, quote = FALSE)

# antisense
mtAnti <- mt %>%
  filter(strand == -1) %>%
  dplyr::select(chr, start, end, color, symbol)
# add in D-loop
mtAnti <- rbind(mtAnti, c("MT", "1", "576", "fill_color=yellow", "D-loop"))
mtAnti <- rbind(mtAnti, c("MT", "16024", "16569", "fill_color=yellow", "D-loop"))
# save to highlight table
mtAntiTrim <- dplyr::select(mtAnti, chr, start, end, color)
write.table(mtAntiTrim, "circos/data/highlight_antisense.txt", row.names=FALSE, col.names = FALSE, quote = FALSE)

# gene label file
mtGenes <- rbind(mtSense, mtAnti)
mtGenes <- dplyr::select(mtGenes, chr, start, end, symbol)
write.table(mtGenes, "circos/data/gene_labels.txt", row.names=FALSE, col.names = FALSE, quote = FALSE)
