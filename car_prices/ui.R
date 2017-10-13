#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)

load("data/cars_table.Rda")

docString = "</br>
This app predicts car prices in Moscow Region, Russia as of Aug. 2017,
using  their brand, mileage, year of issue and several other parameters  
as predictors. </br></br>

The data are taken from the real Russian website. </br></br>

The output is divided into three tabs.  On the first tab, named 'Results', you can see
info about the brand you have selected, estimated price of the car with the given
characteristic and a scatterplot, that represents dependency between the year of issue
and the price for the brand. The second tab, 'Price Distribution', as its name suggests,
contains the price distribution for the given brand. Finally, the last tab, 'Help'
is the one you are reading now.</br></br>

I hope, you will like my app, so have fun!
</br>"

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Car prices in Moscow Reg. (Russia), aug. 2017"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       selectInput("brand", 
                   "Brand: ", 
                   unique(carsTbl$brand)),
       sliderInput("hp",
                    "Gross horsepower: ",
                    min=10,
                    max=1000,
                    step=1,
                    value = 150),
       sliderInput("disp",
                   "Displacement, liters: ",
                   min = 0,
                   max = 10,
                   step = 0.05,
                   value = 5),
      numericInput("mileage",
                   "Mileage, km:" ,
                   min = 0,
                   max = 10000000,
                   value = 50000),
      selectInput("year",
                   "Year of Issue: ",
                    c(1990:2017),
                  selected = 2007),
      radioButtons("trans",
                   "Transmission:",
                   c("AT" = "AT",
                     "MT" = "MT",
                     "MTA"= "MTA",
                     "CVT" = "CVT")),
      radioButtons("driveType",
                   "Drive type:",
                   c("Front wheel" = "передний",
                     "Rear wheel" = "задний",
                     "Four wheel" = "полный")),
      radioButtons("fuelType", 
                   "Fuel type:",
                   c("Petrol" = "petrol",
                     "Diesel" = "diesel",
                     "Turbo-diesel" = "turbo_diesel",
                     "Gas" = "gas",
                     "Hybrid" = "hybrid"))
                   
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       tabsetPanel(
         tabPanel("Result",
           HTML('</br>'),        
           textOutput("avgPrice"),
           textOutput("myPrice"),
           plotlyOutput("yearPriceScatterPlot")
         ),
         tabPanel("Price Distribution",
           plotlyOutput("brandPriceDistrib")
         ),
         tabPanel("Help",
           HTML(docString) 
         )
       )
    )
  )
))