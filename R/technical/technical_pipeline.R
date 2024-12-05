

technical_pipeline <- function(station = "IDCJDW2124", year = format(Sys.Date(), "%Y"), month = format(Sys.Date(), "%m")){
  
  cat("Starting technical pipeline \n")
  
  # -- build filename
  filename <- paste0(station, ".", year, month, ".csv")
  
  # -- format raw data
  technical <- format_raw_file(path = path$raw, filename)
  
  # -- import into technical table
  import <- db_import("technical", technical)
  
  # -- keep only imported rows (create / update)
  technical[technical$observation_id %in% import$row_ids, ]
  
}
