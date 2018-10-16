library("dplyr")
library("knitr")
library("GenABEL")
library("ggplot2")
library("reshape2")

setwd("~/Dropbox/cursos/berlin2018")

load("data/df_genabel.RData")


descriptives.marker(df)
kable(descriptives.trait(df))

mP <- melt(phdata(df))
mP <- mP %>%
  filter(variable != "sex")

kable(head(mP))


p <- ggplot(mP,aes(value)) + geom_bar(aes(fill=value))
ggsave(file="barplot.pdf", plot = p, device = "pdf")

qc1 <- check.marker(df, p.level=0)
df1 <- df[,qc1$snpok]

K <- ibs(df1,weight = "freq")
K[upper.tri(K)] = t(K)[upper.tri(K)]

pdf("heatmap.pdf")
heatmap(K,col=rev(heat.colors(75)))
dev.off()


h2a <- polygenic(phenotype,data=df1,kin=K,trait.type = "binomial")
df.mm <- mmscore(h2a,df1)
write.table(descriptives.scan(df.mm,top=100),file = "topres.csv", col.names = TRUE)

pdf(paste("gwas.pdf",sep=""))
plot(df.mm,col = c("red", "slateblue"),pch = 19, cex = .5, main="phenotype")
dev.off()

descriptives.scan(df.mm)
L <- list("h2"=h2a$esth2,"lambda"=lambda(df.mm)[1])
print(L)
