

#' Missing Observations
#'
#' @param latest a Date to indicate the latest available observation (default = current date)
#'
#' @return a data.frame (year, month columns) of the missing observation files
#'
#' @examples missing_observations()

missing_observations <- function(latest = Sys.Date()){
  
  cat("[missing_observations]\n")
  cat("-- latest observation =", as.character(latest), "\n")

  # -- last day of this month
  seq_end <- lubridate::ceiling_date(Sys.Date(), 'month') - 1
  
  # -- make sequence
  ym_sequence <- format(seq(latest, seq_end, by = "month"), "%Y-%m")
  missing_obs <- as.data.frame(stringr::str_split_fixed(ym_sequence, "-", 2))
  colnames(missing_obs) <- c("year", "month")
  
  # -- return
  missing_obs
  
}
