
library(keras)

cat("  - Running local, init conda env \n")
reticulate::use_condaenv("r-reticulate", required = TRUE)

# -- load model
target_url <- file.path(path$model, "rain_tomorrow_v1.h5")
model <- keras::load_model_hdf5(target_url)



make_predictions <- function(model, functional){
  
  # -- prepare input
  # select, rename & cast
  input_df <- prepare_input(functional)
  
  # -- drop RainTomorrow
  input_df <- input_df[!colnames(input_df) %in% "RainTomorrow"]
  
  # -- make predictions (keras)
  raw_predictions <- predict(model, x = as.matrix(input_df))
  
  # -- return
  data.frame(id = functional$observation_id,
             raw_prediction = raw_predictions)
  
}

predictions$model_name <- "M1"
