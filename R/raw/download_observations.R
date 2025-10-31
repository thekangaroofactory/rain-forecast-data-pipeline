

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
    year <- format(Sys.Date(), "%Y")
    
  }
  
  if(is.null(month)){
    
    cat("[INFO] Setting current month as default value \n")
    month <- format(Sys.Date(), "%m")
    
  }
  
  # -- prepare target url
  target_url <- "http://www.bom.gov.au/climate/dwo/"
  target_url <- paste(target_url, year, month, "/text/", sep = "")
  target_url <- paste(target_url, station, ".", year, month, ".csv", sep = "")
  cat("Ready to download from", target_url, "\n")
  
  # -- download target url
  # Adding option see #22
  download <- RCurl::getURL(target_url, .opts = RCurl::curlOptions(followlocation = TRUE))
  cat("Download done, size =", object.size(download) ,"\n")
  
  # -- check size
  # normal file is about 4kb
  if(object.size(download) > 5000){
    cat("[Warning] Download size seems to high! -- checking: \n")
    
    # -- check if contains HTML tags (i.e. <>)
    cat("-- if output contains <> tags:", grepl("<.*>", download), "\n")
    
    # -- count occurrences of \n in the output
    # about 40/41 is a full month, not found will produce > 300
    nb_lines <- nchar(gsub("[^\n]+", "", download)) + 1
    cat("-- Nb of lines =", nb_lines, "\n")
    
    return(">> Check if the requested month is still available on the BOM website.")}
  

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
