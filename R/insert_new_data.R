#' @importFrom DBI SQL dbQuoteIdentifier dbSendStatement dbBind dbClearResult
#'
#' insert_new_data
#'
#' @param conn Connection
#' @param data Data
#' @param table_name Table name
#'
#' @export
#'
insert_new_data <- function(conn, index_ts, data) {
  table_name <- "data_sp500"

  # Read schema from environment variable
  schema <- Sys.getenv("PG_SCHEMA", "public")

  # Ensure data has required columns
  required_cols <- c("symbol", "date", "field", "value")
  if (!all(required_cols %in% colnames(data))) {
    stop("Data must contain columns: ", paste(required_cols, collapse = ", "))
  }

  # Convert date to character to match PostgreSQL date format
  data$date <- as.character(data$date)

  # Fully qualified table name with schema
  fq_table <- SQL(paste0(dbQuoteIdentifier(conn, schema), ".",
                         dbQuoteIdentifier(conn, table_name)))

  data$symbol <- index_ts

  insert_query <- paste0(
    "INSERT INTO ", fq_table, " (index_ts, date, metric, value) ",
    "VALUES ($1, $2, $3, $4) ",
    "ON CONFLICT (index_ts, date, metric) DO NOTHING;"
  )

  stmt <- dbSendStatement(conn, insert_query)

  for (i in seq_len(nrow(data))) {
    dbBind(stmt, unname(as.list(data[i, required_cols])))
  }

  dbClearResult(stmt)

  message(nrow(data), " rows processed for insertion into ", schema, ".", table_name)
  return(data)
}
