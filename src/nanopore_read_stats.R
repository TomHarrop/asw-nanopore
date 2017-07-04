#!/usr/bin/env Rscript

library(data.table)
library(ggplot2)
library(scales)

# colourz
set1 <- RColorBrewer::brewer.pal(9, "Set1")

list.files("output/porechop_bbduk/")
# length histogram
lhist <- fread("output/porechop_bbduk/lhist.txt")
ggplot(lhist, aes(x = `#Length`, y = Count)) +
    scale_x_continuous(trans = log_trans(base = 4),
                       breaks = trans_breaks(function(x) log(x, 4),
                                             function(x) 4^x)) +
    geom_point(colour = alpha(set1[1], 0.25)) +
    geom_vline(xintercept = 500, colour = set1[2])

# gc histogram
gchist <- fread("output/porechop_bbduk/gchist.txt", skip = 4)
ggplot(gchist, aes(x = `#GC`, y = Count)) +
    geom_col(fill = set1[1]) +
    geom_vline(xintercept = 0.3019*100, colour = alpha(set1[2], 0.8)) +
    geom_vline(xintercept = c(0.3019 + 0.0298, 0.3019 - 0.0298) * 100,
               colour = alpha(set1[2], 0.8),
               linetype = 2)

# qc histogram
aqhist <- fread("output/porechop_bbduk/aqhist.txt")
ggplot(aqhist, aes(x = `#Quality`, y = count1)) +
    geom_col(fill = set1[1]) +
    geom_vline(xintercept = 6.5, colour = set1[2])

