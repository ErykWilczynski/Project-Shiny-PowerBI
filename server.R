library(shinydashboard)
library(ggplot2)
library(dplyr)
library(chron)
library(readr)
library(plotly)
library(readxl)
library(DT)

TabelkaBI <- read_excel("j:\\Desktop\\Projekt\\TabelkaBI.xlsx")

TabelkaBI <- TabelkaBI[,-1]

shinyServer(function(input, output) {
  
  Data <- reactive({ TabelkaBI %>%
    filter(Rok == input$var2) %>%
      select(1,input$var) %>%
      as.data.frame()
  })
  
  Data2 <- reactive({
    TabelkaBI %>%
      filter(Województwa == input$var3) %>%
      select(1,input$var4,7) %>%
      as.data.frame()
  })
  
  Data3 <- reactive({
    TabelkaBI %>%
      filter(Województwa == input$var3) %>%
      as.data.frame()
  })
  
  output$plot1 <- renderPlotly({
    y <- list(
      title = "Provinces"
    )
    x <- list(
      title = "Population"
    )
      plot_ly(y = ~Data()$Województwa, x = ~Data()[,2], name = input$var, type = 'bar', orientation = 'h') %>%
      layout(xaxis = x, yaxis = y)
  })
  
  output$plot2 <- renderPlotly({
    y <- list(
      title = "Province"
    )
    x <- list(
      title = "Population"
    )
    plot_ly(y = ~Data2()$Województwa, x = ~Data2()[,2], name = input$var4, type = 'box', orientation = 'h') %>%
      layout(xaxis = x, yaxis = y)
  })

  output$datatable <- renderDataTable({
    Data3()
  })
  
  X <- reactive({
    c <- TabelkaBI %>%
    filter(Rok == input$var5)
    model <- prcomp(c[,2:6],scale = T)
    model
  })

  Woj <- TabelkaBI %>%
    select(1) %>%
    unique() %>%
    as.data.frame()
  
  output$plot3 <- renderPlotly({
    x <- list(
      title = paste0('PC1 (', 100* summary(X())$importance[2],'%)')
    )
    y <- list(
      title = paste0('PC2 (', 100 *summary(X())$importance[5], '%)')
    )
    plot_ly(x = ~X()$x[,1], y = ~X()$x[,2], name = paste0('Rok ',input$var5), type = 'scatter',
            mode = 'text', text = ~Woj[,1]) %>%
      layout(xaxis = x, yaxis = y, title = paste0('Rok ', input$var5))
  })
  
  output$summar <- renderPrint({
    summary(X())
    })
  
  output$image <- renderImage({
    filename <- normalizePath('J:\\Desktop\\Projekt\\MFPCA.png')
    list(src = filename)
  }, deleteFile = FALSE)
}
)