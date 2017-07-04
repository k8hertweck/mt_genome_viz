# example code from RCircos vignette

data(UCSC.HG19.Human.CytoBandIdeogram)

chr.exclude <- NULL
cyto.info <- UCSC.HG19.Human.CytoBandIdeogram
tracks.inside <- 10
tracks.outside <- 0
RCircos.Set.Core.Components(cyto.info, chr.exclude, tracks.inside, tracks.outside)

RCircos.List.Plot.Parameters()

out.file <- "RCircosDemoHumanGenome.pdf"
pdf(file=out.file, height=8, width=8, compress=TRUE)
RCircos.Set.Plot.Area()
par(mai=c(0.25, 0.25, 0.25, 0.25))
plot.new()
plot.window(c(-2.5,2.5), c(-2.5, 2.5))

RCircos.Chromosome.Ideogram.Plot()

data(RCircos.Gene.Label.Data)
name.col <- 4
side <- "in"
track.num <- 1
RCircos.Gene.Connector.Plot(RCircos.Gene.Label.Data, track.num, side)
track.num <- 2
RCircos.Gene.Name.Plot(RCircos.Gene.Label.Data, name.col,track.num, side)

data(RCircos.Heatmap.Data)
data.col <- 6
track.num <- 5
side <- "in"
RCircos.Heatmap.Plot(RCircos.Heatmap.Data, data.col, track.num, side)

#data(RCircos.Scatter.Data)
#data.col <- 5
#track.num <- 6
#side <- "in"
#by.fold <- 1
#RCircos.Scatter.Plot(RCircos.Scatter.Data, data.col, track.num, side, by.fold)

#data(RCircos.Line.Data)
#data.col <- 5
#track.num <- 7
#side <- "in"
#RCircos.Line.Plot(RCircos.Line.Data, data.col, track.num, side)

data(RCircos.Histogram.Data)
data.col <- 4
track.num <- 8
side <- "in"
RCircos.Histogram.Plot(RCircos.Histogram.Data, data.col, track.num, side)

data(RCircos.Tile.Data)
track.num <- 9
side <- "in"
RCircos.Tile.Plot(RCircos.Tile.Data, track.num, side)

data(RCircos.Link.Data)
track.num <- 11
RCircos.Link.Plot(RCircos.Link.Data, track.num, TRUE)

data(RCircos.Ribbon.Data)
RCircos.Ribbon.Plot(ribbon.data=RCircos.Ribbon.Data, track.num=11, by.chromosome=FALSE, twist=FALSE)
dev.off()
