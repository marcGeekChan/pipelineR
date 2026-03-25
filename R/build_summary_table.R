#'
#' build_summary_table
#'
#' @param user_login Name of the user
#' @param batch_id Batch Id
#' @param n_rows New Rows
#' @param symbols list of symbols
#'
#' @returns summary table
#' @export
#' @import tibble
#'
build_summary_table <- function(user_login, batch_id, n_rows, symbols) {
  # Determine message based on number of rows processed
  message <- if (n_rows > 0) {
    paste(n_rows, "rows processed for this batch")
  } else {
    "No new rows to insert"
  }

  # Determine status
  status <- "err"

  # Collapse symbols into comma-separated string
  symbol_list <- paste(symbols, collapse = ", ")

  # Build tibble
  summary_tbl <- tibble(
    message    = message,
    status     = status,
    symbol     = symbol_list,
    user_login = user_login,
    n_rows     = n_rows,
    batch_id   = batch_id
  )

  return(summary_tbl)
}
