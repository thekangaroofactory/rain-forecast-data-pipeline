

#' Import Into Technical
#'
#' @param data a data.frame to be imported into technical table
#'
#' @return a numeric, corresponding to the number of inserted rows (create & update)
#' 
#' @details
#' The import is incremental, so only the data.frame rows that do not exist yet in
#' the table will be imported. The rows that already exist but needs an update
#' will be deleted first, then inserted with the new values.
#' 
#'
#' @examples import_technical(data)


import_into_technical <- function(data){
  
  # -- init return value
  affected_rows <- 0
  
  # -- init connection
  con <- db_connect()
  
  # -- check table
  if(!"technical" %in% DBI::dbListTables(con))
    create_technical_table(con, table = "technical", data)
  
  
  # -- get existing rows (Station & Date)
  date_string <- paste(data$date, collapse = "', '")
  query <- paste0("SELECT * FROM technical WHERE station = '", unique(data$station), "' AND date IN ('", date_string, "')")
  existing_rows <- DBI::dbGetQuery(con, query)
  if(nrow(existing_rows) > 0)
    cat(nrow(existing_rows), "observation(s) already exist(s) in database \n")

  # -- check if input already exists in db table (with same values!)
  # paste0 will collapse df rows into single values that are easy to compare :)
  data_to_import <- data[!do.call(paste0, data) %in% do.call(paste0, existing_rows), ]
  
  
  # -- for those who needs an update, we do delete / create
  data_to_update <- data_to_import[data_to_import$date %in% existing_rows$date, ]
  if(nrow(data_to_update) > 0){
    
    cat(nrow(data_to_update), "row(s) to update in database \n")
    
    # -- prepare query
    date_string <- paste(data_to_update$date, collapse = "', '")
    query <- paste0("DELETE FROM technical WHERE station = '", unique(data$station), "' AND date IN ('", date_string, "')")
    
    # -- execute query
    affected_rows <- DBI::dbExecute(con, query)
    
    # -- check affected rows
    if(affected_rows != nrow(data_to_update))
      stop(">> There was a problem to delete these rows! \n")}
  
  
  # -- append the data.frame to the table
  if(nrow(data_to_import) > 0){
    
    cat(nrow(data_to_import), "observation(s) to import in database \n")
    affected_rows <- DBI::dbAppendTable(con, "technical", data_to_import)
    
    if(affected_rows == nrow(data_to_import))
      cat("Import succeeded \n")
    else
      cat("[WARNING] The number of affected rows (dbAppendTable output) does not match data_to_import! \n")}
  
  
  # -- close connection
  DBI::dbDisconnect(con)
  
  # -- return
  affected_rows
  
}
