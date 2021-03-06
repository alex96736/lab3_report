library('shiny')       # загрузка пакетов
library('lattice')
library('plyr')

file.URL <- 'https://raw.githubusercontent.com/alex96736/lab3_report/master/Films-imdb2017.csv'
download.file(file.URL, destfile = 'Films-imdb2017.csv')

df <- data.table(read.csv('Films-imdb2017.csv', 
                          stringsAsFactors = F))

shinyServer(function(input, output) {
    # текст для отображения на главной панели
    output$gn.text <- renderText({
        paste0('Вы выбрали жанр: ', 
               input$gn.to.plot # переменная, связанная со списком возраста
               )})
    output$gn.text1 <- renderText({
      paste0('Вы выбрали оценку с ', 
             input$Rating.range[1], ' по ', input$Rating.range[2]
             )
    })
    output$gn.text2 <- renderText({
      paste0('Вы выбрали кол-во голосов с ',
             input$Votes.range[1], ' по ', input$Votes.range[2]
             )
    })
    output$gn.text3 <- renderText({
      paste0('Всего фильмов - ', nrow(df)
      )
    })
    # строим гистограммы переменных
    output$gn.hist <- renderPlot({
        # сначала фильтруем данные
        DF <- df[df$Genre == input$gn.to.plot, 1:8]
        DF <- DF[between(DF$Rating, input$Rating.range[1], input$Rating.range[2])]
        DF <- DF[between(DF$Votes, input$Votes.range[1], input$Votes.range[2])]
        
    output$gn.text4 <- renderText({
      paste0('Отобранных фильмов - ', nrow(DF)
             )
      })

        # затем строим график
        histogram( ~ Gross_Earning_in_Mil, 
                   data = DF,
                   xlab = '',
                  breaks = seq(min(DF$Gross_Earning_in_Mil), max(DF$Gross_Earning_in_Mil), 
                               length = input$int.hist + 1)
                   )
    })
})
