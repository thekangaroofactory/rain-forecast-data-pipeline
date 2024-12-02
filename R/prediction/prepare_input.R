

prepare_input <- function(functional){
  
  # -- cols as loaded from functional
  # functional_cols <- c("min_temp",
  #                      "max_temp",
  #                      "rain_fall",
  #                      "evaporation",
  #                      "sunshine",
  #                      "wind_gust_dir",
  #                      "wind_gust_speed",
  #                      "temp_9am",
  #                      "humidity_9am",
  #                      "cloud_9am",
  #                      "wind_dir_9am",
  #                      "wind_speed_9am",
  #                      "pressure_9am",
  #                      "temp_3pm",
  #                      "humidity_3pm",
  #                      "cloud_3pm",
  #                      "wind_dir_3pm",
  #                      "wind_speed_3pm",
  #                      "pressure_3pm",
  #                      "station", 
  #                      "location",
  #                      "rain_today",
  #                      "rain_tomorrow",
  #                      "month")
  
  # -- select and order columns
  cols_select_and_order <- c("location",
                             "min_temp",
                             "max_temp",
                             "rain_fall",
                             "wind_gust_dir",
                             "wind_gust_speed",
                             "wind_dir_9am",
                             "wind_dir_3pm",
                             "wind_speed_9am",
                             "wind_speed_3pm",
                             "humidity_9am",
                             "humidity_3pm",
                             "pressure_9am",
                             "pressure_3pm",
                             "temp_9am",
                             "temp_3pm",
                             "rain_today",
                             "rain_tomorrow",
                             "month")
  
  # -- select and order df
  x <- functional[cols_select_and_order]
  
  # -- cols as expected by the models
  cols_rename <- c("Location",
                   "MinTemp",
                   "MaxTemp",
                   "Rainfall",
                   "WindGustDir",
                   "WindGustSpeed",
                   "WindDir9am",
                   "WindDir3pm",
                   "WindSpeed9am",
                   "WindSpeed3pm",
                   "Humidity9am",
                   "Humidity3pm",
                   "Pressure9am",
                   "Pressure3pm",
                   "Temp9am",
                   "Temp3pm",
                   "RainToday",
                   "RainTomorrow",
                   "Month")
  
  # -- rename cols to fit with model input
  colnames(x) <- cols_rename
  
  # -- cast format
  x$WindGustDir <- as.integer(x$WindGustDir)
  x$WindDir9am <- as.integer(x$WindDir9am)
  x$WindDir3pm <- as.integer(x$WindDir3pm)
  x$RainToday <- as.integer(x$RainToday)
  x$Month <- as.integer(x$Month)
  
  # -- return
  x
  
}
