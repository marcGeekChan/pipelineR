library(testthat)
library(DBI)
library(tidyr)

test_that("insert_new_data works with real Yahoo Finance data", {
  conn <- connect_db()  # uses your env vars

  symbols <- head(fetch_symbols(conn),1)

  print(symbols$index_ts)

  # Query Yahoo Finance for specfic period
  raw_data <- yahoo_query_data(symbols$symbol, start_date = "2019-01-08",
                               end_date = "2019-01-13")

  # Format into long format for insertion
  formatted_data <- format_data(raw_data)

  # Insert into the real schema table
  inserted <- dbGetQuery(conn, paste0(
    "SELECT COUNT(*) AS n FROM ", Sys.getenv("PG_SCHEMA"), ".data_sp500"
  ))

  expect_message(insert_new_data(conn, symbols$index_ts, formatted_data), "rows processed")

  inserted <- dbGetQuery(conn, paste0(
    "SELECT COUNT(*) AS n FROM ", Sys.getenv("PG_SCHEMA"), ".data_sp500"
  ))
  print(inserted)

  # Optional: check at least some rows were inserted
  inserted <- dbGetQuery(conn, paste0(
    "SELECT COUNT(*) AS n FROM ", Sys.getenv("PG_SCHEMA"), ".data_sp500"
  ))
  expect_true(inserted$n > 0)

  # Test re-inserting same data does not create duplicates
  expect_message(insert_new_data(conn, symbols$index_ts, formatted_data), "rows processed")
  inserted_after <- dbGetQuery(conn, paste0(
    "SELECT COUNT(*) AS n FROM ", Sys.getenv("PG_SCHEMA"), ".data_sp500"
  ))
  expect_equal(inserted$n, inserted_after$n)  # no new rows added

  dbDisconnect(conn)
})
