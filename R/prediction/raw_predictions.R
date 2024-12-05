


raw_predictions <- function(station = "IDCJDW2124", model = "M1", start, end){

  # -- connect to db
  con <- db_connect()
  
  # -- build query
  query <- if(missing(start) | missing(end))
    paste0("SELECT * FROM prediction WHERE station = '", station, "' AND model = '", model, "'")
  
  else
    paste0("SELECT * FROM prediction WHERE station = '", station, "' AND model = '", model, "'",
           "' AND date BETWEEN ('", start, "') AND ('", end, "')")
  
  # -- execute query
  predictions <- DBI::dbGetQuery(con, query)
  
  # -- close connection
  DBI::dbDisconnect(con)
  
  # -- check output
  if(nrow(predictions) == 0)
    cat("[INFO] No prediction has been retrieved \n")
  else
    cat(nrow(predictions), "prediction(s) have been retrieved \n")
  
  # -- return
  predictions
  
}
