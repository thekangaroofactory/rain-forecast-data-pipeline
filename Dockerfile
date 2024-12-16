# Base image
FROM rstudio/plumber

# -- update 
RUN apt-get update && apt-get install libpq5 -y

# Install R packages
RUN R -e 'install.packages(c("readr", "DBI", "RPostgres", "stringr", "RCurl"))'

# Make a directory in the container
RUN mkdir /home/api

# Copy code
COPY R /home/api/R
COPY *.R /home/api

# -- define working directory
WORKDIR /home/api

# Define port (Render sets 10000 by default)
EXPOSE 10000

# Run code
CMD ["plumber.R"]


# -- build docker image:
# docker build -t rain-forecast-api .

# -- run docker image:
# docker run -p 8000:8000 rain-forecast-api

# -- details in docker
# set port 8000 (:8000)
# set data mount, select folder, mapp on /home/data in 'container' field
