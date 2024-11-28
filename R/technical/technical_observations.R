

#' Technical Observations
#'
#' @param station the code of the station (default is code for Sydney)
#' @param start a date (either as Date or character) to indicate range start
#' @param end a date (either as Date or character) to indicate range end
#'
#' @return a data.frame of selected rows in database technical table
#'
#' @examples technical_observations()

technical_observations <- function(station = "IDCJDW2124", start, end){

  # -- connect to db
  con <- db_connect()
  
  # -- build query
  query <- if(missing(start) | missing(end))
    paste0("SELECT * FROM technical WHERE station = '", station, "'")
  
  else
    paste0("SELECT * FROM technical WHERE station = '", station, 
                  "' AND date BETWEEN ('", start, "') AND ('", end, "')")
  
  # -- execute query
  observations <- DBI::dbGetQuery(con, query)
  
  # -- check output
  if(nrow(observations) == 0)
    cat("[INFO] No observations have been retrieved \n")
  else
    cat(nrow(observations), "observation(s) have been retrieved \n")
  
  # -- return
  observations
  
}
