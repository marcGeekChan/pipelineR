library(DBI)

#' start_pipeline
#'
#' @returns void
#' @export
start_pipeline <- function (from, to, batch_size) {
  from_str <- as.character(from)
  to_str <- as.character(to)

  con <- connect_db()
  symbols <- fetch_symbols(con)
  batch_splitted <- split_batch(symbols,batch_size)
  counter <- 1
  for (batch_splitter in batch_splitted) {

    batch_symbols <- list()
    summary_table <- build_summary_table('test_user', counter, 0, batch_symbols)

    for (i in seq_len(nrow(batch_splitter))) {

      index_ts <- as.character(batch_splitter$index_ts[i])  # ✅ single value
      symbol   <- batch_splitter$symbol[i]                  # ✅ single value

      batch_symbols <- append(batch_symbols, symbol)
      yahoo_world <- yahoo_query_data(symbol, from_str, to_str)

      status <- "ok"
      n_rows <- 0

      if (is.null(yahoo_world)) {
        status <- "err"
      } else {
        formatted_data <- format_data(yahoo_world)
        data <- insert_new_data(con, index_ts, formatted_data)
        n_rows <- nrow(data)
      }

      summary_table <- log_summary(summary_table, n_rows, status, batch_symbols)
    }

    push_summary_table(con, summary_table)
    counter <- counter + 1
  }
  DBI::dbDisconnect(con)
}
