#' yahoo_query_data
#'
#' @param ticker Ticker
#' @param start_date Start date
#' @param end_date End date
#'
#' @returns data
#' @export
#' @importFrom tidyquant tq_get
#'
yahoo_query_data <- function(ticker, start_date, end_date) {

  data <- tryCatch(
    tidyquant::tq_get(
      x = ticker,
      from = start_date,
      to = end_date,
      get = "stock.prices"
    ),
    error = function(e) return(NULL)
  )

  # Handle NA case explicitly
  if (is.null(data) || (length(data) == 1 && is.na(data))) {
    return(NULL)
  }

  return(data)
}
