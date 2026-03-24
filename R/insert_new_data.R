library(DBI)
library(RPostgres)

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
  fq_table <- DBI::SQL(paste0(DBI::dbQuoteIdentifier(conn, schema), ".",
                              DBI::dbQuoteIdentifier(conn, table_name)))

  data$symbol <- index_ts
  # Prepare an UPSERT query (insert new rows, ignore duplicates based on unique constraint)
  # Assumes table has unique constraint on (ticker, date)
  insert_query <- paste0(
    "INSERT INTO ", fq_table, " (index_ts, date, metric, value) ",
    "VALUES ($1, $2, $3, $4) ",
    "ON CONFLICT (index_ts, date, metric) DO NOTHING;"
  )

  # Prepare statement for efficiency
  stmt <- dbSendStatement(conn, insert_query)

  # Loop through rows and bind parameters
  for (i in seq_len(nrow(data))) {
    dbBind(stmt, unname(as.list(data[i, required_cols])))
  }

  # Execute all inserts
  dbClearResult(stmt)

  message(nrow(data), " rows processed for insertion into ", schema, ".", table_name)
  return(data)
}
