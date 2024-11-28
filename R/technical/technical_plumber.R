

# -- init environment ----
source("./global.R")

# -- plumber.R ----
# This is the definition of the API endpoints

#* Return the list of observations in the technical table
#* @serializer json
#* @param station The code of the weather station (default code is Sydney)
#* @param start A date to indicate the start of the date range
#* @param end A date to indicate the end of the date range
#* @get api/v1/technical/observations

function(res, station = "IDCJDW2124", start = NA, end = NA){
  
  cat("[API] Call to get technical observations \n")
  
  # -- get observations (all or date range)
  observations <- if(is.na(start) | is.na(end))
    technical_observations(station = station)
  else
    technical_observations(station = station, start = start, end = end)
  
  
  # -- check output size
  if(nrow(observations) == 0){
    res$status <- 404 # Not found
    return(list(error = "Resource not found"))}
  
  # -- return
  observations
  
}


#* Import raw file into the technical table
#* @serializer json
#* @param station The code of the weather station (default code is Sydney)
#* @param year The year of the observation file
#* @param month The month of the observation file (must be two digits)
#* @post api/v1/technical/observations

function(res, station = "IDCJDW2124", year = format(Sys.Date(), "%Y"), month = format(Sys.Date(), "%m")){

  cat("[API] Call to import raw file into technical table \n")
  
  # -- build file name
  filename <- paste0(station, ".", year, month, ".csv")
  
  # -- get formatted data
  data <- format_raw_file(path = path$raw, filename)
  
  # -- import into db
  nb_rows <- import_into_technical(data)
  
  # -- return
  list(nb_imported_rows = nb_rows)
  
}
