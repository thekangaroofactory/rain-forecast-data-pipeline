

#' Raw Observations
#'
#' @param path the path where observation files are stored
#' @param station the code of the station (default = Sydney)
#' @param check a logical to indicate if it should check for missing observations
#'
#' @return a JSON object (containing the list of raw files & info)
#'
#' @examples observations()

raw_observations <- function(path = ".", station = "IDCJDW2124", check = FALSE){
  
  # -- download new observation file(s)
  if(check)
    check_observations(path, station)
  
  # -- list files & info
  observations <- file.info(list.files(path, pattern = station, full.names = T))
  observations$filename <- basename(row.names(observations))
  
  # -- check size
  if(nrow(observations) == 0)
    cat("[INFO] No file has been found! -- returning empty json \n")
  
  # -- make json from df & return
  jsonify::to_json(observations)
  
}
