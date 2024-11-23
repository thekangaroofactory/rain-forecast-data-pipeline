

#' Latest Observation
#'
#' @param path path to the raw files
#' @param station a weather station (default = Sydney)
#'
#' @return a Date or NULL (see details)
#' 
#' @details
#' The return value is the first day of the month for the latest 'truthy' observation.
#' In almost any cases, it will return the first day of the lastest available file.
#' When the current day is the first day of a month, then it will return the first
#' day of the previous month to make sure 'yesterday' will get updated. This is because
#' the last line of a file may not be complete depending on when it has been downloaded.
#' 
#' NULL will be returned when no file is found.
#'
#' @examples latest_observation()

latest_observation <- function(path = ".", station = "IDCJDW2124"){
  
  # -- list existing files
  cat("[latest_observation]\n")
  cat("Checking files: station =", station, "/ path =", path, "\n")
  filenames <- list.files(path = path, pattern = station)
  
  # -- check for empty output
  if(identical(filenames, character(0)))
    return(NULL)
  
  # -- get latest "YYYYMM" from the file names
  # example: "IDCJDW2124.202411.csv"
  latest <- max(vapply(strsplit(filenames, ".", fixed = T), `[`, 2, FUN.VALUE = character(1)))
  cat("Latest file =", latest, "\n")
  
  # -- check:
  # on 1st day of the month, we need to make sure previous month file will
  # be updated (as 'yesterday' may not be complete)
  if(latest == format(Sys.Date(), "%Y%m") & format(Sys.Date(), "%d") == "01"){
    cat("[INFO] Force latest to yesterday to update previous month \n")
    latest <- format(Sys.Date() - 1, "%Y%m")}
    
  # -- prepare (compute first day of the month)
  year <- substr(latest, start = 1, stop = 4)
  month <- substr(latest, start = 5, stop = 6)
  day <- "01"
  
  # -- return (date)
  as.Date(paste(year, month, day, sep = "-"))
  
}
