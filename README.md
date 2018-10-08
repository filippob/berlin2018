# berlin2018
## GWAS course in Berlin

git repository: git clone https://github.com/filippob/berlin2018.git

### Example data
From Kijas et al. 2016
- paper: https://onlinelibrary.wiley.com/doi/pdf/10.1111/age.12409
- data: https://datadryad.org/resource/doi:10.5061/dryad.1p7sf

From Biscarini et al. 2016
- paper: https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0155425
- data: https://zenodo.org/record/50803#.W6nhanUzZhE

From Kijas et al.


### subset data
plink --file GBSnew --chr 4-8 --thin 0.25 --recode --out rice_berlin2018
plink --sheep --file 4H_160indivs_Final --chr 1-3 --thin 0.1 --recode --out sheep


