

#' Force Update Raw Files
#'
#' @param path the path where to download the files
#'
#' @details
#' It will download the 13 last months (from the current date)
#' To avoid files to be overwritten by potential error output from the BOM
#' website, a force_update folder will be created under path.
#' 
#' @export
#'
#' @examples
#' /dontrun{
#' force_update()
#' }

force_update <- function(path = "."){
  
  # -- secure data
  path <- file.path(path, "force_update")
  
  # -- init
  year <- format(Sys.Date(), "%Y")
  month <- format(Sys.Date(), "%m")
  
  # -- build current year sequence
  month_seq <- 1:as.numeric(month)
  month_seq <- ifelse(month_seq < 10, paste0("0", month_seq), month_seq)
  
  # -- compute previous year
  previous_year <- as.character(as.numeric(year) - 1)
  
  # -- build previous year sequence
  previous_month_seq <- as.numeric(month):12
  previous_month_seq <- ifelse(previous_month_seq < 10, paste0("0", previous_month_seq), previous_month_seq)
  
  # -- apply
  files_1 <- lapply(month_seq, function(x) download_observations(year = year, month = x, path = path))
  files_2 <- lapply(previous_month_seq, function(x) download_observations(year = previous_year, month = x, path = path))
  result <- c(files_1, files_2)
  cat(length(result), "files have been downloaded. \n")
  
}
