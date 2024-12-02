

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


import_into_functional <- function(data){
  
  # -- init return value
  affected_rows <- 0
  
  # -- init connection
  con <- db_connect()
  
  # -- check table
  if(!"functional" %in% DBI::dbListTables(con))
    create_table(con, table = "functional", data)
  
  
  # -- get existing rows (observation id)
  id_string <- paste(data$id, collapse = ",")
  query <- paste0("SELECT * FROM functional WHERE id IN (", id_string, ")")
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
    id_string <- paste(data_to_update$id, collapse = ",")
    query <- paste0("DELETE FROM functional WHERE id IN (", id_string, ")")
    
    # -- execute query
    affected_rows <- DBI::dbExecute(con, query)
    
    # -- check affected rows
    if(affected_rows != nrow(data_to_update))
      stop(">> There was a problem to delete these rows! \n")}
  
  
  # -- append the data.frame to the table
  if(nrow(data_to_import) > 0){
    
    cat(nrow(data_to_import), "observation(s) to import in database \n")
    affected_rows <- DBI::dbAppendTable(con, "functional", data_to_import)
    
    if(affected_rows == nrow(data_to_import))
      cat("Import succeeded \n")
    else
      cat("[WARNING] The number of affected rows (dbAppendTable output) does not match data_to_import! \n")}
  
  
  # -- close connection
  DBI::dbDisconnect(con)
  
  # -- return
  affected_rows
  
}
