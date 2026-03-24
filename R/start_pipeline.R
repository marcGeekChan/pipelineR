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
    summary_table <- build_summary_table('test_user',counter,0,batch_symbols)
    for (index in seq_along(batch_splitter)) {
      ticker <- batch_splitter[index]
      print(ticker)
      yahoo_world <- yahoo_query_data(ticker$symbol, from_str, to_str)
      print(yahoo_world)
      status <- "ok"
      n_rows <- 0
      if (is.null(yahoo_world)) {
        status <- "err"
      } else {
        formatted_data <- format_data(yahoo_world)
        data <- insert_new_data(con, ticker$index_ts, formatted_data)
        n_rows <- nrow(data)
      }
      log_summary(summary_table,n_rows,status,batch_symbols)
    }
    push_summary_table(con,summary_table)
    counter <- counter + 1
  }
  dbDisconnect(con)
}
