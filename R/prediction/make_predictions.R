
#library(keras)

#cat("  - Running local, init conda env \n")
#reticulate::use_condaenv("r-reticulate", required = TRUE)


make_predictions <- function(model, functional){

  # -- prepare input
  # select, rename & cast
  input_df <- prepare_input(functional)

  # -- make predictions (keras)
  raw_predictions <- predict(model, x = as.matrix(input_df))
  
  # -- return
  data.frame(observation_id = functional$observation_id,
             raw_prediction = raw_predictions)

}
