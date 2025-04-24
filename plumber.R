
# -- init environment
source("./global.R")


# -- plumber.R ----
# This is the definition of the API endpoints
#* @apiTitle Rain Forecast API
#* @apiDescription Manage Observations & Predictions
#* @apiVersion 0.9


# -- Raw -----------------------------------------------------------------------

#* Return the list of available raw files
#* @serializer json
#* @param station The code of the weather station (default code is Sydney)
#* @param check A logical if it should check for new observations
#* @get api/v1/raw-observations
#* @tag Raw

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
#* @tag Raw

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
#* @tag Observations

function(res, station = "IDCJDW2124", start = NA, end = NA){
  
  cat("[API] Call to get observations \n")
  
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


#* Import Observations
#* @serializer json
#* @param station The code of the weather station (default code is Sydney)
#* @param year The year of the observation file
#* @param month The month of the observation file (must be two digits)
#* @param incremental Should import be incremental
#* @post api/v1/observations
#* @tag Observations

function(res, station = "IDCJDW2124", year = format(Sys.Date(), "%Y"), month = format(Sys.Date(), "%m"),
         incremental = TRUE){
  
  cat("[API] Call to import raw observation file \n")
  
  # -- Cast into logical
  # #15 incremental may become a character at this stage
  incremental <- as.logical(incremental)
  
  # -- technical pipeline
  technical_df <- technical_pipeline(station, year, month, incremental)
  
  # -- check import
  if(nrow(technical_df > 0)){
    
    # -- functional pipeline
    functional_df <- functional_pipeline(technical_df, incremental)
    
    # -- prediction pipeline
    if(nrow(functional_df) > 0)
      prediction_df <- prediction_pipeline(functional_df, incremental)}
  
  # -- return
  list(nb_imported_rows = nrow(technical_df))
  
}


# -- Predictions ---------------------------------------------------------------

#* Return the list of predictions
#* @serializer json
#* @param station The code of the weather station (default code is Sydney)
#* @param start A date to indicate the start of the date range
#* @param end A date to indicate the end of the date range
#* @get api/v1/predictions
#* @tag Predictions

function(res, station = "IDCJDW2124", model = "M1", start = NA, end = NA){
  
  cat("[API] Call to get predictions \n")
  
  # -- get predictions (all or date range)
  predictions <- if(is.na(start) | is.na(end))
    raw_predictions(station = station, model = model)
  else
    raw_predictions(station = station, model = model, start = start, end = end)
  
  
  # -- check output size
  if(nrow(predictions) == 0){
    res$status <- 404 # Not found
    return(list(error = "Resource not found"))}
  
  # -- return
  predictions
  
}
