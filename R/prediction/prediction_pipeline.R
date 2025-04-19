

prediction_pipeline <- function(functional, incremental = TRUE, simulation = FALSE){

  cat("Starting prediction pipeline \n")
  
  # -- build predictions df
  predictions <- make_predictions(name = "M1", functional)

  # -- import / update db
  if(!simulation)
    import <- db_import("prediction", predictions)
  
  # -- keep only imported rows (create / update)
  # unless both incremental and simulation are turned off
  if(incremental && !simulation)
    predictions[predictions$observation_id %in% import$row_ids, ]
  else
    predictions

}
