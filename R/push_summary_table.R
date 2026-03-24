library(DBI)

#' push_summary_table
#'
#' @param conn Connection
#' @param summary_tbl Summary Table
#'
#' @returns void
#' @export
#'
push_summary_table <- function(conn, summary_tbl) {
  table_name <- "pipeline_logs"

  # Get schema from environment variable
  schema <- Sys.getenv("PG_SCHEMA", "public")

  # Fully qualified table name
  fq_table <- DBI::SQL(paste0(DBI::dbQuoteIdentifier(conn, schema), ".",
                              DBI::dbQuoteIdentifier(conn, table_name)))

  # Insert each row in summary_tbl into the log table
  # Using parameterized queries to avoid SQL injection
  insert_query <- paste0(
    "INSERT INTO ", fq_table,
    " (message, status, symbol, user_login, batch_id) ",
    "VALUES ($1, $2, $3, $4, $5);"
  )

  stmt <- dbSendStatement(conn, insert_query)

  for (i in seq_len(nrow(summary_tbl))) {
    dbBind(stmt, unname(as.list(summary_tbl[i, ])))
  }

  dbClearResult(stmt)

  message("Logged ", nrow(summary_tbl), " batch(es) into ", schema, ".", table_name)
}
