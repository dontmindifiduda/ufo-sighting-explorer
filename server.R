# Load Libraries
library(shiny)
library(dplyr)

# Read & Clean Data
ufo <- read.csv('scrubbed.csv')

ufo$datetime <- as.character(ufo$datetime)
ufo$datetime <- sapply(ufo$datetime, function(x) {return(strsplit(x, split=" ")[[1]][1])})
ufo$datetime <- as.Date(ufo$datetime, '%m/%d/%Y')

ufo$year <- as.numeric(format(ufo$datetime, '%Y'))

ufo$city <- as.character(ufo$city)

ufo <- mutate_at(ufo, vars(city), funs(toupper))
ufo <- select(ufo, -c('duration..seconds.', 'latitude', 'longitude'))

ufo <- ufo[!(is.na(ufo$state) | ufo$state == ""), ]
ufo <- ufo[!(is.na(ufo$country) | ufo$country != "us"), ]

ufo$shape <- toupper(as.character(ufo$shape))
ufo$shape[as.character(ufo$shape) == ""] <- "NOT REPORTED"
ufo_shapes <- sort(unique(ufo$shape))

ufo$state <- as.factor(toupper(as.character(ufo$state)))
ufo_states <- sort(unique(ufo$state))

# HTML Number Character Substitutions

ufo$comments <- sapply(ufo$comments, function(x) {return(gsub("&#44", ",", x))})
ufo$city  <- sapply(ufo$city, function(x) {return(gsub("&#44", ",", x))})
ufo$duration..hours.min.  <- sapply(ufo$duration..hours.min., function(x) {return(gsub("&#44", ",", x))})

ufo$comments <- sapply(ufo$comments, function(x) {return(gsub("&#39", "'", x))})
ufo$city  <- sapply(ufo$city, function(x) {return(gsub("&#39", "'", x))})
ufo$duration..hours.min.  <- sapply(ufo$duration..hours.min., function(x) {return(gsub("&#39", "'", x))})

ufo$comments <- sapply(ufo$comments, function(x) {return(gsub("&#8216;", "'", x))})
ufo$comments <- sapply(ufo$comments, function(x) {return(gsub("&#8217;", "'", x))})
ufo$comments <- sapply(ufo$comments, function(x) {return(gsub("&#33", "!", x))})
ufo$comments <- sapply(ufo$comments, function(x) {return(gsub("&quot;", "\"", x))})
ufo$comments <- sapply(ufo$comments, function(x) {return(gsub("&#176;", "°", x))})
ufo$comments <- sapply(ufo$comments, function(x) {return(gsub("&#160;", " ", x))})
ufo$comments <- sapply(ufo$comments, function(x) {return(gsub("&#8220;", "\"", x))})
ufo$comments <- sapply(ufo$comments, function(x) {return(gsub("&#8221;", "\"", x))})
ufo$comments <- sapply(ufo$comments, function(x) {return(gsub("&#8230;", "...", x))})
ufo$comments <- sapply(ufo$comments, function(x) {return(gsub("&#9;", "", x))})
ufo$comments <- sapply(ufo$comments, function(x) {return(gsub("&#8211;", "-", x))})
ufo$comments <- sapply(ufo$comments, function(x) {return(gsub("&#8212;", "—", x))})
ufo$comments <- sapply(ufo$comments, function(x) {return(gsub("&#186;", "º", x))})
ufo$comments <- sapply(ufo$comments, function(x) {return(gsub("&amp;", "&", x))})
ufo$comments <- sapply(ufo$comments, function(x) {return(gsub("&#188;", "¼", x))})
ufo$comments <- sapply(ufo$comments, function(x) {return(gsub("&#8226;", "•", x))})

# Set Up Map Formatting

borders <- list(color=toRGB('black'))

map_options <- list(
    scope = 'usa',
    projection = list(type = 'albers usa'),
    showlakes = TRUE,
    lakecolor = toRGB('blue')
)

# Server

shinyServer(function(input, output, session) {

    # UFO Shape Selector Checkboxes
    
    output$shapeControls <- renderUI({
        if(1) {
            checkboxGroupInput('ufo_shapes', 'UFO Shape', ufo_shapes, selected=ufo_shapes)
        }
    })
    
    # State Selector Checkboxes
    
    output$stateControls <- renderUI({
        if(1) {
            checkboxGroupInput('ufo_states', 'State', ufo_states, selected=ufo_states)
        }
    })

    
    
    observe({
        if(input$allShapes == 0) {return(NULL)}
        else if (input$allShapes %% 2 == 0)
        {
            updateCheckboxGroupInput(session, 'ufo_shapes', selected=ufo_shapes)
        }
        else
        {
            updateCheckboxGroupInput(session, 'ufo_shapes', selected="")
        }
    })
    
    observe({
        if(input$allStates == 0) {return(NULL)}
        else if (input$allStates %% 2 == 0)
        {
            updateCheckboxGroupInput(session, 'ufo_states', selected=ufo_states)
        }
        else
        {
            updateCheckboxGroupInput(session, 'ufo_states', selected="")
        }
    })
        
    state_ufo <- reactive({
        temp <- as.data.frame(table(filter(ufo, ((year >= input$year_range[1] & year <= input$year_range[2]) & shape %in% input$ufo_shapes) & state %in% input$ufo_states)$state))
        names(temp) <- c('State', 'Sitings')
        temp$State <- as.character(temp$State)
        temp <- data.frame(sapply(temp, function(n) {
            if (is.character(n)) return (toupper(n))
            else return(n)
        }))
        temp$State <- as.factor(temp$State)
        temp$Sitings <- as.numeric(as.character(temp$Sitings))
        
        temp
    }) 
    

    
    output$ufomap <- renderPlotly({
    
        df <- state_ufo()
        plot_ly(data=df, z = df$Sitings, locations = df$State, type = 'choropleth', 
              locationmode = 'USA-states', color = df$Sitings, colors = "YlOrRd", marker = list(line = borders)) %>%
        layout(title = "Number of UFO Sightings by State", geo = map_options)
    })
    
    ufo_table <- reactive({
        ufo_display <- filter(ufo, ((year >= input$year_range[1] & year <= input$year_range[2]) & shape %in% input$ufo_shapes) & state %in% input$ufo_states)
        ufo_display <- select(ufo_display, c('datetime', 'city', 'state', 'shape', 'duration..hours.min.', 'comments', 'date.posted'))
        names(ufo_display) <- c("Date & Time", "City", "State", "UFO Shape", "Sighting Duration", "Description", "Date Reported")
        ufo_display
    })
    
    
    output$ufotable <- renderDataTable({
        ufo_table()
    })
    
  
})
