
library(plumber)


# ------------------------------------------------------------------------------
# Authentication
# ------------------------------------------------------------------------------

# -- Helper function:
# Adds authentication to a given set of paths 
# (if paths = NULL, apply to all)
add_auth <- function(x, paths = NULL) {
  
  # -- Adds the components element to openapi (specifies auth method)
  x[["components"]] <- list(
    securitySchemes = list(
      ApiKeyAuth = list(
        type = "apiKey",
        `in` = "header",
        name = "X-API-KEY",
        description = "Here goes something")))
  
  # -- Add the security element to each path
  # Eg add the following yaml to each path
  # ...
  # paths:
  #   /ping:
  #     get:
  #       security:               #< THIS
  #         - ApiKeyAuth: []      #< THIS
  
  if (is.null(paths)) paths <- names(x$paths)
  for (path in paths) {
    nn <- names(x$paths[[path]])
    for (p in intersect(nn, c("get", "head", "post", "put", "delete"))) {
      x$paths[[path]][[p]] <- c(
        x$paths[[path]][[p]],
        list(security = list(list(ApiKeyAuth = vector()))))}}
  
  # -- return
  x
  
}


# ------------------------------------------------------------------------------
# Launch API
# ------------------------------------------------------------------------------

pr("plumber.R") %>%
  # -- add the authentication
  pr_set_api_spec(add_auth) %>%  
  # -- run the API
  pr_run(port = 10000, host = "0.0.0.0")

