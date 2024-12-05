

make_predictions <- function(name, functional){

  # -- prepare input
  # select, rename & cast
  input_df <- prepare_input(functional)

  # -- load model
  target_url <- file.path(path$model, "rain_tomorrow_v1.h5")
  model <- keras::load_model_hdf5(target_url)
  
  # -- make predictions (keras)
  raw_predictions <- predict(model, x = as.matrix(input_df))
  
  # -- return
  data.frame(observation_id = paste(functional$observation_id, name, sep = "_"),
             station = substr(functional$observation_id, 1, 10),
             date = as.Date(substr(functional$observation_id, 12, 19), format = "%Y%m%d"),
             model = name,
             raw_prediction = raw_predictions)

}
