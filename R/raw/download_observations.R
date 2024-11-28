

#' Download Observations
#'
#' @param year year of the observations to be downloaded. If NULL, current year 
#' will be used.
#' @param month month of the observations to be downloaded. If NULL, current month 
#' will be used. Should be double digit to match file name.
#' @param station station of the observations to be downloaded. Default is "IDCJDW2124" (Sydney)
#' @param path where to save the downloaded file.
#'
#' @return the url of the downloaded file
#'
#' @examples download_observations(year = "2022", month = "01", station = "IDCJDW2124", path = ".")


download_observations <- function(year = NULL, month = NULL, station = "IDCJDW2124", path = "."){
  
  # -- check arguments
  if(is.null(year)){
    
    cat("[INFO] Setting current year as default value \n")
    year = format(Sys.Date(), "%Y")
    
  }
  
  if(is.null(month)){
    
    cat("[INFO] Setting current month as default value \n")
    month = format(Sys.Date(), "%m")
    
  }
  
  # -- prepare target url
  target_url <- "http://www.bom.gov.au/climate/dwo/"
  target_url <- paste(target_url, year, month, "/text/", sep = "")
  target_url <- paste(target_url, station, ".", year, month, ".csv", sep = "")
  cat("Ready to download from", target_url, "\n")
  
  # -- download target url
  download <- RCurl::getURL(target_url)
  cat("Download done, size =", object.size(download) ,"\n")
  
  # -- drop extra line breaks and save to file
  download <- gsub('[\r]','', download)
  
  # -- prepare file name
  target_file <- paste(station, paste(year,month, sep = ""), "csv", sep = ".")
  target_file <- file.path(path, target_file)
  
  # -- check folder
  if(!dir.exists(path)){
    cat("[INFO] Creating target directory", path , "\n")
    dir.create(path)}
  
  # -- write file
  cat("Writing file to", target_file, "\n")
  write(download, target_file)
  
  # -- return (file url)
  target_file
  
}
