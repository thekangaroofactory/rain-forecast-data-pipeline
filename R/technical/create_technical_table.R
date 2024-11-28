

#' Create Technical Table
#'
#' @param data a data.frame of raw observations to create the table from
#'
#' @return a logical if the table has been created in database
#'
#' @examples create_technical_table(data)

create_technical_table <- function(data){
  
  # -- init connection
  con <- db_connect
  
  # -- create table
  # based on data.frame column names & types
  DBI::dbCreateTable(conn = con, name = "technical", data)
  
  # -- list tables
  success <- "technical" %in% DBI::dbListTables(con)
  
  # -- close connection
  DBI::dbDisconnect(con)
  
  # -- return
  success
  
}
