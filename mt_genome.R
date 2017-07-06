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
  dplyr::select(chr, start, end, symbol, color)
# save to highlight table
write.table(mtSense, "circos/data/highlight_sense.txt", row.names=FALSE, col.names = FALSE, quote = FALSE)

# antisense
mtAnti <- mt %>%
  filter(strand == -1) %>%
  dplyr::select(chr, start, end, symbol, color)
# add in D-loop
mtAnti <- rbind(mtAnti, c("MT", "1", "576", "D-loop", "fill_color=yellow"))
mtAnti <- rbind(mtAnti, c("MT", "16024", "16569", "D-loop", "fill_color=yellow"))
# save to highlight table
write.table(mtAnti, "circos/data/highlight_antisense.txt", row.names=FALSE, col.names = FALSE, quote = FALSE)

# gene label file
# combine sense and antisense
mtGenes <- rbind(mtSense, mtAnti)
mtGenes$start <- as.numeric(mtGenes$start)
mtGenes <- mtGenes[order(mtGenes$start),]
# find full gene names to match symbols
names <- read.table("rCRS.gb.txt", sep="\t", skip=85)
names <- unique(filter(names, grepl("gene=", V1)))
names <- c("D-loop", gsub("^.*gene=", "", names$V1, perl=TRUE), "D-loop")
mtGenes <- cbind(mtGenes, names)
mtGenes <- dplyr::select(mtGenes, chr, start, end, names)
write.table(mtGenes, "circos/data/gene_labels.txt", row.names=FALSE, col.names = FALSE, quote = FALSE)
