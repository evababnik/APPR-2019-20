library(shiny)

shinyServer(function(input, output) {
  output$druzine <- DT::renderDataTable({
    druzine %>% spread(key="velikost.druzine", value="stevilo.druzin") %>%
      rename(`Občina`=obcina)
  })
  
  output$pokrajine <- renderUI(
    selectInput("pokrajina", label="Izberi pokrajino",
                choices=c("Vse", levels(obcine$pokrajina)))
  )
  output$naselja <- renderPlot({
    main <- "Pogostost števila naselij"
    if (!is.null(input$pokrajina) && input$pokrajina %in% levels(obcine$pokrajina)) {
      t <- obcine %>% filter(pokrajina == input$pokrajina)
      main <- paste(main, "v regiji", input$pokrajina)
    } else {
      t <- obcine
    }
    ggplot(t, aes(x=naselja)) + geom_histogram() +
      ggtitle(main) + xlab("Število naselij") + ylab("Število občin")
  })
})
library(shiny)

function(input, output) {
  
  output$zemljevid.leto <- renderPlot({
    zemljevid.leto(input$leto) + theme(axis.text.x = element_blank())
  })
}
