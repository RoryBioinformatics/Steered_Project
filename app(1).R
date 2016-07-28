###########################################################################################################################
# Place any code that you only want to be run once per user outside the server function ###################################
###########################################################################################################################

library(shiny)
library("cummeRbund")
library("plyr")
library("Hmisc")
cuff <- readCufflinks(genome = 'rn6', gtfFile = "merged.gtf")

###########################################################################################################################
# UI FUNCTION #############################################################################################################
###########################################################################################################################

ui <- fluidPage(
                theme = "style.css",
                h1("FingeRNAilsDB"),
                tabsetPanel(
                            tabPanel(
                                      title = "Uni-gene search",                      
                                      fluidRow(column(12, headerPanel('Uni-gene search'))),
             
                                      sidebarLayout(
                                                    sidebarPanel(
                                                                  textInput(inputId = "gene_id", label = "Enter gene name (capitalise first letter only) or XLOC number", value = "", placeholder = "Adh4 or XLOC_009602"),  
                                                                  radioButtons("plottype", label="Select plot type:", choices = list("Line" = 1, "Bar" = 2), selected = 1),
                                                                  submitButton(text = "Search")
                                                                ),
                                                    sidebarPanel(
                                                                  strong("Your Gene"),
                                                                  textOutput("gsn"), 
                                                                  textOutput("id"),
                                                                  textOutput("iso"),
                                                                  textOutput("tss"),
                                                                  uiOutput("sample")
                                                                )
                                                    ),
             
                                      mainPanel(
                                                position = "right",
                                                tabsetPanel(
                                                            tabPanel("Differential Gene Expression",plotOutput("geneDiffExp"),tableOutput("rawplotdatagene")),
                                                            tabPanel("Differential Alternative Splicing", plotOutput("isoDiffExp"),tableOutput("rawplotdataiso")),
                                                            tabPanel("Differential TSS/Promoter Selection",plotOutput("tssDiffExp")),
                                                            tabPanel("Similarly Expressed Genes (very slow!)","Finding similarly expressed genes will slow down this page for 2-3 minutes. Results with no gene short name are from novel transcripts.",tableOutput("simGenes"))
                                                            )
                                                )
                                    ),
 
                            tabPanel(
                                      title = "Multi-gene Search",
                                      fluidRow(column(12, headerPanel('Multi-gene Search'))),
                                      
                                      sidebarLayout(
                                                    sidebarPanel(
                                                                  textInput("gene_list", label = "Enter a space separated list of gene short names (e.g. Adh4 Trip13) or XLOC number (e.g. XLOC_009602 XLOC_000157)", value = ""),
                                                                  submitButton(text="Search")
                                                                ),
                                                   
                                                    sidebarPanel(
                                                                   strong("Top Tip: Copy and paste the full table provided by the similarly expressed genes tab in uni-search to veiw plots for those genes with a similar expression profile to your gene of interest. Don't worry about formatting the table, we've taken care of that!")
                                                                )
                                                    ),
                                      mainPanel(
                                                  position = "right",
                                                  tabsetPanel(
                                                              tabPanel("Heat Map",plotOutput("heatmap")),
                                                              tabPanel("Bar Plot", plotOutput("barplot")),
                                                              tabPanel("Scatter Plot", plotOutput("scatterplot")),
                                                              tabPanel("Volcano Plot", plotOutput("volcanoplot")),
                                                              tabPanel("Raw Data", tableOutput("rawdata"))
                                                              )
                                                )
                                    )
                            )
                )

###########################################################################################################################
# SERVER FUNCTION #########################################################################################################
###########################################################################################################################
server <- function(input, output){
  
  #########################################################################################################################                                    
  # UNI_GENE ##############################################################################################################
  #########################################################################################################################
  
  # Take the user gene name input and create a cuffGene object containing all information about the gene
  my_gene <- reactive({getGenes(cuff,geneIdList = input$gene_id,sampleIdList = input$sns)})
  
  # Populate the Summary panel
  output$gsn <- renderText({if (input$gene_id != "") {paste("Gene short name: ", as.character(featureNames(my_gene())$gene_short_name))}})
  output$id <- renderText({if (input$gene_id != "") {paste("Tracking ID : ", as.character(featureNames(my_gene())$tracking_id))}})
  output$iso <- renderText({if (input$gene_id != "") {paste("No. of isoforms : ", as.character(length(isoforms(my_gene()))))}})
  output$tss <- renderText({if (input$gene_id != "") {paste("No. of transcription start sites (TSS) : ", as.character(length(TSS(my_gene()))))}})
  output$sample <- renderUI({if (input$gene_id != "") {
                                                        sample_names_for_checkbox<-as.character(samples(my_gene()))
                                                        checkboxGroupInput("sns","Select/Deselect sample then press search:", sample_names_for_checkbox)
                                                      }}) 
  
  
  # Populate the Differential Gene Expression tab
  output$geneDiffExp <- renderPlot({if (input$gene_id != ""){
                                                                if (input$plottype == 1){expressionPlot(my_gene())}
                                                                else if (input$plottype == 2){expressionBarplot(my_gene())}
                                                            }})
  output$rawplotdatagene <- renderTable({if (input$gene_id != "")
  {
    frame1<-as.data.frame(fpkm(my_gene()))
    frame2<-as.data.frame(annotation(my_gene()))
    frame3<-merge(frame1,frame2)
    geneinfo <- subset(frame3, select = c(gene_short_name,gene_id,locus,sample_name,fpkm,conf_hi,conf_lo))
  }})
  
  # Populate the Differential Alternative Splicing tab
  output$isoDiffExp <- renderPlot({if (input$gene_id != "") {
                                                              if (input$plottype == 1){expressionPlot(isoforms(my_gene()))}
                                                              else if (input$plottype == 2){expressionBarplot(isoforms(my_gene()))}
                                                            }})
  output$rawplotdataiso <- renderTable({if (input$gene_id != "") 
  {
    frame1<-as.data.frame(fpkm(isoforms(my_gene())))
    frame2<-as.data.frame(annotation(isoforms(my_gene())))
    frame3<-merge(frame1,frame2)
    isoforminfo <- subset(frame3, select = c(isoform_id,length,TSS_group_id,sample_name,fpkm,conf_hi,conf_lo,gene_short_name,gene_id,locus,nearest_ref_id))
  }})
  
  # Populate the Differential TSS/Promoter Selection tab
  output$tssDiffExp <- renderPlot({if (input$gene_id != "") {
                                                              if (input$plottype == 1){expressionPlot(TSS(my_gene()))}
                                                              else if (input$plottype == 2){expressionBarplot(TSS(my_gene()))}
                                                            }})

  # Populate the Similarily Expressed Genes tab
  output$simGenes <- renderTable({if (input$gene_id != "") {
                                                            genelist<-findSimilar(cuff,input$gene_id,n=20)
                                                            names<-featureNames(genelist)
                                                            }})  
  
  ########################################################################################################################
  # MULTI-GENE ###########################################################################################################
  ########################################################################################################################
  # sample gene list:  Acadsb Acsm5 Aldh1a1 Cpt1a Ctr9 Dhcr7 Eef1g Fau Glyat Klf9 Mpeg1 Pnpla2 Rplp2 
  
  # Take the user gene list input and create a cuffGeneSet object containing all information about the genes
  my_genes <- reactive({
                          mylist<-unlist(strsplit(input$gene_list, " "))
                          getGenes(cuff,geneIdList=mylist)
                      })
  
  # Populate heat map tab
  output$heatmap <- renderPlot({if (input$gene_list != ""){csHeatmap(my_genes(),cluster='both')}})
  
  # Populate bar plot tab
  output$barplot <- renderPlot({if (input$gene_list != "") {expressionBarplot(my_genes())}})
  
  # Populate scatter plot tab
  output$scatterplot <- renderPlot({if (input$gene_list != "") {csScatter(my_genes(), "control","treated",smooth=T)}})
  
  # Populate volcano plot tab
  output$volcanoplot <- renderPlot({if (input$gene_list != "") {csVolcano(my_genes(),"control","treated",xlimits = c(-10, 10),alpha=0.05,showSignificant=FALSE)}})
  
  # Populate the raw data tab - unfortunately this duplicates everything
  output$rawdata <- renderTable({if (input$gene_list != "")
  {
    
    frame1<-as.data.frame(fpkm(my_genes()))
    frame2<-as.data.frame(annotation(isoforms(my_genes())))
    frame3<-merge(frame1,frame2)
    genesetinfo <- subset(frame3, select = c(gene_short_name, gene_id, locus, isoform_id, length, TSS_group_id, sample_name, fpkm, conf_hi, conf_lo, nearest_ref_id))
    
  }})

}

###########################################################################################################################
shinyApp(ui = ui, server = server)
###########################################################################################################################
