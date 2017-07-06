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
# color by type of gene (or complex)
mt$color <- gsub("Mt_tRNA", "fill_color=vlgrey", mt$color)
mt$color <- gsub("Mt_rRNA", "fill_color=lorange", mt$color)
#mt$color <- gsub("protein_coding", "fill_color=vlgreen", mt$color)
# color protein coding genes by complex
com1 <- filter(mt, grepl("ND", symbol))
com1$color <- gsub("protein_coding", "fill_color=purple", com1$color)
com3 <- filter(mt, grepl("CYB", symbol))
com3$color <- gsub("protein_coding", "fill_color=yellow", com3$color)
com4 <- filter(mt, grepl("CO", symbol))
com4$color <- gsub("protein_coding", "fill_color=dblue", com4$color)
com5 <- filter(mt, grepl("ATP", symbol))
com5$color <- gsub("protein_coding", "fill_color=dgreen", com5$color)
# recombine color coded data
other <- filter(mt, color != "protein_coding")
mt <- rbind(other, com1, com3, com4, com5)

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
mtAnti <- rbind(mtAnti, c("MT", "1", "576", "D-loop", "fill_color=dred"))
mtAnti <- rbind(mtAnti, c("MT", "16024", "16569", "D-loop", "fill_color=dred"))
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
