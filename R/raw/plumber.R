

# -- init environment ----
source("./global.R")

# -- plumber.R ----
# This is the definition of the API endpoints

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
  
  # -- return (df as json)
  #jsonify::to_json(observations)
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
