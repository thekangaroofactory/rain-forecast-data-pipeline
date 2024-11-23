
# -- 
# This is the global param file
# --

# -- init & source code
for(nm in list.files("R", full.names = T))
  source(nm)
rm(nm)

# -- define path
path <- list("raw" = "E:/Datasets/rain-forecast/raw")

