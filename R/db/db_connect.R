

db_connect <- function(){
  
  # -- connect & return
  DBI::dbConnect(RPostgres::Postgres(),
                 dbname = "postgres",
                 host = "aws-0-eu-west-3.pooler.supabase.com",
                 port = 6543,
                 user = "postgres.njzgbmzxcucpxzzggeft",
                 password = "fysBQo0hRMJSTCSZ")
  
}
