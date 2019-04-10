library('shiny')       # загрузка пакетов
library('data.table')

file.URL <- 'https://raw.githubusercontent.com/alex96736/lab3_report/master/Films-imdb2017.csv'
download.file(file.URL, destfile = 'Films-imdb2017.csv')

df <- data.table(read.csv('Films-imdb2017.csv', 
                          stringsAsFactors = F))

# список уникальных значений столбца Жанр
gn.filter <- as.character(unique(df$Genre))
names(gn.filter) <- gn.filter
gn.filter <- as.list(gn.filter)

# размещение всех объектов на странице
shinyUI(
    # создать страницу с боковой панелью
    # и главной областью для отчётов
    pageWithSidebar(
        # название приложения:
        headerPanel('Кассовые сборы фильмов за 2017 год на портале IMDB'),
        # боковая панель:
        sidebarPanel(
            selectInput(               # выпадающее меню: возраст
                'gn.to.plot',          # связанная переменная
                        'Выберите жанр',  # подпись списка
                        gn.filter),            # сам список
            
            sliderInput('Rating.range', 'Оценка:',
                        min = min(df$Rating), max = max(df$Rating), value = c(min(df$Rating), max(df$Rating))),
            
            sliderInput('Votes.range', 'Кол-во голосов:',
                        min = min(df$Votes), max = max(df$Votes), value = c(min(df$Votes), max(df$Votes))),
            sliderInput(               # слайдер: кол-во интервалов гистограммы
              'int.hist',                       # связанная переменная
              'Количество интервалов гистограммы:', # подпись
              min = 2, max = 10,                    # мин и макс
              value = floor(1 + log(50, base = 2)), # базовое значение
              step = 1)                             # шаг
        ),
        # главная область
        mainPanel(
            # текстовый объект для отображения
            textOutput('gn.text'),
            textOutput('gn.text1'),
            textOutput('gn.text2'),
            textOutput('gn.text3'),
            textOutput('gn.text4'),
            # гистограммы переменных
            plotOutput('gn.hist')
            )
        )
    )
