shinyUI(
  fluidPage(
    theme = shinytheme("paper"),
    h3("StockfishR vs Stockfisher"),
    fluidRow(
      column(
        4,
        sliderInput("depth1", "Depth for white", min = 1, max = 10, value = 8),
        sliderInput("depth2", "Depth for black", min = 1, max = 10, value = 9)
        ),
      column(4, chessboardjsOutput("board")),
      column(4, verbatimTextOutput("console"))
      )
    )
  )