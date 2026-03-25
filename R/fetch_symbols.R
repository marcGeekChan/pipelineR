#' Fetch symbols
#'
#' @return List of symbols (class `"String"`)
#'
#' @import DBI
#' @import RPostgres
#' @export
#'

fetch_symbols <- function(con) {
  data <- DBI::dbGetQuery(con, "SELECT index_ts,symbol FROM sp500.info")
  return(data)
}
