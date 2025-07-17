library(data.table)

# combine different ChIP-seq data to get a set of peaks
# merges overlapping peaks with same TF target (assumes input is already tissue-specific)
# byCell = T can make it go by TF + cell type
chipCondense <- function(fname, byCell = F) {
  # read in and assign column names
  atl <- fread(fname)
  colnames(atl) <- c('chr','start','end','name','score','strand','source','title','cell','target')
  
  # if going by cell type rename to use name as target
  if (byCell) {
    colnames(atl) <- c('chr','start','end','target','score','strand','source','title','cell','tf')
  }
  
  # sort by position values
  atl <- atl[order(start, end)]
  
  # assign group labels
  atl[, group := paste(target, cumsum(
    cummax(shift(end, fill = start[1])) < start) + 1, sep='_'),
    by = target]
  
  # condense by group
  atl <- atl[, .(chr = chr[1],
                 start = min(start), 
                 end = max(end), 
                 score = min(score), 
                 sources = length(unique(title)), 
                 name = target[1]), 
             by = group]
  
  # return condensed data
  return(atl[, .(chr, start, end, group, sources, score, name)])
}

args = commandArgs(trailingOnly = T)
print(args[1])