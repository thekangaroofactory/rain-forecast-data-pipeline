

#' Format Raw File
#'
#' @param path the path of the raw file
#' @param filename the name of the file
#'
#' @return a data.frame of formatted observations
#'
#' @examples format_raw_file(path = ".", filename = "myfile.csv")

format_raw_file <- function(path = ".", filename){
  
  # -- read file
  # skip the header lines
  cat("Processing raw file:", filename, "\n")
  data <- read.csv(file.path(path, filename), header = TRUE, colClasses = colClasses_raw, skip = 8, encoding = "ANSI")
  
  # -- get station from filename
  station <- unlist(strsplit(filename, split = ".", fixed = T))[1]
  
  
  # ---------------------------------------------------
  # Drop & Rename Columns
  
  # -- drop empty column (cause header in first col is skipped)
  data[c('X')] <- NULL
  
  # -- rename to fit with PostgreSQL
  colnames(data) <- cols_technical
  
  
  # ---------------------------------------------------
  # Format Columns
  
  # -- date column
  data$date = as.Date(data$date, format = '%Y-%m-%d')

  
  # ---------------------------------------------------
  # Add columns
  
  # -- compute observation id, station, location
  # prefix <- data.frame(id = ktools::seq_timestamp(n = nrow(data)))
  prefix <- data.frame(
    observation_id = paste(station, gsub('-', '', data$date), sep = "_"),
    station = station,
    location = unlist(stations[station]))
  
  # -- merge columns
  data <- cbind(prefix, data)
  
  # return
  data
  
}
