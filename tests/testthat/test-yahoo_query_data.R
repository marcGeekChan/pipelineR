# library(testthat)
# library(tidyquant)
#
# test_that("yahoo_query_data returns a tibble with expected columns", {
#
#   data <- yahoo_query_data(
#     ticker = "AAPL",
#     start_date = "2026-01-03",
#     end_date = "2026-01-10"
#   )
#
#   expect_s3_class(data, "tbl_df")
#
#   expect_true(all(c(
#     "date", "open", "high", "low", "close", "volume", "adjusted"
#   ) %in% colnames(data)))
# })
#
# test_that("yahoo_query_data returns non-empty data", {
#
#   data <- yahoo_query_data(
#     ticker = "AAPL",
#     start_date = "2026-01-03",
#     end_date = "2026-01-10"
#   )
#
#   expect_gt(nrow(data), 0)
# })
#
# test_that("yahoo_query_data respects date range", {
#
#   start_date <- "2026-01-03"
#   end_date   <- "2026-01-10"
#
#   data <- yahoo_query_data("AAPL", start_date, end_date)
#
#   expect_true(min(data$date) >= as.Date(start_date))
#   expect_true(max(data$date) <= as.Date(end_date))
# })
#
# test_that("yahoo_query_data handles invalid ticker gracefully", {
#
#   data <- yahoo_query_data(
#     ticker = "INVALID_TICKER_123",
#     start_date = "2026-01-01",
#     end_date = "2026-01-10"
#   )
#
#   expect_true(nrow(data) == 0 || is.null(data))
# })
