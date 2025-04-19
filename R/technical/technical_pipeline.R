

technical_pipeline <- function(station = "IDCJDW2124", year = format(Sys.Date(), "%Y"), month = format(Sys.Date(), "%m"),
                               incremental = TRUE, simulation = FALSE){
  
  cat("Starting technical pipeline \n")
  
  # -- build filename
  filename <- paste0(station, ".", year, month, ".csv")
  
  # -- format raw data
  technical <- format_raw_file(path = path$raw, filename)
  
  # -- import into technical table
  if(!simulation)
    import <- db_import("technical", technical)
  
  # -- keep only imported rows (create / update)
  # unless both incremental and simutation are turned off
  if(incremental && !simulation)
    technical[technical$observation_id %in% import$row_ids, ]
  else
    technical
  
}
