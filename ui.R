library(shiny)
library(plotly)


column_setup <- 
    list(tags$head(tags$style(HTML("
                                   .column_setup { 
                                   height: 500px;
                                   -webkit-column-count: 3; 
                                   -moz-column-count: 3;    
                                   column-count: 3; 
                                   -moz-column-fill: auto;
                                   -column-fill: auto;
                                    border: solid black 2px;
                                    padding: 10px
                                   } 
                                   ")) 
    ))

shinyUI(fluidPage(
    
  column_setup,
    
  titlePanel("UFO Sighting Explorer"),
  
  tabsetPanel(
      tabPanel("Map", plotlyOutput("ufomap")),
      tabPanel("Sighting Descriptions", dataTableOutput("ufotable"))
  ), 
  
  fluidRow(
      column(4,
        h3("Select Date Range:"),
        sliderInput("year_range", "Range of Years: ", min = 1949, max = 2013, value = c(1949,2013), sep="")
        ),
      
      column(4,
        h3("Select UFO Shapes:"),
        tags$div(align='left',
                 class='column_setup',
                 uiOutput("shapeControls"),
                 actionLink("allShapes", "ALL / NONE")
                 )
             
      ),
      
      column(4,
        h3("Select States:"),
        tags$div(align='left',
                 class='column_setup',
                 uiOutput("stateControls"),
                 actionLink("allStates", "ALL / NONE")
                 )
              
      )
      
      
  )
  

))
