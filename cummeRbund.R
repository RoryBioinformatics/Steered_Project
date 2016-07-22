# R script for analysing cuffdiff data using cummeRbund
# The script first creates a database using the cuffdiff output files
# Then produces whole genome plots, single gene plots, and gene set plots for visualisation

# SETUP ##########################################################

# 1) Make a working directory and copy into it the following:
        # all cuffdiff output files
        # merged.gtf file used in cuffdiff analysis

# 2) load packages recommended by user manual
library("cummeRbund")
library("plyr")
library("Hmisc")

# 3) Set working directory
setwd("/home/kwc17/Documents/University/4_MSc_Bioinformatics/7_SRP/shinyapp/app") 
getwd()

# 4) Create a cummbeRbund database (include genome and gtfFile arguments to annotate the database)
cuff <- readCufflinks(genome = 'rn6', gtfFile = "merged.gtf",rebuild = TRUE)

# 5) create an annotated data frame of all genes (requires gtfFile from above) - not required in this script.
#annotedDF<-read.table("genes.gtf",sep="\t",header=T,na.string="-")
#addFeatures(cuff,annotedDF,level="genes")

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
geneVolcano<-csVolcano(genes(cuff),"control","treated",xlimits = c(-10, 10),alpha=0.05,showSignificant=TRUE)
isoVolcano<-csVolcano(isoforms(cuff),"control","treated",xlimits = c(-10, 10),alpha=0.05,showSignificant=TRUE)

##################################################################
# Individual Genes ###############################################
##################################################################

# Compulsory: create a cuffGene object called "myGene"
myGeneShortName<-"Adh6"                                          # find a way of passing a value to this variable
myGene<-getGene(cuff,myGeneShortName)                            # parses all information about the gene

# To retrieve fpkm values
head(fpkm(myGene))                                               # returns the gene_id and fpkm values from gene_exp.diff
head(fpkm(isoforms(myGene)))                                     # returns all isoform_ids and their fpkm values for the gene from isoform_exp.diff (ignore sample_name column)

# To create a data frame of isoform information of a gene
frame1<-as.data.frame(fpkm(isoforms(myGene)))
frame2<-as.data.frame(annotation(isoforms(myGene))) 
frame3<-merge(frame1,frame2)
isoforminfo <- subset(frame3, select = c(isoform_id,length,TSS_group_id,sample_name,fpkm,conf_hi,conf_lo,gene_short_name,gene_id,locus,nearest_ref_id))

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
             
        # 2) To create a gene set that only contains 20 genes: the user specified gene and the 19 most similar by expression profile
             myGeneShortName<-"Adh6"                              # find a way of passing a value to this variable
             myGenes<-findSimilar(cuff,myGeneShortName,n=20)
             
        # 3) To create a gene set defined by the user
             data(sampleData)                                     # find away of passing multiple genes to this variable
             myGeneIds<-sampleIDs
             myGenes<-getGenes(cuff,myGeneIds)

# To retrieve the short gene IDs for the tracking IDs in your gene set
names<-featureNames(myGenes)

# To retrieve fpkm values
head(fpkm(myGenes))                                               # returns the gene_id and fpkm values for every gene from gene_exp.diff
head(fpkm(isoforms(myGenes)))                                     # returns all isoform_ids and their fpkm values for every gene from isoform_exp.diff (ignore sample_name column)

# To create a heatmap and bar plot of the gene set FPKM values for each condition (only use a bar plot when using simSet)
geneSetDiffExpHeat<-geneSetDiffExpHeat<-csHeatmap(myGenes,cluster='both')
geneSetDiffExpBar<-expressionBarplot(myGenes)

# To create a scatter plot of the gene set comparing gene expression values (in FPKM) between conditions
geneSetScatter<-csScatter(myGenes, "control","treated",smooth=T)

# To create a volcano plot (significance v fold change) using FPKM to show significant differential expression of genes in the gene set between conditions
geneSetVolcano<-csVolcano(myGenes,"control","treated",xlimits = c(-10, 10),alpha=0.05,showSignificant=T)

################################################################
