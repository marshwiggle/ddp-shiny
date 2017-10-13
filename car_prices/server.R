#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(plotly)

load("data/cars_table.Rda")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  
  model <- reactive({ 
    glm(price ~  brand + mileage + year + hp + disp + trans + driveType +
        + fuelType, family = poisson(), data = carsTbl)
    #lm(price ~  brand + mileage + year + hp + disp + fuelType, data = carsTbl)
  })
  
  
  res <- reactive({
    
    pred <-predict(model(), 
            data.frame(brand = input$brand,
                       mileage = as.numeric(input$mileage), 
                       year = as.numeric(input$year),
                       hp = as.numeric(input$hp),
                       disp = as.numeric(input$disp),
                       trans = input$trans,
                       driveType = input$driveType,
                       fuelType = input$fuelType))
    exp(pred)
  })
  
  
 brandTbl <- reactive({
   filter(carsTbl, brand == input$brand)
 })
   
 output$avgPrice <- renderText({
     avgPrice <- round(mean(brandTbl()$price))
     paste("Average Price on ", input$brand, ": ", avgPrice, " Russian Roubles")
  })
  
  output$myPrice <- renderText({
     price <- res() 
     paste("Estimated Price: ", round(price, 0), " Russian Roubles")
  })
   
  output$yearPriceScatterPlot <- renderPlotly({
    plot_ly(brandTbl(), x = ~year,  y = ~price, 
            marker = list(size = 10, 
                          color='rgba(194, 43, 194, 0.3)')) %>% 
      layout( yaxis = list(type = "log"))
  })
  
  output$brandPriceDistrib <- renderPlotly({
    plot_ly(brandTbl(), x = ~price, type="histogram", xbins=10) 
  })
  
  
})