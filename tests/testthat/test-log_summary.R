# library(testthat)
# library(tibble)
# library(dplyr)
#
# test_that("log_summary accumulates n_rows and updates message correctly", {
#   summary_tbl <- tibble(
#     timestamp  = Sys.time(),
#     message    = "",
#     status     = "",
#     symbol     = "",
#     user_login = "alice",
#     batch_id   = 1,
#     n_rows     = 0
#   )
#
#   result <- log_summary(
#     summary_tbl = summary_tbl,
#     n_rows = 5,
#     status = "ok",
#     symbols = c("AAPL", "MSFT")
#   )
#
#   # cumulative n_rows
#   expect_equal(result$n_rows, 5)
#
#   # message uses cumulative n_rows
#   expect_equal(result$message, "5 rows processed for this batch")
#
#   # status updated
#   expect_equal(result$status, "ok")
#
#   # symbols collapsed
#   expect_equal(result$symbol, "AAPL, MSFT")
# })
#
# test_that("log_summary keeps cumulative rows across multiple updates", {
#   summary_tbl <- tibble(
#     timestamp  = Sys.time(),
#     message    = "",
#     status     = "",
#     symbol     = "",
#     user_login = "bob",
#     batch_id   = 2,
#     n_rows     = 3
#   )
#
#   result <- log_summary(
#     summary_tbl = summary_tbl,
#     n_rows = 2,
#     status = "ok",
#     symbols = c("GOOG")
#   )
#
#   # cumulative addition
#   expect_equal(result$n_rows, 5)
#
#   # message reflects cumulative total
#   expect_equal(result$message, "5 rows processed for this batch")
# })
#
# test_that("log_summary handles zero total rows correctly", {
#   summary_tbl <- tibble(
#     timestamp  = Sys.time(),
#     message    = "",
#     status     = "",
#     symbol     = "",
#     user_login = "charlie",
#     batch_id   = 3,
#     n_rows     = 0
#   )
#
#   result <- log_summary(
#     summary_tbl = summary_tbl,
#     n_rows = 0,
#     status = "ok",
#     symbols = c("TSLA")
#   )
#
#   # still zero
#   expect_equal(result$n_rows, 0)
#
#   # message for zero total rows
#   expect_equal(result$message, "No new rows to insert")
#
#   # symbol formatting
#   expect_equal(result$symbol, "TSLA")
# })
#
# test_that("log_summary overwrites status with error", {
#   summary_tbl <- tibble(
#     timestamp  = Sys.time(),
#     message    = "",
#     status     = "ok",
#     symbol     = "",
#     user_login = "david",
#     batch_id   = 4,
#     n_rows     = 4
#   )
#
#   result <- log_summary(
#     summary_tbl = summary_tbl,
#     n_rows = 1,
#     status = "err",
#     symbols = c("AMZN", "NFLX")
#   )
#
#   # cumulative rows
#   expect_equal(result$n_rows, 5)
#
#   # status overwritten
#   expect_equal(result$status, "err")
#
#   # message reflects cumulative
#   expect_equal(result$message, "5 rows processed for this batch")
#
#   # symbols collapsed
#   expect_equal(result$symbol, "AMZN, NFLX")
# })
