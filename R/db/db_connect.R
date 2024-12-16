

db_connect <- function(){
  
  # -- get env variables
  dbname <- Sys.getenv("DB_NAME")
  host <- Sys.getenv("DB_HOST")
  port <- Sys.getenv("DB_PORT")
  user <- Sys.getenv("DB_USER")
  password <- Sys.getenv("DB_PASSWORD")
  
  # -- connect & return
  DBI::dbConnect(RPostgres::Postgres(),
                 dbname = dbname,
                 host = host,
                 port = port,
                 user = user,
                 password = password)
  
}
