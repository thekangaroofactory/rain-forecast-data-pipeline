

#' Raw Observations
#'
#' @param path the path where observation files are stored
#' @param station the code of the station (default = Sydney)
#' @param check a logical to indicate if it should check for missing observations
#'
#' @return a data.frame containing the list of raw files & info
#'
#' @examples observations()

raw_observations <- function(path = ".", 
                             station = "IDCJDW2124", 
                             year = NULL, 
                             month = NULL, 
                             check = FALSE){
  
  # -- download new observation file(s)
  if(check)
    check_observations(path, station)
  
  # -- build pattern
  pattern <- station
  if(!is.null(year) & !is.null(month))
    pattern <- paste(pattern, paste0(year, month), sep = ".")
  cat("Search pattern =", pattern, "\n")
    
  # -- list files & info
  file_info <- file.info(list.files(path, pattern = pattern, full.names = T))
  file_info$filename <- basename(row.names(file_info))
  cat("Nb file(s) found =", nrow(file_info), "\n")
  
  # -- prepare output
  # the data.frame output of file.info does not work with jsonlite::toJSON
  observations <- data.frame(filename = file_info$filename,
                             size = file_info$size,
                             mtime = file_info$mtime)
  
  # -- return
  observations
  
}
