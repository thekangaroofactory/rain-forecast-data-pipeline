
library(plumber)

pr("plumber.R") %>%
  pr_run(port = 10000, host = "0.0.0.0")
