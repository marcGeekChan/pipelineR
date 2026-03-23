library(testthat)
library(DBI)

test_that("fetch_symbols returns a data frame with a symbol column", {
  result <- fetch_symbols()

  expect_type(result, "list")        # data.frame is a list underneath
  expect_s3_class(result, "data.frame")
  expect_true("symbol" %in% names(result))
  expect_true(nrow(result) > 0)
})
