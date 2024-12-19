

#' Check Observations
#'
#' @param path the path of the raw observation files
#' @param station the code for the station (default = Sydney)
#'
#' @return a vector of downloaded files or NULL if nothing has been downloaded
#'
#' @examples check_observations()

check_observations <- function(path = ".", station = "IDCJDW2124"){
  
  cat("[check_observations] \nCheck for missing observation file(s) \n")
  
  # -- get latest observation reference date
  # (first day of the month)
  latest <- latest_observation(path, station)
  
  # -- check output
  # when no observation file is found, it should download the current month #8
  if(is.null(latest))
    latest <- as.Date(paste0(format(Sys.Date(), "%Y-%m-"), "01"))
  
  # -- get missing observations (df of missing year / month)
  download_df <- missing_observations(latest = latest)
  
  # -- apply download function
  list_downloads <- apply(download_df, MARGIN = 1, 
                          function(x) download_observations(year = x['year'], month = x['month'], 
                                                            station = station, path = path))
  
  # -- to send to the format API
  # list of downloaded file(s)
  list_downloads
  
}
