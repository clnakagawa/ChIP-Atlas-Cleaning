library(data.table)
source('chipCondense.R')

atl <- chipCondense('data/atlas/lungAtlas.bed')
atlCell <- chipCondense('data/atlas/lungAtlas.bed', byCell = T)
fwrite(atlCell[,.(chr, start, end, name)], 'data/condensed/lungAtlasCell.bed', quote = F, 
       row.names = F, col.names = F, sep = '\t')
