

functional_pipeline <- function(technical, incremental = TRUE){
  
  cat("Starting functional pipeline \n")
  
  # -- apply feature engineering
  functional <- feat_engineer_v1(technical, model_name = "M1")
  
  # -- import / update db
  import <- db_import("functional", functional)
  
  # -- keep only imported rows (create / update)
  # unless incremental is turned off
  if(incremental)
    functional[functional$observation_id %in% import$row_ids, ]
  else
    functional
  
}
