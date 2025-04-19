

functional_pipeline <- function(technical, incremental = TRUE, simulation = FALSE){
  
  cat("Starting functional pipeline \n")
  
  # -- apply feature engineering
  functional <- feat_engineer_v1(technical, model_name = "M1")
  
  # -- import / update db
  if(!simulation)
    import <- db_import("functional", functional)
  
  # -- keep only imported rows (create / update)
  # unless both incremental and simulation are turned off
  if(incremental && !simulation)
    functional[functional$observation_id %in% import$row_ids, ]
  else
    functional
  
}
