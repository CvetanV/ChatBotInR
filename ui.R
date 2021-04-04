#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyWidgets)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel(
        h2(strong("ChatBot"), align = "center", style = "color: Green")
    ),
    
    setBackgroundColor(
        color = c("#F7FBFF", "#2171B5"),
        gradient = "linear",
        direction = "bottom"
    ),
    
    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            h4("How to use this application:"),
            helpText("This application works by writting a question in the text box and after clicking on the Ask button. Based on this input the chatbot will give the searched answer."),
        ),

        # Show a plot of the generated distribution
        mainPanel(
            
            h3(strong("Your input:"), style = "color: Green"),
            textInput("inputText", label = "",value = "", width = 550, placeholder = "Write your question here!"),
           
            actionButton("go", "Ask", width = 550, align = "center", style = "color: White; background-color: Green" ),
            br(),
            br(),
            br(),
            br(),
            h3(strong("Chatbot response:"), style = "color: Green"),

            h4(code(textOutput('outcome'), style="color:brown", width = 550)),
        )
    )
))
