

# -- plumber.R ----
# This is the definition of the API endpoints
#* @apiTitle Rain Forecast API
#* @apiDescription Manage Observations
#* @apiVersion 0.9


# -- Raw -----------------------------------------------------------------------

#* Return the list of available raw files
#* @serializer json
#* @param station The code of the weather station (default code is Sydney)
#* @param check A logical if it should check for new observations
#* @get api/v1/raw-observations

function(res, station = "IDCJDW2124", check = FALSE){
  
  # -- get list of raw files
  observations <- raw_observations(path = path$raw, station = station, check = check)
  
  # -- check output size
  if(nrow(observations) == 0){
    res$status <- 404 # Not found
    return(list(error = "Resource not found"))}
  
  # -- return
  observations
  
}


#* Return a specific raw observation file
#* @serializer csv
#* @param station The code of the weather station (default code is Sydney)
#* @param year The year of the observation file
#* @param month The month of the observation file
#* @param check A logical if it should check for new observations
#* @get api/v1/raw-observation

function(res, station = "IDCJDW2124", year = format(Sys.Date(), "%Y"), 
         month = format(Sys.Date(), "%m"), check = FALSE){
  
  # -- get list of raw files
  observations <- raw_observations(path = path$raw,
                                   station = station,
                                   year = year,
                                   month = month,
                                   check = check)
  
  # -- check output size
  if(nrow(observations) == 0){
    res$status <- 404 # Not found
    return(data.frame(error = "Resource not found"))}
  
  if(nrow(observations) > 1)
    observations <- head(observations, n = 1)
  
  
  # -- return
  plumber::include_file(file.path(path$raw, observations$filename), 
                        res, 
                        content_type = "text/csv; charset=utf-8")
  
}


# -- Technical -----------------------------------------------------------------

#* Return the list of observations
#* @serializer json
#* @param station The code of the weather station (default code is Sydney)
#* @param start A date to indicate the start of the date range
#* @param end A date to indicate the end of the date range
#* @get api/v1/observations

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


#* Import raw observations
#* @serializer json
#* @param station The code of the weather station (default code is Sydney)
#* @param year The year of the observation file
#* @param month The month of the observation file (must be two digits)
#* @post api/v1/observations

function(res, station = "IDCJDW2124", year = format(Sys.Date(), "%Y"), month = format(Sys.Date(), "%m")){
  
  cat("[API] Call to import raw file into technical table \n")
  
  # -- build file name
  filename <- paste0(station, ".", year, month, ".csv")
  
  # -- get formatted data
  data <- format_raw_file(path = path$raw, filename)
  
  # -- import into db
  nb_rows <- db_import("technical", data)
  
  # -- return
  list(nb_imported_rows = nb_rows)
  
}
