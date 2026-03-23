#' Fetch symbols
#'
#' @return List of symbols (class `"String"`)
#' @export
#'
#' }

fetch_symbols <- function() {
  con <- connect_db()
  data <- DBI::dbGetQuery(con, "SELECT symbol FROM sp500.info")
  dbDisconnect(con)
  return(data)
}
