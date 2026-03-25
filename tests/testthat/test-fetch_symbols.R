# library(testthat)
# library(DBI)
#
# test_that("fetch_symbols returns a data frame with a symbol column", {
#   con <- connect_db()
#   result <- fetch_symbols(con)
#   dbDisconnect(con)
#
#   expect_type(result, "list")        # data.frame is a list underneath
#   expect_s3_class(result, "data.frame")
#   expect_true("index_ts" %in% names(result))
#   expect_true("symbol" %in% names(result))
#   expect_true(nrow(result) > 0)
# })
