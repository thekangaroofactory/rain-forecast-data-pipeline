
# -- base image
FROM r-base:latest

# -- install git & other dependencies
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git && \
    apt-get install -y libpq5 libssl-dev libffi-dev && \
    apt-get install -y libsodium-dev libpq-dev libssl-dev libcurl4-openssl-dev

# -- install R packages
RUN R -e 'install.packages(c("plumber", "readr", "DBI", "RPostgres", "stringr", "RCurl", "reticulate", "keras"))'

# -- install python
RUN R -e 'reticulate::install_python(version = "3.11:latest")'

# -- install keras
RUN R -e 'keras::install_keras()'

# ------------------------------------------------

# -- Make a directory in the container
RUN mkdir /home/api /home/data

# -- Copy files
COPY data /home/data

# -- Copy code
COPY R /home/api/R
COPY *.R /home/api

# -- define working directory
WORKDIR /home/api

# Define port (Render sets 10000 by default)
EXPOSE 10000

# Run code to start the API
CMD Rscript launch_api.R

# -- build docker image:
# docker build -t rain-forecast-api .

# -- run docker image:
# docker run -p 8000:8000 rain-forecast-api

# -- details in docker
# set port 8000 (:8000)
# set data mount, select folder, mapp on /home/data in 'container' field
