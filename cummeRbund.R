# R script for analysing cuffdiff data using cummeRbund
# The script first creates a database using the cuffdiff output files
# Then produces whole genome plots, single gene plots, and gene set plots for visualisation

# SETUP ##########################################################

# 1) Make a working directory and copy into it the following:
        # all cuffdiff output files
        # genes.gtf file from reference annotation
        # genome.fa file from reference annotation

# 2) To get gene_id from tracking_id
        # https://biobeat.wordpress.com/2013/01/18/retrieve-short-gene-names-in-cummerbund/
        # http://seqanswers.com/forums/showthread.php?t=18357

# 3) load packages recommended by user manual
library("cummeRbund")
library("plyr")
library("Hmisc")

# 4) Set working directory
setwd("/home/kwc17/Documents/University/4_MSc_Bioinformatics/7_SRP/shinyapp/r_working_directory")
getwd()

# 5) Create a cummbeRbund database (include genome and gtfFile arguments to annotate the database)
cuff <- readCufflinks(genome = "genome.fa", gtfFile = "genes.gtf")

##################################################################
# Global Stats ###################################################
##################################################################

# To visualise the metadata of the database (number of genes + isoforms etc)
cuff

# To assess the distributions of gene/isoform FPKM scores for each condition
geneDensity<-csDensity(genes(cuff))
isoDensity<-csDensity(isoforms(cuff))

# To create a scatter plot comparing gene/isoform expression values (in FPKM) between conditions
# The smooth (blue) line is the line of best fit that best represents the relationship between the two conditions
geneScatter<-csScatter(genes(cuff),"control","treated",smooth=T)
isoScatter<-csScatter(isoforms(cuff),"control","treated",smooth=T)

# To create a volcano plot (significance v fold change) using FPKM to show significant differential expression of genes/isoforms between conditions
geneVolcano<-csVolcano(genes(cuff),"control","treated",xlimits = c(-10, 10),alpha=0.05,showSignificant=T)
isoVolcano<-csVolcano(isoforms(cuff),"control","treated",xlimits = c(-10, 10),alpha=0.05,showSignificant=T)

##################################################################
# Individual Genes ###############################################
##################################################################

# To create a cuffGene object called "myGene"
myGeneShortName<-"Adh6"                                          # find a way of passing a value to this variable
myGene<-getGene(cuff,myGeneShortName)                            # parses all information about the gene

# To retrieve fpkm values
head(fpkm(myGene))                                               # returns the gene_id and fpkm values from gene_exp.diff
head(fpkm(isoforms(myGene)))                                     # returns all isoform_ids and their fpkm values for the gene from isoform_exp.diff (ignore sample_name column)

# To create a differential expression line plot for the gene and for each isoform of the gene
geneDiffExpLine<-expressionPlot(myGene)
isoDiffExpLine<-expressionPlot(isoforms(myGene)) + labs(x="Blue = CONTROL | Red = TREATED",y="FPKM")

# To create a differential expression bar plot for the gene for each isoform of the gene
geneDiffExpBar<-expressionBarplot(myGene)
isoDiffExpBar<-expressionBarplot(isoforms(myGene)) + labs(x="Blue = CONTROL | Red = TREATED",y="FPKM")

##################################################################
# Gene sets ######################################################
##################################################################

# Select one of three methods to create a CuffGeneSet object called "myGenes" for analysis
        # 1) To create a gene set of significant differentially expressed genes (or specified features e.g. for isoforms change the argument "level" from 'genes' to 'isoforms')
             sigSet<-getSig(cuff,alpha=0.05,level='genes')
             length(sigSet)
             myGeneIds<-sigSet
             myGenes<-getGenes(cuff,myGeneIds)
             
        # 2) To create a gene set that only contains ten genes with the most similar expression profile to a user specified gene
             myGeneShortName<-"Adh6"                              # find a way of passing a value to this variable
             myGenes<-findSimilar(cuff,myGeneShortName,n=10)
             
        # 3) To create a gene set defined by the user
             data(sampleData)                                     # find away of passing multiple genes to this variable
             myGeneIds<-sampleIDs
             myGenes<-getGenes(cuff,myGeneIds)

# To retrieve fpkm values
head(fpkm(myGenes))                                               # returns the gene_id and fpkm values for every gene from gene_exp.diff
head(fpkm(isoforms(myGenes)))                                     # returns all isoform_ids and their fpkm values for every gene from isoform_exp.diff (ignore sample_name column)

# To create a heatmap and bar plot of the gene set FPKM values for each condition (only use a bar plot when using simSet)
geneSetDiffExpHeat<-csHeatmap(myGenes,cluster='both',heatscale= c(low='darkblue',mid='white',high='darkred'))
geneSetDiffExpBar<-expressionBarplot(myGenes)

# To create a scatter plot of the gene set comparing gene expression values (in FPKM) between conditions
geneSetScatter<-csScatter(myGenes, "control","treated",smooth=T)

# To create a volcano plot (significance v fold change) using FPKM to show significant differential expression of genes in the gene set between conditions
geneSetVolcano<-csVolcano(myGenes,"control","treated",xlimits = c(-10, 10),alpha=0.05,showSignificant=T)
