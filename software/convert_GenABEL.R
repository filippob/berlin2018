library("GenABEL")

args = commandArgs(trailingOnly = TRUE)

tPed= args[1]
tFam= args[2]
phenotype_data= args[3]

print(paste("tped file is",tPed))
print(paste("tfam file is",tFam))
print(paste("phenotypes file is",phenotype_data))

#setwd("~/Dropbox/cursos/berlin2018/data")
setwd("/home/ubuntu/data")

fname= basename(tPed)
fname= sub("transposed\\_","",fname)
fname1= paste(fname,"raw",sep=".")

convert.snp.tped(tped=tPed,
                 tfam=tFam,
                 out=fname1,
                 strand="+")

df <- load.gwaa.data(phe=phenotype_data, 
                     gen=fname1,
                     force=TRUE
)

fname2= paste(fname,"RData",sep=".")
save(df,file=fname2)

print("DONE!")

