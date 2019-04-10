library('shiny')       # загрузка пакетов
library('ggplot2')
library('dplyr')
library('data.table')

shinyServer(function(input, output) {
  # реагирующий фрейм с данными
  DT <- reactive({
    DT <- data.table(read.csv('data_movies_2018.csv', 
                              stringsAsFactors = F))
    select(DT[between(Time, input$Time.range[1],
                      input$Time.range[2]), ],
           input$Y.var, input$X.var)
  })
  # график разброса с линией регрессии
  output$gplot <- renderPlot({
    gp <- ggplot(data = DT(), aes_string(x = input$X.var,
                                         y = input$Y.var))
    gp <- gp + geom_point() + geom_smooth(method = 'lm')
    gp
  })
  # таблица с описательными статистиками
  output$XY.summary <- renderPrint({
    summary(DT())
  })
  # отчёт по модели регрессии
  output$lm.result <- renderPrint({
    eq <- as.formula(paste(input$Y.var, ' ~ ', input$X.var))
    mod <- lm(eq, data = DT())
    summary(mod)
  })
})
