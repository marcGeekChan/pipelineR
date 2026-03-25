#' log_summary
#'
#' @param summary_tbl Summary table
#' @param n_rows New rows
#' @param status Status
#' @param symbols List of symbols
#'
#' @returns summary table
#' @importFrom tibble tibble
#' @export
#'
log_summary <- function(summary_tbl, n_rows, status, symbols ) {
  # Collapse symbols into > separated string
  symbol_list <- paste(symbols, collapse = ", ")

  # Build tibble
  summary_tbl$n_rows <- summary_tbl$n_rows + n_rows
  summary_tbl$status <- status
  summary_tbl$symbol <- symbol_list

  summary_tbl$message <- if (summary_tbl$n_rows > 0) {
      paste(summary_tbl$n_rows, "rows processed for this batch")
    } else {
      "No new rows to insert"
    }

  return(summary_tbl)
}
