library(testthat)
library(dplyr)
library(tibble)

test_that("build_summary_table returns correct tibble structure", {
  user <- "alice"
  batch <- 1
  n_rows <- 5
  symbols <- c("AAPL", "MSFT", "NIN")

  summary <- build_summary_table(user_login = user,
                                 batch_id = batch,
                                 n_rows = n_rows,
                                 symbols = symbols)

  # Check that result is a tibble
  expect_s3_class(summary, "tbl_df")

  # Check column names
  expect_equal(colnames(summary), c("message", "status", "symbol", "user_login", "n_rows", "batch_id"))

  # Check message logic
  expect_equal(summary$message, paste(n_rows, "rows processed for this batch"))

  # Check status is always "err" (current function logic)
  expect_equal(summary$status, "err")

  # Check symbols collapsed correctly
  expect_equal(summary$symbol, "AAPL, MSFT, NIN")

  # Check user_login and batch_id
  expect_equal(summary$user_login, user)
  expect_equal(summary$batch_id, batch)
})

test_that("build_summary_table handles zero rows correctly", {
  user <- "bob"
  batch <- 2
  n_rows <- 0
  symbols <- c("GOOG")

  summary <- build_summary_table(user_login = user,
                                 batch_id = batch,
                                 n_rows = n_rows,
                                 symbols = symbols)

  expect_equal(summary$message, "No new rows to insert")
  expect_equal(summary$status, "err")
  expect_equal(summary$symbol, "GOOG")
  expect_equal(summary$user_login, user)
  expect_equal(summary$batch_id, batch)
})
