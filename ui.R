library(shinydashboard)
library(ggplot2)
library(dplyr)
library(chron)
library(readr)
library(plotly)
library(readxl)
library(DT)
library(V8)

TabelkaBI <- read_excel("j:\\Desktop\\Projekt\\TabelkaBI.xlsx")

TabelkaBI <- TabelkaBI[,-1]

dashboardPage(
  dashboardHeader(title = "Analysis"),
  dashboardSidebar(sidebarMenu(
    menuItem("Liczebnosc", tabName = "Licz", icon = icon("licz")),
    menuItem("Summary", tabName = "Summ", icon = icon("summ")),
    menuItem("PCA", tabName = "PCA", icon = icon("PCA")),
    menuItem("MFPCA", tabName = "MFPCA", icon = icon("MFPCA"))
  )),
  dashboardBody(
    tabItems(
      tabItem(tabName = "Licz",
              fluidRow(
                box(plotlyOutput("plot1"),
                    selectInput(inputId = "var", 
                                label = strong("Demographic feature"),
                                choices = names(TabelkaBI[2:6]),
                                selected = "Preworking"),
                    selectInput(inputId = "var2", 
                                label = strong("Year"),
                                choices = unique(TabelkaBI[,7]),
                                selected = "2008"),width = 600))
              ),
      tabItem(tabName = "Summ",
              fluidRow(
                box(plotlyOutput("plot2"),
                    selectInput(inputId = "var3",
                                label = strong("Province"),
                                choices = unique(TabelkaBI[,1]),
                                selected = "DOLNOŚLĄSKIE"),
                    selectInput(inputId = "var4", 
                                label = strong("Demographic feature"),
                                choices = names(TabelkaBI[2:6]),
                                selected = "Preworking"),width = 600),
                box(dataTableOutput("datatable"), width = 600)
              )
              ),
      tabItem(tabName = "PCA",
              fluidRow(
                box(selectInput(inputId = "var5",
                                label = strong("Year"),
                                choices = unique(TabelkaBI[,7]),
                                selected = "2008"),width = 600)),
                box(plotlyOutput("plot3", height = 600), width = 600, height = 650),
                box(verbatimTextOutput("summar"))
              ),
      tabItem(tabName = "MFPCA",
              fluidRow(imageOutput("image")))
    )
)
)
