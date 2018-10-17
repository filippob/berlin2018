import sys
import numpy as np
import getopt
import pandas as pd
import logging

#######################
## FUNCTIONS
#######################

## function to parse the command line
def main(argv):
   inputfile1 = ''
   inputfile2 = ''
   outputfile = ''
   try:
      opts, args = getopt.getopt(argv,"hi:j:o:",["ifile1=","ifile2","ofile="])
   except getopt.GetoptError:
      print('prep_pheno.py -i <inputfile1> -j <inputfile2> -o <outputfile>')
      sys.exit(2)
   for opt, arg in opts:
      if opt == '-h':
         print('prep_pheno.py -i <inputfile1> -j <inputfile2> -o <outputfile>')
         sys.exit()
      elif opt in ("-i", "--ifile1"):
         inputfile1 = arg
      elif opt in ("-j", "--ifile2"):
         inputfile2 = arg
      elif opt in ("-o", "--ofile"):
         outputfile = arg
   print('Input file 1 is ', inputfile1)
   print('Input file 2 is ', inputfile2)
   print('Output file is ', outputfile)
   return(inputfile1,inputfile2,outputfile)


################
### LOGGING ####
logging.basicConfig(level=logging.DEBUG,format='%(levelname)-6s [%(asctime)s]  %(message)s')
logging.info("Beginning to read and manipulate file ...")
################

### parsing the command line ###
if __name__ == "__main__":
   inf1,inf2,outf= main(sys.argv[1:])


### reading and manipulating the phenotype files ###
pheno_df= pd.read_csv(inf1, sep=" ", names = ['breed', 'id', 'sex', 'phenotype'])
logging.debug("N. of rows read from phenotype file 1: '%s'",len(pheno_df))
pheno_df= pheno_df.drop('phenotype', axis=1)
#print(len(pheno_df))
pheno_df2= pd.read_csv(inf2, sep=" ", skiprows=1, names = ['num','breed','id','phenotype'])
logging.debug("N. of rows read from phenotype file 2: '%s'",len(pheno_df2))
pheno_df2= pheno_df2.drop(['num','breed'], axis=1)

logging.info("First few lines of input file 1:")
print(pheno_df.head())
logging.info("First few lines of input file 2:")
print(pheno_df2.head())

res= pd.merge(pheno_df, pheno_df2, on='id')

#pheno_df.loc[pheno_df['breed'] != 'Jacobs', 'phenotype'] = 0
#pheno_df.loc[pheno_df['breed'] == 'Jacobs', 'phenotype'] = 1

res.loc[pheno_df['sex'] == 1, 'sex'] = 0
res.loc[pheno_df['sex'] == 2, 'sex'] = 1

logging.info("A glimpse on data from the two breeds:")
print(res.loc[pheno_df['breed'] != 'Jacobs',].head())
print(res.loc[pheno_df['breed'] == 'Jacobs',].head())

cols= ['id','breed','phenotype','sex']
res= res[cols]

logging.debug("Name of output file: '%s'",outf)
logging.info("First few lines of the phenotype file to be written out")
print(res.tail())

logging.info("writing out phenotype file ...")
res.to_csv(outf,sep=" ")
logging.info("DONE!")
