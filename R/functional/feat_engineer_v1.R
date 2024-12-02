


feat_engineer_v1 <- function(x, model_name = "M1"){

  cat("Start feature engineering \n")
  
  # ----------------------------------------------------------------------------
  # Feature Engineering Parameters
  
  # -- columns to drop
  list_remove <- c('wind_gust_time', 'station')
  
  
  # ----------------------------------------------------------------------------
  # Load dataset report (schema)
  
  cat("- Load dataset schema \n")
  json_report_url <- file.path(path$schema, model_name, file$dataset_report)
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
  location_mapping_url <- file.path(path$schema, file$mapping_Location)
  location_mapping <- read.csv(location_mapping_url, sep = ',')
  
  
  # -------------------------------------
  # Load mean by location report
  
  cat("- Load mean by location report \n")
  mean_by_location_url <- file.path(path$schema, model_name, file$means_by_location)
  mean_by_loc_df <- read.csv(mean_by_location_url, sep = ',')
  
  
  # ----------------------------------------------------------------------------
  # Feature engineering
  
  cat("Apply feature engineering: \n")
  
  # -------------------------------------
  # -- drop columns
  x <- x[!colnames(x) %in% list_remove]
  
  
  # -------------------------------------
  # -- add columns
  
  # -- rain_today
  x$rain_today <- "No"
  # -- check for cases where no rows meet condition
  if(any(x$rain_fall > 0))
    # -- use which to avoid pb with NA's
    x[which(x$rain_fall > 0), ]$rain_today <- "Yes"
  
  # -- rain_tomorrow
  x$rain_tomorrow <- "No"
  x[which(x$rain_today == 'Yes') - 1, ]$rain_tomorrow <- "Yes"
  x[dim(x)[1], ]$rain_tomorrow <- "Na"
  
  
  # -- extract Month from Date
  cat("- extract Month from Date \n")
  x['month'] <- format(x$date, "%m")
  x['date'] <- NULL
  
  
  # -------------------------------------
  # -- Categorical features  
  # -- Fill values out of schema with unknown
  cat("- Fill categorical values out of schema \n")
  if(any(!x$wind_gust_dir %in% category_list[[2]]))
    x[!x$wind_gust_dir %in% category_list[[2]], ]$wind_gust_dir <- "UNK"
  if(any(!x$wind_dir_9am %in% category_list[[3]]))
    x[!x$wind_dir_9am %in% category_list[[3]], ]$wind_dir_9am <- "UNK"
  if(any(!x$wind_dir_3pm %in% category_list[[4]]))
    x[!x$wind_dir_3pm %in% category_list[[4]], ]$wind_dir_3pm <- "UNK"
  
  # -- Index categorical features 
  # (remove 1 because python started at 0...)
  cat("- Index categorical features \n")
  
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
    
    cat("   * Dealing with column:", col, "\n")
    
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
  cat("- Fill numerical missing values \n")
  x[numerical_features] <- lapply(numerical_features, fill_nan)
  
  # -- features normalization [(x - mean) / range]
  cat("- Numerical features normalization \n")
  
  # -- helper
  feat_norm <- function(col, mean, range){
    
    cat("Col =", col, "mean =", mean, "range=", range, "\n")
    
    # normalization
    x[col] <- (x[col] - mean) / range
    
    # return
    x[[col]]
    
  }
  
  # apply helper
  x[numerical_features] <- lapply(numerical_features, function(col) feat_norm(col, 
                                                                              mean_list[match(col, numerical_features)], 
                                                                              range_list[match(col, numerical_features)]))
  
  
  cat("End feature Engineering \n")
  
  # -------------------------------------
  # return
  
  x[1:nrow(x) - 1, ]
  
}
