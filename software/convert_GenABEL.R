library("GenABEL")

args = commandArgs(trailingOnly = TRUE)

tPed= args[1]
tFam= args[2]
phenotype_data= args[3]

print(paste("tped file is",tPed))
print(paste("tfam file is",tFam))
print(paste("phenotypes file is",phenotype_data))

setwd("../data")

convert.snp.tped(tped=tPed,
                 tfam=tFam,
                 out="genabel.raw",
                 strand="+")

df <- load.gwaa.data(phe=phenotype_data, 
                     gen="genabel.raw",
                     force=TRUE
)

save(df,file="df_genabel.RData")

print("DONE!")

