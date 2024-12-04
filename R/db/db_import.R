

#' Import Data
#'
#' @param table a character string to indicate the table name
#' @param data a data.frame to be imported into the table
#'
#' @return a numeric, corresponding to the number of inserted rows (create & update)
#' 
#' @details
#' The import is incremental, so only the data.frame rows that do not exist yet in
#' the table will be imported. The rows that already exist but needs an update
#' will be deleted first, then inserted with the new values.
#' 
#'
#' @examples db_import("technical", data)


db_import <- function(table, data){
  
  # -- init return value
  affected_rows <- NULL
  
  # -- init connection
  con <- db_connect()
  
  # -- check table
  if(!check_table(con, table, data))
    stop("database table is not found or creation failed")
  
  
  # -- existing rows -----------------------------------------------------------
  # first, check if some observation_id already exist(s)
  
  # -- prepare query
  id_string <- paste(data$observation_id, collapse = "', '")
  query <- paste0("SELECT * FROM ", table, " WHERE observation_id IN ('", id_string, "')")
  
  # -- get existing rows
  existing_rows <- DBI::dbGetQuery(con, query)
  if(nrow(existing_rows) > 0)
    cat(nrow(existing_rows), "row(s) already exist(s) in database \n")
  
  
  # -- filter input ------------------------------------------------------------
 
  # -- check if input already exists in db table (with same values!)
  # paste0 will collapse df rows into single values that are easy to compare :)
  data_to_import <- data[!do.call(paste0, data) %in% do.call(paste0, existing_rows), ]
  
  # -- for those who needs an update, we do delete / create
  data_to_update <- data_to_import[data_to_import$observation_id %in% existing_rows$observation_id, ]
  
  
  # -- drop existing rows ------------------------------------------------------
  
  # -- check nb rows
  if(nrow(data_to_update) > 0){
    
    cat(nrow(data_to_update), "row(s) to delete in database \n")
    
    # -- prepare query
    id_string <- paste(data_to_update$observation_id, collapse = "', '")
    query <- paste0("DELETE FROM ", table, " WHERE observation_id IN ('", id_string, "')")
    
    # -- execute query
    affected_rows <- DBI::dbExecute(con, query)
    
    # -- check affected rows
    if(affected_rows != nrow(data_to_update))
      stop(">> There was a problem to delete these rows! \n")}
  
  
  # -- insert rows -------------------------------------------------------------
  
  # -- append the data.frame to the table
  if(nrow(data_to_import) > 0){
    
    cat(nrow(data_to_import), "row(s) to import in database \n")
    affected_rows <- DBI::dbAppendTable(con, table, data_to_import)
    
    if(affected_rows == nrow(data_to_import))
      cat("Import succeeded \n")
    else
      cat("[WARNING] The number of affected rows (dbAppendTable output) does not match data_to_import! \n")}
  
  
  # -- close connection
  DBI::dbDisconnect(con)
  
  # -- return
  affected_rows
  
}
