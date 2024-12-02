

#' Create Technical Table
#'
#' @param data a data.frame of raw observations to create the table from
#'
#' @return a logical if the table has been created in database
#'
#' @examples create_technical_table(data)

create_table <- function(con, table, data){

  # -- create table
  # based on data.frame column names & types
  DBI::dbCreateTable(conn = con, name = table, data)
  
  # -- check & return
  success <- table %in% DBI::dbListTables(con)
  
}
