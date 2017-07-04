source("https://bioconductor.org/biocLite.R")
biocLite("ggbio")
library(ggbio)

data("CRC", package = "biovizBase")
autoplot(hg19sub, layout = "circle", fill  = "gray70")
str(hg19sub)
hg19sub@seqinfo # does not include mitochondria

