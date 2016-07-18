# Check that gplot2/plyr/cummeRbund/SQLite 0.1... versions are loaded.
# Example genes: Armc3 , Nsun2 , Rims4 , Matn4 .

# load CummbeRbund library
library("cummeRbund")

# Setup working directory
setwd("[path]/rn6_cuffdiff_out")
get()

# Create a cummbeRbund database
cuff <- readCufflinks()

##################################################################
###########  Global Statistics and Quality Control ###############
##################################################################

# Create a dispersion plot
disp <- dispersionPlot(genes(cuff))
disp
#ERROR: Error in `$<-.data.frame`(`*tmp*`, "SCALE_X", value = 1L) : 
#replacement has 1 row, data has 0
#In addition: Warning message:
#In max(panels$ROW) : no non-missing arguments to max; returning -Inf

isoforms.scv<-fpkmSCVPlot(isoforms(cuff))
genes.scv<-fpkmSCVPlot(genes(cuff))
#Error in sqliteExecStatement(con, statement, bind.data) : 
#  RS-DBI driver: (error in statement: near ")": syntax error)

# Plot the distribution of expression levels of each sample
den <- csDensity(genes(cuff))
den
densRep<-csDensity(genes(cuff),replicates=)
#ERROR: Error in sqliteExecStatement(con, statement, bind.data) : 
#RS-DBI driver: (error in statement: near ")": syntax error)
densRep

# Create a Boxplot
box <- csBoxplot(genes(cuff))
box
brep<-csBoxplot(genes(cuff),replicates=T)
#ERROR: Error in sqliteExecStatement(con, statement, bind.data) : 
#RS-DBI driver: (error in statement: near ")": syntax error)
brep

# Create a matrix of pairwise scatterplot
scat <- csScatterMatrix(genes(cuff))
scat
s <- csScatter(genes(cuff),"control","treated",smooth=T) #Need to change examples
s

# Create a Dendogram
dend <- csDendro(genes(cuff))
dend
dend.rep <- csDendro(genes(cuff),replicates=T)
#ERROR: Error in csDendro(genes(cuff), replicates = T) : 
#error in evaluating the argument 'object' in selecting a method for function 'csDendro': Error in genes(cuff) : 
#error in evaluating the argument 'object' in selecting a method for function 'genes': Error: object 'cuff' not found
dend.rep

# VolcanoMatrix
v<-csVolcanoMatrix(genes(cuff))
v

##################################################################
######################## Gene Sets ###############################
##################################################################

#Creting Gene Sets
data(sampleData)
myGeneIds<-sampleIDs
myGeneIds

myGenes<-getGenes(cuff,myGeneIds)
myGenes

head(fpkm(myGenes))

# Heatmap 
h<-csHeatmap(myGenes,cluster='both')
h

# Expression Barplot
b<-expressionBarplot(myGenes)
b

#Need to rename our conditions!
# Scatter
s<-csScatter(myGenes, "control","treated",smooth=T)
#Using tracking_id, sample_name as id variables
s	
#show Error in seq.default(range[1], range[2], length = n) : 'from' cannot be NA, NaN or infinite but the plot show


# Volcano
v<-csVolcano(myGenes,"control","treated")
v

# Heatmap of isoforms
ih<-csHeatmap(isoforms(myGenes),cluster='both',labRow=F)
#'both' needs to be changed.
ih

# Heatmap of TSS
th<-csHeatmap(TSS(myGenes),cluster='both',labRow=F)
th 

##################################################################
################### Individual Genes #############################
##################################################################

# Example genes: Armc3 , Nsun2 , Rims4 , Matn4 .
#                Tubg1 , Ramp2 , Aoc3 , Rdm1.
myGeneId<-"Armc3"
myGene<-getGene(cuff,myGeneId)
myGene
#Some of these return zero data as you might expect

####For example with gene_id "ERCC-00131"####
myGeneId <- "ERCC-00131"
myGene<-getGene(cuff,myGeneId)


#### For example with genename "Plagl1"#####
myGeneId <- "Plagl1"
myGene<-getGene(cuff,myGeneId)


# Expression Plot
g1<-expressionPlot(myGene)
g1

# Expression Barplot
gb<-expressionBarplot(myGene)
gb

# Pie Charts
gp<-csPie(myGene,level="isoforms")
gp
##Supatcha >> Error: could not find function "csPie"

# http://compbio.mit.edu/cummeRbund/index.html
# Need cummeRbund 2.7 for Pie Charts, have 2.4