## Server.R ##
source("global.R")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # selecbox omschrijving
  output$selectOmschrijving <- renderUI({
    selectInput("selectOmschrijving", "Selecteer behandeling", omschrijving_list, selected =  default_omschrijving, width = "100%")
  })
  
  #datainput
  dataOmschrijving<- reactive({
    #Adjust data based on prod
    df <- prices[prices$omschrijving == input$selectOmschrijving,]
    df <- df[!is.na(df$tarief),]
    df <- df[order(df$tarief, decreasing = TRUE),]
    return(df)
  })
  
  #slider
  output$sliderLength <- renderUI({
    df = dataOmschrijving()
    sliderInput("sliderLength", "Selecteer aantal behandelaars", min=1, max=length(df$naam), value=length(df$naam), step=1)
  })
  
  dataInput<- reactive({
    #Adjust data based on prod
    df <- dataOmschrijving()
    length <- input$sliderLength
    if(is.null(length)){
      return(df)
    } else{
      limit <- nrow(df) - length + 1
      if(limit >=0){
        df <- df[limit:nrow(df),]
        return(df)
      } else{
        return(df)
      }
    }
  })
  
  output$plot <- renderPlotly({
    df <- dataInput()
    p <- plot_ly(df, x = tarief, y = naam, colors = colors, showlegend = TRUE, type = "bar", orientation = 'h') %>%
      layout(
        margin = m,
        xaxis = list(title = "Tarief [euro]"),
        yaxis = list(title = ""),
        title='Kosten per behandelaar in prijs oplopend'
      )
    
    # Get the list for the plot
    pp <- plotly_build(p)
    # Pick up the hover text
    # for(i in 1:5){
    #   hvrtext <- pp$data[[i]]$text
    #   # Split by line break and wt
    #   hvrtext_fixed <- strsplit(hvrtext, split = '<br>pop')
    #   # Get the first element of each split
    #   hvrtext_fixed <- lapply(hvrtext_fixed, function(x) x[1])
    #   # Convert back to vector
    #   hvrtext_fixed <- as.character(hvrtext_fixed)
    #   # Assign as hovertext in the plot 
    #   pp$data[[i]]$text <- hvrtext_fixed
    # }
    pp
  })

  output$plotcheap <- renderPlotly({
    length <- nrow(price_diff)
    df <- price_diff[(length-20):length,]
    p <- plot_ly(df, x = diff_tarief, y = naam, colors = colors, showlegend = TRUE, type = "bar", orientation = 'h') %>%
      layout(
        margin = m,
        xaxis = list(title = "Afwijking ten opzichte van gemiddeld tarief [euro]"),
        yaxis = list(title = ""),
        title='Behandelcentra met gemiddeld goedkoop tarief'
      )
    plotly_build(p)
  })
  
  output$plotexp <- renderPlotly({
    length <- nrow(price_diff)
    df <- price_diff[1:20,]
    df <- df[order(df$diff_tarief, decreasing = TRUE),]
    p <- plot_ly(df, x = diff_tarief, y = naam, colors = colors, showlegend = TRUE, type = "bar", orientation = 'h') %>%
      layout(
        margin = m,
        xaxis = list(title = "Afwijking ten opzichte van gemiddeld tarief [euro]"),
        yaxis = list(title = ""),
        title='Behandelcentra met gemiddeld duur tarief'
      )
    plotly_build(p)
  })
  
  output$details <- DT::renderDataTable({
    df <- prices
    rownames(df) <- NULL
    DT::datatable(df, options = list(paging = TRUE, searching = TRUE, info = FALSE, pageLength = 10))
  })
  
})
