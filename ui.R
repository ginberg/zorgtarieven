## Server.R ##
source("global.R")

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
  ),
  # Application title
  h1("Behoorlijke verschillen in kosten per behandeling per ziekenhuis"),
  br(),
  h5("Wat kost een bezoek aan de specialist eigenlijk? En hoeveel betaalt u voor een operatie aan neus- of keelamandelen?
     Veel mensen weten niet wat de prijs is van een behandeling. CZ geeft meer inzicht door het vrijgeven van deze ",
     a("data (augustus 2016)", href="https://www.cz.nl/over-cz/inkoop-van-zorg/wat-kost-uw-behandeling-in-het-ziekenhuis", target="_blank")),

  fluidRow(
    column(1),
    column(7, uiOutput("selectOmschrijving")),
    column(4, uiOutput("sliderNaam"))
  ),
  # Sidebar with a slider input for number of bins
  fluidRow(
    column(1),
    column(10,
           plotlyOutput("plot", height = 800)
    )
  ),
  tags$hr(),
  h5("Bekijk en doorzoek de dataset"),
  fluidRow(
    column(1),
    column(10,
           dataTableOutput("details")
    )
  )
))
