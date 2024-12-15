# Base image
FROM rstudio/plumber

# Install R packages
# RUN R -e 'install.packages(c("data.table", "mlr3", "mlr3misc", "mlr3pipelines"))'

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