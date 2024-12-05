

prediction_pipeline <- function(functional){

  cat("Starting prediction pipeline \n")
  
  # -- build predictions df
  predictions <- make_predictions(name = "M1", functional)

  # -- import / update db
  import <- db_import("prediction", predictions)
  
  # -- keep only imported rows (create / update)
  predictions[predictions$observation_id %in% import$row_ids, ]

}
