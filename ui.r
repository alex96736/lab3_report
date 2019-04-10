library('shiny')       # загрузка пакетов
library('data.table')

df <- data.table(read.csv('data_movies_2018.csv', 
                          stringsAsFactors = F))

# размещение всех объектов на странице
shinyUI(
    pageWithSidebar(
        # название приложения:
        headerPanel('Бюджет фильмов за 2018 год на портале kinopoisk'),
        # боковая панель:
        sidebarPanel(                           # шаг
            # выпадающий список: переменная по оси 0Y
            selectInput('Y.var',    # переменная
                        'Переменная Y',
                        # список:
                        list('Бюджет фильма' = 'Cost'),
                        selected = 'Cost'),
            # выпадающий список: переменная по оси 0X 
            selectInput('X.var',    # переменная
                        'Переменная X',
                        # список:
                        list('Оценка фильма на IMDb' = 'IMDb.mark'),
                        selected = 'IMDb.mark'),
            sliderInput('Time.range', 'Продолжительность:',
                        min = 84, max = 164, value = c(84, 164))
        ),
        # главная область
        mainPanel(
          # график разброса переменных
          plotOutput('gplot'),
          # описательные статистики
          verbatimTextOutput('XY.summary'),
          # модель
          verbatimTextOutput('lm.result')
            )
        )
    )