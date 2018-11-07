library(shiny)
library(data.table)
library(ggplot2)
library(tidyverse)
library(corrplot)
library(FactoMineR)
library(factoextra)



shinyServer(function(input, output) {
  # setwd("C:/Users/acer/Desktop/Cours/MLSD 2018/Statistique descriptive/projet shiny/Happiness")
  happiness <- read.csv("happiness.csv")
  # terrorism <- read.csv("C:/Users/acer/Desktop/Cours/MLSD 2018/Statistique descriptive/projet shiny/projet/globalterrorismdb_0718dist.csv")
  # 
  # terrorism<-terrorism[terrorism$iyear=="2015",]
  # colnames(terrorism)[9] <- "Country"
  # happiness$Country <- as.character(happiness$Country)
  # terrorism$Country<- as.character(terrorism$Country)
  # happiness <-happiness[which(!is.na(happiness$Country)),]
  # correction<-c("Congo (Brazzaville)"="Democratic Republic of the Congo","Congo (Kinshasa)"="Republic of Congo","United States"="USA","United Kingdom"= "UK")
  # for(i in names(correction)){
  #   happiness[happiness$Country==i,"Country"]<-correction[i]
  # }
  # q<-map_data("world")
  # colnames(q)[5] <- "Country"
  # df<- left_join(q,happiness)
  # Bombing<- terrorism[terrorism$attacktype1==3,]
  # target_citizen<- terrorism[terrorism$targsubtype1==75|terrorism$targsubtype1==67,] 
  
  target_citizen <- read.csv("target_citizen.csv")
  df <- read.csv("df.csv")
  happiness_quanti <- happiness %>% select_if(is.numeric)
  happiness_region <- which(names(happiness) == "Country")
  happiness_pca <- PCA(happiness_quanti, scale.unit = T, quali.sup = happiness_region, graph = F) 
  var <- get_pca_var(happiness_pca)
  # data <- eventReactive(input$click,{
  
  #   inFile <- input$table
  #   
  #   if(is.null(inFile)) return(NULL)
  #   
  #   read.csv(inFile$datapath, head=T)
  #   
  # 
  # })
  # 
  
  data1 <- eventReactive(input$maj,{
    happiness })
  
  
  output$print <- renderTable({head(data1(), n=isolate(input$n))})
  
  output$nuage <- renderPlot({
    ggplot(data = happiness, aes_string(input$x, input$y, colour=happiness$Region)) + 
      geom_point(show.legend = FALSE)+
      directlabels::geom_dl(aes(label=happiness$Region), method="smart.grid")
    
  })
  
  data2 <- reactive({
    
    data2 <- happiness
    data2$Region <- reorder(data2$Region, data2$Happiness.Score)
    data2$Pays <- reorder(data2$Country, data2$Happiness.Score)
    data2 %>% 
      filter(Region==input$Region_choix)
  })
  
  
  output$hapi <- renderPlot({
    
    ggplot(data = data2(), aes(x=Happiness.Score, y=Country, colour=Country))+
      geom_point(show.legend = F)+
      facet_grid(Region~., scales="free", space="free")+
      theme(strip.text.y = element_text(angle=0))
  })
  
  output$summary <- renderPrint({ summary(happiness[, input$xy])
  })
  
  
  output$histo <- 
    renderPlot({
      ggplot(data=happiness, aes(x=happiness[,input$xy])) + geom_histogram(bins=input$bins, aes(x = happiness[,input$xy], y=..density..))
    })
  
  output$box <-      renderPlot({
    ggplot(data=happiness, aes(y=happiness[,input$xy])) + geom_boxplot(aes(y=happiness[,input$xy]))
  })
  
  
  # base2 <- reactive({
  #   
  #   vars <- c("Happiness.Rank", "Standard.Error", "Dystopia.Residual")
  #   
  #   base2 <- happiness
  #   base2 %>% select(c(1,9,7,5,6,4,8,9,10,11,12))
  # })
  # 
  # baye <- reactive({
  #   
  #   
  #   baye <- gs(base2(), test = "mi-cg", alpha = 0.05, optimized = TRUE, debug = TRUE)
  # })
  # output$BN <- renderPlot({
  #   
  #   # graphviz.plot(baye(), highlight=list(nodes = c("Region", "Happiness.Score"), arcs = c("Region", "Happiness.Score"), col = "red", fill = "darkolivegreen3"), layout="neato", shape="ellipse",  main = "Visualisation des reseaux bayesiens")
  #  
  #    graphviz.plot(baye(), layout="neato", shape="ellipse",  main = "Visualisation des reseaux bayesiens")
  #   })
  
  output$Leaflet <- renderPlot({
    ggplot()  +
      geom_polygon( aes(x = df$long, y = df$lat, group = df$group,fill= df$Happiness.Score)) + 
      coord_equal() +scale_fill_gradient(breaks=c(3,5,7,9)) +
      geom_point(aes(target_citizen$longitude,target_citizen$latitude,shape="."))+
      ggtitle("Score de bien etre en fonction des attaques terroristes")+
      xlab("") + ylab("") + guides(shape=FALSE) + labs(fill="Score de bien etre")
  })
  
  output$val <- renderPlot({
    
    fviz_screeplot(happiness_pca, alpha = 0.5, addlabels = T, geom = "line") +
      geom_bar(stat = "identity", alpha = 0.2) +
      geom_point(color = "Orange") +
      geom_line(color = "Orange") +
      ggtitle("Part d'inertie conservee apres projection sur le nouvel espace")
  })
  
  
  corel <- reactive({
    
    corel <- cor(happiness[, -c(1,2)])
  })
  
  output$corplot <- renderPlot({
    corrplot(corel())
  })
  
  output$var <- renderPlot({
    fviz_cos2(happiness_pca, choice = "var", axes = 1:2)
    
    fviz_pca_var(happiness_pca, col.var = "cos2",
                 gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
                 repel = T
    )
    
    
  })
  
  output$contrib <- renderPlot({
    
    fviz_contrib(happiness_pca, choice = "var", axes = 1, top = 10)
  })
  
  output$contrib1 <- renderPlot({
    
    fviz_contrib(happiness_pca, choice = "var", axes = 2, top = 10)
  })
  
  
  my.cont.var <- rnorm (9)
  
  output$reprevar <- renderPlot({
    
    fviz_pca_var(happiness_pca, col.var = my.cont.var,
                 gradient.cols = c("blue", "yellow", "red"),
                 legend.title = "Cont.Var")
  })
  
  output$repreind <- renderPlot({
    
    
    fviz_contrib(happiness_pca, choice = "ind", axes = 1:2)
  })
  
  output$prplan <- renderPlot({
    fviz_pca_ind(happiness_pca,
                 geom.ind = "point",
                 col.ind = happiness$Region,
                 repel = T,
                 addEllipses = F,
                 legend.title = "Groups"
    )
  })
  
  
  
})