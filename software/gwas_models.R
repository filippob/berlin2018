library("ggplot2")
library("knitr")

## GWAS: quantitative traits

setwd("~/Dropbox/cursos/berlin2018/data/")
phenotypes <- read.table("phenotypes_rice.txt", header = TRUE)
genotypes <- read.table("rice_snp.raw", header = TRUE)
genotypes <- genotypes[,-c(1,3,4,5,6)]

phenotypes <- merge(phenotypes, genotypes, by.x="id", by.y="IID")
names(phenotypes) <- c("id","population","PH","sex","snp")

kable(head(phenotypes))

### Modelling number of copies of the minor allele
fit <- lm(PH~snp, data = phenotypes)
g <- summary(fit)
g

#### ANOVA table

kable(anova(fit))

### Modelling genotypes
phenotypes$snp <- as.factor(phenotypes$snp)
fit <- lm(PH~snp, data = phenotypes)

g <- summary(fit)
g

kable(anova(fit))

## Adding population structure
fit <- lm(PH~population+snp, data = phenotypes)

g <- summary(fit)
g
anova(fit)

## GWAS: binary traits

setwd("~/Dropbox/cursos/berlin2018/data/")
phenotypes <- read.table("pheno_genabel.dat", header = TRUE)
genotypes <- read.table("sheep_snp.raw", header = TRUE)
genotypes <- genotypes[,-c(1,3,4,5,6)]

phenotypes <- merge(phenotypes, genotypes, by.x="id", by.y="IID")
names(phenotypes) <- c("id","breed","horns","sex","snp")

kable(head(phenotypes))

## prepare data
phenotypes <- phenotypes[phenotypes$horns!=0,]
phenotypes$horns <- phenotypes$horns-1

### Fit a generalised linear model

fit <- glm(horns~snp, data = phenotypes, family=binomial(link="logit"))

g <- summary(fit)
g

full_model <- glm(horns~snp, data = phenotypes, family="binomial")
reduced_model <- glm(horns~1, data = phenotypes, family="binomial")
anova(reduced_model, full_model, test = "LRT")

l1 <- logLik(full_model)
l0 <- logLik(reduced_model)
df <- length(coef(full_model)) - length(coef(reduced_model)) 

teststat<--2*(as.numeric(l0)-as.numeric(l1))
pchisq(teststat,df=1,lower.tail=FALSE)

