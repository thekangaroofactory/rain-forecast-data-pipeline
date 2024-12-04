

prediction_pipeline <- function(functional){
  
  # -- load model
  target_url <- file.path(path$model, "rain_tomorrow_v1.h5")
  model <- keras::load_model_hdf5(target_url)
  
  # -- build predictions
  predictions <- make_predictions(model, functional)
  
  # -- add model name to id
  predictions$observation_id <- paste(predictions$observation_id, "M1", sep = "_")
  
  # -- return
  predictions
  
}
