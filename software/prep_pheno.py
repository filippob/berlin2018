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
   inputfile = ''
   outputfile = ''
   try:
      opts, args = getopt.getopt(argv,"hi:o:",["ifile=","ofile="])
   except getopt.GetoptError:
      print('prep_pheno.py -i <inputfile> -o <outputfile>')
      sys.exit(2)
   for opt, arg in opts:
      if opt == '-h':
         print('prep_pheno.py -i <inputfile> -o <outputfile>')
         sys.exit()
      elif opt in ("-i", "--ifile"):
         inputfile = arg
      elif opt in ("-o", "--ofile"):
         outputfile = arg
   print('Input file is ', inputfile)
   print('Output file is ', outputfile)
   return(inputfile,outputfile)


################
### LOGGING ####
logging.basicConfig(level=logging.DEBUG,format='%(levelname)-6s [%(asctime)s]  %(message)s')
logging.info("Beginning to read and manipulate file ...")
################

### parsing the command line ###
if __name__ == "__main__":
   inf,outf= main(sys.argv[1:])


### reading and manipulating the phenotype file ###
pheno_df= pd.read_csv(inf, sep=" ", names = ['breed', 'id', 'sex', 'phenotype'])
logging.debug("N. of rows read from phenotype file: '%s'",len(pheno_df))
#print(len(pheno_df))

logging.info("First few lines of input file:")
print(pheno_df.head())

pheno_df.loc[pheno_df['breed'] != 'Jacobs', 'phenotype'] = 0
pheno_df.loc[pheno_df['breed'] == 'Jacobs', 'phenotype'] = 1

logging.info("A glimpse on data from the two breeds:")
print(pheno_df.loc[pheno_df['breed'] != 'Jacobs',].head())
print(pheno_df.loc[pheno_df['breed'] == 'Jacobs',].head())

cols= ['id','breed','phenotype','sex']
pheno_df= pheno_df[cols]

logging.debug("Name of output file: '%s'",outf)
logging.info("First few lines of the phenotype file to be written out")
print(pheno_df.tail())

logging.info("writing out phenotype file ...")
pheno_df.to_csv(outf,sep=" ")
logging.info("DONE!")
