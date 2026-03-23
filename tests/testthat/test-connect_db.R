library(testthat)
library(DBI)

test_that("connect_db returns a valid DB connection", {
  con <- connect_db()

  # Check it's a DBI connection
  expect_true(inherits(con, "DBIConnection"))

  # Check the connection is valid
  expect_true(dbIsValid(con))

  # Clean up
  dbDisconnect(con)
})
