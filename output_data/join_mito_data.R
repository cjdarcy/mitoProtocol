# Set working directory
setwd("/Users/cjdarcy/GitHub/cg_mito/data/output_data")

# Read in 'mito_output_1'
mito_1 <- read.table(file='mito_output_1.tsv',
                     sep='\t',
                     header=TRUE)

# Read in 'mito_output_2'
mito_2 <- read.table(file='mito_output_2.tsv',
                     sep='\t',
                     header=TRUE)

# Join tables
mito_joined <- merge(mito_1, mito_2)

# Write output table 'mito_joined.csv'
write.table(mito_joined,
            file='mito_joined.tsv',
            sep='\t',
            quote=FALSE,
            col.names=NA)