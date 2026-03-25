library(testthat)
library(dplyr)
library(tidyr)

# Mock data to avoid querying Yahoo in tests
mock_data <- tibble::tibble(
  date = as.Date("2023-01-01") + 0:1,
  open = c(100, 101),
  high = c(105, 106),
  low = c(99, 100),
  close = c(104, 105),
  volume = c(1000, 1200),
  adjusted = c(104, 105)
)

test_that("format_data returns a tibble in long format", {
  formatted <- format_data(mock_data)

  expect_s3_class(formatted, "tbl_df")
  expect_true(all(c("date", "field", "value") %in% colnames(formatted)))
})

test_that("format_data preserves all values", {
  formatted <- format_data(mock_data)

  # Check total number of rows: original rows * 6 OHLCV columns
  expect_equal(nrow(formatted), nrow(mock_data) * 6)

  # Check all original values appear in the 'value' column
  expect_true(all(c(mock_data$open, mock_data$high, mock_data$low,
                    mock_data$close, mock_data$adjusted, mock_data$volume) %in% formatted$value))
})

test_that("format_data retains date information", {
  formatted <- format_data(mock_data)

  expect_true(all(formatted$date %in% mock_data$date))
})

test_that("format_data works with single row", {
  single_row <- mock_data[1, ]
  formatted <- format_data(single_row)

  expect_equal(nrow(formatted), 6) # one row * 6 OHLCV columns
  expect_true(all(formatted$date == single_row$date))
})
