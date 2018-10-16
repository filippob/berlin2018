#################################################
## Imputation Functions
#################################################

#' Function to impute residual missing SSR genotypes
#'
#' This function implements KNNI (K-nearest neighbour imputation)
#' to impute residual missing SSR genotypes. Residual refers mainly to
#' a small proportion of uncalled genotypes. Missing SSR genotypes may result
#' also from the combination of different datasets (batches of samples) where
#' different SSR loci have been genotyped. In this latter case, the proportion of
#' missing genotypes may be higher and with non-random distribution.
#' This function can be used also in this latter case, but the researcher should
#' consider a potentially lower accuracy of imputation.
#'
#' @param ssr_data data frame with SSR genotypes (row names are sample names;
#' a column named `GROUP`` is required with group information)
#' @param dist_matrix matrix with SSR-based distances between samples
#' @param k the number of neighbours to be considered for KNNI (k-nearest
#' neighbours imputation). Defaults to 3
#'
#' @details
#' Rescaled values are calculated as:
#'
#' \deqn{ D_{rescaled} = ( new\_max - new\_min ) \cdot \frac{\left( D-min(D) \right)}{max(D)-min(D)} + new\_min }
#'
#'
#' @return A data.frame with imputed SSR genotypes
#'
#' @export
#'
#' @examples
#' #Use KNNI to impute missing SSR-genotypes
#' \dontrun{
#' D <- rescale_D(D)
#' }
#'

impute_SSR <- function(ssr_data,dist_matrix,k=3) {

  samples <- row.names(ssr_data)
  groups <- ssr_data$GROUP
  ssr_data$GROUP <- NULL
  nSNP <- ncol(ssr_data)
  nInd <- nrow(ssr_data)

  imputedM <- matrix(rep(NA,nInd*nSNP),nrow=nInd)

  print(paste(nSNP,"SNPs and",nInd,"samples",sep=" "))

  for(i in 1:ncol(ssr_data)) {

    print(paste("SNP n.",i,sep=" "))
    X <- ssr_data[,-i] #global matrix of features (train + test sets)
    y <- ssr_data[,i]
    names(y) <- samples
    k <- k

    if(length(y[is.na(y)])<1) {

      imputedM[,i] <- y
    } else {

      yy <- outer(y,y,FUN=function(x,z) as.integer(ifelse(is.na(x==z),FALSE,x!=z)))
      D <- (dist_matrix-yy)
      row.names(D) <- names(y)
      colnames(D) <- names(y)

      testIDS <- names(y[is.na(y)])
      trainIDS <- names(y[!is.na(y)])

      if(length(testIDS)!=1) {

        NN <- apply(D[as.character(testIDS),as.character(trainIDS)],1,order)
        NN <- t(NN)
        ids <- row.names(NN) #for the output file

        ergebnisse <- apply(NN[,1:k, drop=F], 1, function(nn) {
          tab <- table(y[trainIDS][nn]);
          maxClass <- names(which.max(tab))
          pred <- maxClass;
          return(pred)
        })
        y[testIDS] <- ergebnisse[testIDS]
      } else {

        n <- order(D[testIDS,trainIDS])[1:k]
        tab <- table(y[trainIDS][n]);
        maxClass <- names(which.max(tab))
        prob <- tab[maxClass]/k;
        pred <- maxClass;
        y[testIDS] <- pred
      }

      imputedM[,i] <- y
    }
  }

  colnames(imputedM) <- colnames(ssr_data)
  M <- cbind.data.frame(imputedM,"GROUP"=groups)
  rownames(M) <- samples

  write.table(M,file="imputedM.csv",col.names=TRUE,row.names=FALSE,quote=FALSE,sep=",")

  return(M)
}



