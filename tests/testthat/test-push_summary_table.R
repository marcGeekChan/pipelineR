# library(testthat)
# library(DBI)
#
# test_that("push_summary_table inserts rows correctly", {
#   # Connect using environment variables
#   conn <- dbConnect(
#     RPostgres::Postgres(),
#     dbname   = Sys.getenv("PG_DB"),
#     host     = Sys.getenv("PG_HOST"),
#     port     = as.integer(Sys.getenv("PG_PORT")),
#     user     = Sys.getenv("PG_USER"),
#     password = Sys.getenv("PG_PASSWORD")
#   )
#
#   schema <- Sys.getenv("PG_SCHEMA")
#   table_name <- "pipeline_logs"
#
#   # Sample data
#   summary_tbl <- data.frame(
#     message    = c("Test 1", "Test 2"),
#     status     = c("OK", "FAIL"),
#     symbol     = c("AAPL", "GOOG"),
#     user_login = c("tester", "tester2"),
#     batch_id   = c(101, 102),
#     stringsAsFactors = FALSE
#   )
#
#   # Expect message output
#   expect_message(push_summary_table(conn, summary_tbl),
#                  "Logged 2 batch\\(es\\) into")
#
#   # Verify inserted data
#   result <- dbGetQuery(conn, paste0(
#     "SELECT * FROM ", schema, ".", table_name, " ORDER BY batch_id;"
#   ))
#
#   expect_equal(nrow(result), nrow(summary_tbl))
#   expect_equal(result$message, summary_tbl$message)
#   expect_equal(result$status, summary_tbl$status)
#   expect_equal(result$symbol, summary_tbl$symbol)
#   expect_equal(result$user_login, summary_tbl$user_login)
#   expect_equal(result$batch_id, summary_tbl$batch_id)
#
#   # Optional: clean up rows inserted in this test
#   dbExecute(conn, paste0(
#     "DELETE FROM ", schema, ".", table_name,
#     " WHERE batch_id IN (", paste(summary_tbl$batch_id, collapse = ","), ");"
#   ))
#
#   dbDisconnect(conn)
# })
