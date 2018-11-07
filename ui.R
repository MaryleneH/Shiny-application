library(shiny)
library(shinythemes)
library(htmlwidgets)
library(widgetframe)
rsconnect::setAccountInfo(name='cincinnatus', token='F99CE63B509CAA4358D0D6954FE91AB1', secret='4KB1yC1zTtAWlYOhVM8IlmGtiIAyDxcXDWmabL1V')

shinyUI(fluidPage(
  
  titlePanel("Etude de la base de donnees happiness"),
  h6('Mohamed Haidara'),
  h6("'Le bonheur est un papillon qui, poursuivi, ne se laisse jamais attraper mais qui, si vous savez vous asseoir sans bouger, viendra peut-etre un jour se poser sur votre epaule.' Nathaniel Hawthorne "),
  theme = shinytheme("slate"),
  
  # sidebarLayout(
  
  # sidebarPanel(
  # 
  # fileInput("table", "Importation de la table", accept = c("text/plain", "text/csv", ".csv"), multiple = F, 
  #           buttonLabel="Table chargee", placeholder="Pas de fichier importe"),
  # fluidRow(
  #   column(2,
  #          
  #          actionButton(inputId="click", label="charger")),
  #   
  #   column(6, offset = 2,
  #          tableOutput(outputId="contenu"))
  #   
  # )
  # 
  # 
  #   
  # ),
  
  mainPanel(
    
    tabsetPanel(
      tabPanel("En-tete de la table",
               
               numericInput("n", "nombre d'observations", 10),
               helpText("La base de donnees Happiness est une base de donnees mondiale sur le bonheur."),
               helpText("C'est une archive web des resultats de recherche sur l'appreciation subjective de la vie."),
               helpText("Elle contient 12 variables et 158 observations (Chaque observation represente un pays)"),
               
               actionButton("maj", "visualisation des donnees"),
               tableOutput(outputId="print")),
      
      tabPanel("Objet de l'etude",
               
               helpText("Cette etude a pour objectif de determiner la nature du bonheur."),
               helpText("Elle part de l'intention de verifier le paradoxe d'Easterlin selon lequel l'argent ne fait pas le bonheur."),
               helpText("Dans un cadre plus large, nous allons essayer de determiner la nature du bonheur en etudiant principalement le score de bonheur attribue a chaque pays")),
      
      tabPanel("Visualisation",
               selectInput(inputId="x", label="selection de X", 
                           choices= c("Happiness.Rank", "Happiness.Score", "Economy..GDP.per.Capita.", "Family",
                                      "Health..Life.Expectancy.", "Freedom", "Trust..Government.Corruption.", "Generosity",
                                      "Dystopia.Residual")),
               
               selectInput(inputId="y", label="selection de Y", 
                           choices= c("Happiness.Rank", "Happiness.Score", "Economy..GDP.per.Capita.", "Family",
                                      "Health..Life.Expectancy.", "Freedom", "Trust..Government.Corruption.", "Generosity",
                                      "Dystopia.Residual")),
               plotOutput("nuage"),
               
               helpText("Le score de bonheur est relativement eleve dans les pays d'Europe de l'est et de l'Amerique du nord."),
               helpText("La moyenne du score de bonheur est de 7 dans les pays issus de ces continents."), 
               helpText("Le score de bonheur minimum (3) est atteint par les pays d'Afrique Subsaharienne."),
               helpText("Le score de bonheur globale est croissant avec le PIB par tete. Cependant, cette evolution diverge entre les continents."),
               helpText("Les scores de bonheur des continents Afrique Subsaharienne et Amerique latine-caraibe stagne avec la hausse du PIB."),
               helpText("Le score de bonheur croit avec l'esperance de vie quelque soit le continent considere")),
      
      
      tabPanel("Rapport happiness",
               
               selectInput(inputId="Region_choix", label="selection de la region", 
                           choices= c("Australia and New Zealand", "Central and Eastern Europe",
                                      "Eastern Asia", "Latin America and Caribbean",
                                      "Middle East and Northern Africa", "North America",
                                      "Southeastern Asia", "Southern Asia", "Sub-Saharan Africa", "Western Europe")),
               
               plotOutput("hapi")
               
               
      ),
      
      tabPanel("Statistiques",
               
               selectInput(inputId="xy", label="selection de la var", 
                           choices= c("Happiness.Score", "Economy..GDP.per.Capita.", "Family",
                                      "Health..Life.Expectancy.", "Freedom", "Trust..Government.Corruption.", "Generosity",
                                      "Dystopia.Residual")),
               
               navlistPanel(
                 
                 tabPanel("sommaire",
                          
                          verbatimTextOutput("summary"),
                          
                          helpText("Le score de bonheur moyen est de 5.376 sur l'ensemble des observations. Le maximum s'eleve a 7.59, tandis que le minimum atteint 2.84")),
                 
                 tabPanel("Histogramme",
                          
                          sliderInput(inputId="bins", label="Nb de bins", min=1, max=50, value=40),
                          plotOutput("histo")),
                 
                 tabPanel("Boxplot",
                          
                          plotOutput("box"))
               )
      ),
      
      tabPanel("Analyse de donnees",
               navlistPanel(
                 
                 
                 tabPanel("Representation des valeurs propres",
                          
                          plotOutput("val"),
                          
                          helpText("Les valeurs propres mesurent l'inertie (la variance expliquee) de chaque axe principal. Ils servent a determiner le nomnbre de composantes principales a prendre en consideration. Cependant, il n'existe pas de methode unique pour determiner le nombre d'axes principaux a retenir."),
                          helpText("Dans notre cas, les trois premiers axes principaux expliquent 71.3% de l'inertie totale. Cela semble acceptable.")),
                 
                 tabPanel("Matrice de correlations",
                          
                          plotOutput("corplot"),
                          
                          helpText("Le score de bonheur est positivement correle au PIB par tete, de quoi remttre - partiellement - en question le paradoxe d'Easterlin."),
                          helpText("L'esperance de vie et la liberte sont egalement correles positivement au score de bonheur.")),
                 
                 tabPanel("Qualite de representation",
                          
                          plotOutput("var"),
                          
                          helpText("La qualite de representation est determinee par le cos2."),
                          helpText("Une cos2 eleve indique une bonne representation de la variable sur les axes principaux en consideration."),
                          helpText("Dans ce cas, la variable est positionnee a proximitee de la circonference du cercle de correlation."),
                          helpText("Un faible cos2 indique que la variable n'est pas parfaitement representee par les axes principaux.Dans ce cas, la variables est proche du centre du cercle.")),
                 
                 tabPanel("contribution des variables a la formation de l'axe",
                          
                          fluidRow(column(7,
                                          
                                          plotOutput("contrib"))),
                          
                          fluidRow(column(7,
                                          
                                          plotOutput("contrib1"))),
                          
                          helpText("La ligne pointillee rouge, sur les graphiques, indique la contribution moyenne attendue.
                                   Dans le cas ou la contribution des variables serait uniforme, la valeur attendue serait 1/length(variables) = 10%.
                                   Une contribution superieure au seuil signifie que la contribution de la variable est relativement importante a la composante."),
                          helpText("Dans notre cas, le score de bonheur, le PIB par tete, l'esperance de vie et la liberte d'expression contribuent a l'apparition de l'axe 1.
                                   La generosite, la dystopie et la capacite du gouvernement a lutter contre la corruption contribuent a l'apparition de l'axe 2.")),
                 
                 tabPanel("Representation des var",
                          
                          plotOutput("reprevar"),
                          helpText("Les variables sont colorees")),
                 
                 tabPanel("Contribution des individus a la formation des axes",
                          
                          plotOutput("repreind"),
                          helpText("Il est impossible de distinguer les individus.")),
                 
                 tabPanel("premier plan facoriel",
                          plotOutput("prplan"))
                          )),
      
      # 
      # tabPanel("Test de causalite Reseaux Bayesien",
      #          
      #          plotOutput("BN")),
      
      tabPanel("Carte de chaleur",
               
               plotOutput("Leaflet"),
               helpText("Les points sur la carte correspondent aux attaques terroristes. Chanque point correspond a une attaque terroriste"),
               helpText("Les pays qui ont subi des attaques racistes ont des scores de bien etre plus faibles que ceux des pays qui n'en ont pas eu."),
               helpText("Mais cela etant, cela ne veut pas dire que les attaques jouent sur le bien etre. Mais on peut penser que les pays pauvres sont victimes d'attaques terroristes jouent sur le bien etre."),
               helpText("Mais on peut penser que les pays pauvres sont victimes d'attaques terroristes, et qu'en meme temps les pays qui ont PIB par tete est faible ont le score de bien etre faible.")),
      
      tabPanel("Conclusion",
               
               h4("Analyse des resultats"),
               
               helpText("Cette etude nous a permis d'etablir une relation lineaire entre le score de bonheur (subjectif) et le PIB par tete, meme si elle ne nous permet pas d'affirmer le sens de la relation"),
               helpText("Nous pouvons egalement affirmer que les pays qui ont ete touches par le terrorisme ont un score de bonheur inferieur a ceux des pays qui n'ont pas ete affectes par le terrorisme"),
               helpText("Les resultats de l'analyse en composante principale ne nous permettent pas de conclure quand aux facteurs qui influencent le score de bonheur au sein d'un pays."),
               helpText("On peut constater que la liberte d'expression et le PIB par tete influencent le score de bonheur.")),
      
      tabPanel("Fin en musique",
               
               h4("La musique adoucit les moeurs, alors let's-go"),
               tags$video(src="pw1.mp4", type="video/mp4", width="600px", height="400px", controls="controls"))
        )
    
    
    # )
)


  )
  )