# create circular mt genome visualization

# install and load packages
devtools::install_github("stephenturner/annotables")
library(annotables) # gene and tRNA annotations (grch38)
library(dplyr)

# extract only mtDNA
mt <- grch38 %>%
  filter(chr == "MT")
# convert column headers
colnames(mt)
colnames(mt) <- c("ensgene", "entrez", "GeneName", "Chromosome", "ChromStart", "ChromEnd", "strand", "biotype", "description")
# reorder columns
mt <- mt[c(4,5,6,1,2,3,7,8,9)]
# remove -1 strand
mt <- mt %>%
  filter(strand == 1)

# subsetting to troubleshoot
mt <- mt[1:2, ]

# create dummy ideogram for plot
base <- read.csv("~/Desktop/mt_full.tsv", sep=" ")
base$Chromosome <- as.character(base$Chromosome)

## plot diagram

#pdf("~/Desktop/test.pdf")

RCircos.Set.Plot.Area()
RCircos.Chromosome.Ideogram.Plot()

# initialize parameters
cyto.info <- base
chr.exclude <- NULL
tracks.inside <- 0
tracks.outside <- 1
RCircos.Set.Core.Components(cyto.info, chr.exclude, tracks.inside, tracks.outside)

# plot gene connectors
#name.col <- 6
side <- "out"
track.num <- 1
RCircos.Gene.Connector.Plot(mt, track.num, side)
#track.num <-2
#RCircos.Gene.Name.Plot(mt, name.col, track.num, side)
#?RCircos.Reset.Plot.Parameters # modify RCircos core components
# RCircos.Reset.Plot.Ideogram(base) RCircos.Get.Plot.Ideogram()
# RCircos.Get.Plot.Positions()  RCircos.Reset.Plot.Positions()
# RCircos.Reset.Plot.Parameters() RCircos.Get.Plot.Parameters()

#dev.off()