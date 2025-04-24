


feat_engineer_v1 <- function(x, model_name = "M1", verbose = FALSE){

  cat("Start feature engineering \n")
  
  # ----------------------------------------------------------------------------
  # Feature Engineering Parameters
  
  # -- columns to drop
  list_remove <- c('wind_gust_time', 'station')
  
  
  # ----------------------------------------------------------------------------
  # Load dataset report (schema)
  
  cat("- Load dataset schema \n")
  json_report_url <- file.path(path$schema, model_name, filename$dataset_report)
  data_schema <- jsonlite::fromJSON(json_report_url)
  
  # -------------------------------------
  # Extract lists from report
  feature_list <- data_schema[['colname']]
  
  # Extract numerical related lists
  numerical_index <- which(data_schema[['coltype']] == "float")
  numerical_features <- feature_list[numerical_index]
  range_list <- data_schema[['range']][numerical_index]
  mean_list <- data_schema[['mean']][numerical_index]
  
  
  # Extract categorical related lists
  categorical_index <- which(data_schema[['coltype']] == "str")
  categorical_features <- feature_list[categorical_index]
  category_list <- data_schema[['unique_str']][categorical_index]
  
  
  # -------------------------------------
  # Load location mapping
  
  cat("- Load location mapping \n")
  location_mapping_url <- file.path(path$schema, filename$mapping_Location)
  location_mapping <- read.csv(location_mapping_url, sep = ',')
  
  
  # -------------------------------------
  # Load mean by location report
  
  cat("- Load mean by location report \n")
  mean_by_location_url <- file.path(path$schema, model_name, filename$means_by_location)
  mean_by_loc_df <- read.csv(mean_by_location_url, sep = ',')
  
  
  # ----------------------------------------------------------------------------
  # Feature engineering
  
  cat("Apply feature engineering \n")
  
  # -------------------------------------
  # -- drop columns
  x <- x[!colnames(x) %in% list_remove]
  
  
  # -------------------------------------
  # -- add columns
  
  # -- rain_today
  x$rain_today <- ifelse(x$rain_fall > 0, "Yes", "No")
  
  # -- Fixing #10:
  # In case rain_fall value is mission, rain_today is forced to "No" 
  # (rain_fall will be forced to 0)
  # adding check #16
  if(any(is.na(x$rain_today)))
    x[is.na(x$rain_today), ]$rain_today <- "No"
  
  # -- rain_tomorrow
  x$rain_tomorrow <- x[match(x$date + 1, x$date), ]$rain_today
  
  
  # -- extract Month from Date
  if(verbose) cat("- extract Month from Date \n")
  x['month'] <- format(x$date, "%m")
  x['date'] <- NULL
  
  
  # -------------------------------------
  # -- Categorical features  
  # -- Fill values out of schema with unknown
  if(verbose) cat("- Fill categorical values out of schema \n")
  if(any(!x$wind_gust_dir %in% category_list[[2]]))
    x[!x$wind_gust_dir %in% category_list[[2]], ]$wind_gust_dir <- "UNK"
  if(any(!x$wind_dir_9am %in% category_list[[3]]))
    x[!x$wind_dir_9am %in% category_list[[3]], ]$wind_dir_9am <- "UNK"
  if(any(!x$wind_dir_3pm %in% category_list[[4]]))
    x[!x$wind_dir_3pm %in% category_list[[4]], ]$wind_dir_3pm <- "UNK"
  
  # -- Index categorical features 
  # (remove 1 because python started at 0...)
  if(verbose) cat("- Index categorical features \n")
  
  # -- wind
  x$wind_gust_dir <- match(x$wind_gust_dir, c("UNK", category_list[[2]])) - 1
  x$wind_dir_9am <- match(x$wind_dir_9am, c("UNK", category_list[[3]])) - 1
  x$wind_dir_3pm <- match(x$wind_dir_3pm, c("UNK", category_list[[4]])) - 1
  
  # -- location
  x$location <- location_mapping[match(x$location, location_mapping$Location), ]$Mapping
  
  # -- rain
  x$rain_today <- match(x$rain_today, category_list[[5]]) - 1
  x$rain_tomorrow <- match(x$rain_tomorrow, category_list[[6]]) - 1
  
  
  # -------------------------------------
  # -- Numerical features
  
  # -- Check columns 'wind_speed_9am' & 'wind_speed_3pm'
  if("Calm" %in% unique(x$wind_speed_9am))
    x[x$wind_speed_9am == "Calm", ]$wind_speed_9am <- "0"
  if("Calm" %in% unique(x$wind_speed_3pm))
    x[x$wind_speed_3pm == "Calm", ]$wind_speed_3pm <- "0"

  # -- Cast to numeric
  x$wind_speed_9am <- as.numeric(x$wind_speed_9am)
  x$wind_speed_3pm <- as.numeric(x$wind_speed_3pm)

  
  # -- Fill NaN values
  fill_nan <- function(col){
    
    if(verbose) cat("   * Dealing with column:", col, "\n")
    
    # col name
    meancol = paste0('mean_', col)
    
    # replace from mean_by_loc_df or mean_list by default
    if(meancol %in% colnames(mean_by_loc_df))
      x[is.na(x[col]), col] <-  mean_by_loc_df[mean_by_loc_df$location == "Sydney", meancol]
    
    else
      x[is.na(x[col]), col] <- mean_list[which(numerical_features == col)]
    
    # return
    x[[col]]
    
  }
  
  # -- apply helper
  if(verbose) cat("- Fill numerical missing values \n")
  x[numerical_features] <- lapply(numerical_features, fill_nan)
  
  # -- features normalization [(x - mean) / range]
  if(verbose) cat("- Numerical features normalization \n")
  
  # -- helper
  feat_norm <- function(col, mean, range){
    
    if(verbose) cat("Col =", col, "mean =", mean, "range=", range, "\n")
    
    # normalization
    x[col] <- (x[col] - mean) / range
    
    # return
    x[[col]]
    
  }
  
  # apply helper
  x[numerical_features] <- lapply(numerical_features, function(col) feat_norm(col, 
                                                                              mean_list[match(col, numerical_features)], 
                                                                              range_list[match(col, numerical_features)]))
  
  
  # -------------------------------------
  # -- cast format
  x$wind_gust_dir <- as.integer(x$wind_gust_dir)
  x$wind_dir_9am <- as.integer(x$wind_dir_9am)
  x$wind_dir_3pm <- as.integer(x$wind_dir_3pm)
  x$rain_today <- as.integer(x$rain_today)
  x$month <- as.integer(x$month)
  
  
  cat("End feature Engineering \n")
  
  # -------------------------------------
  # return
  
  x
  
}
