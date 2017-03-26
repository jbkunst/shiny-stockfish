shinyServer(function(input, output, session) {
  
  logjs("in session")

  chss <- Chess$new()
  # console <<- ""
  autoInvalidate <- reactiveTimer(2000)
  
  observe({
    autoInvalidate()
    
    logjs(.Platform$OS.type)
    
    handle <- spawn_process(ifelse(.Platform$OS.type == "unix", "/usr/games/stockfish", "stockfish_8_x64.exe"))
    logjs("handle")
    
    process_write(handle, sprintf("position fen %s\n", chss$fen()))
    logjs(process_read(handle, PIPE_STDOUT, timeout = 8000))
    
    process_write(handle, sprintf("go depth %s\n", 2))
    out <- process_read(handle, PIPE_STDOUT, timeout = 8000)
    
    logjs("out")
    logjs(out)
    
    # console <<- out
    
    process_kill(handle)
    
    mv <- str_split(last(out), " ")[[1]][[2]]
    
    logjs("mv")
    logjs(mv)
    
    mvsan <- chss$moves(verbose = TRUE) %>% 
      mutate(ft = paste0(from, to)) %>% 
      filter(ft == mv) %>% 
      {.$san}
    
    chss$move(move = mvsan)
    
  })
  
  output$board <- renderChessboardjs({
    autoInvalidate()
    chss$plot()
  })
  
  output$console <- renderPrint({
    # autoInvalidate()
    # console
    "hola"
  })
  
})
