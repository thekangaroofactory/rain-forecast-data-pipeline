

# -- colClasses (as per read.csv output)
colClasses_raw <- c("X" = "character",
                    "Date" = "character",
                    "Minimum.temperature...C." = "numeric",
                    "Maximum.temperature...C." = "numeric",
                    "Rainfall..mm." = "numeric",
                    "Evaporation..mm." = "numeric",
                    "Sunshine..hours." = "numeric",
                    "Direction.of.maximum.wind.gust." = "character",
                    "Speed.of.maximum.wind.gust..km.h." = "numeric",
                    "Time.of.maximum.wind.gust" = "character",
                    "X9am.Temperature...C." = "numeric",
                    "X9am.relative.humidity...." = "numeric",
                    "X9am.cloud.amount..oktas." = "numeric",
                    "X9am.wind.direction" = "character",
                    "X9am.wind.speed..km.h." = "character",
                    "X9am.MSL.pressure..hPa." = "numeric",
                    "X3pm.Temperature...C." = "numeric",
                    "X3pm.relative.humidity...." = "numeric",
                    "X3pm.cloud.amount..oktas." = "numeric",
                    "X3pm.wind.direction" = "character",
                    "X3pm.wind.speed..km.h." = "character",
                    "X3pm.MSL.pressure..hPa." = "numeric")


# -- colnames (rename after read.csv)
# cols_technical <- c('Date',
#                     'MinTemp', 
#                     'MaxTemp',
#                     'Rainfall',
#                     'Evaporation',
#                     'Sunshine',
#                     'WindGustDir',
#                     'WindGustSpeed',
#                     'WindGustTime',
#                     'Temp9am',
#                     'Humidity9am',
#                     'Cloud9am',
#                     'WindDir9am',
#                     'WindSpeed9am',
#                     'Pressure9am',
#                     'Temp3pm',
#                     'Humidity3pm',
#                     'Cloud3pm',
#                     'WindDir3pm',
#                     'WindSpeed3pm',
#                     'Pressure3pm')

# -- colnames (rename after read.csv)
# lower_case_with_underscores to be compliant with PostgreSQL naming convention
cols_technical <- c('date',
                    'min_temp', 
                    'max_temp',
                    'rain_fall',
                    'evaporation',
                    'sunshine',
                    'wind_gust_dir',
                    'wind_gust_speed',
                    'wind_gust_time',
                    'temp_9am',
                    'humidity_9am',
                    'cloud_9am',
                    'wind_dir_9am',
                    'wind_speed_9am',
                    'pressure_9am',
                    'temp_3pm',
                    'humidity_3pm',
                    'cloud_3pm',
                    'wind_dir_3pm',
                    'wind_speed_3pm',
                    'pressure_3pm')

# -- station / location list
stations <- list(
  "IDCJDW2124" = "Sydney")


