

# call API to get available files
# check latest file timestamp (keep it in cache)
# if newer than cache / call API to get the file

check_raw <- function(){


  # -- Call API raw to get file
  RAW_API_URL <- "http://127.0.0.1:8325/api/v1/raw-observations"
  
  
  req <- curl::curl_fetch_memory(RAW_API_URL)
  req$status_code
  
  df <- jsonlite::fromJSON(rawToChar(req$content))

  
}
