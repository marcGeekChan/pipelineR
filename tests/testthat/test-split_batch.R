library(testthat)

test_that("split_batch splits data into correct batch sizes", {
  data <- 1:10
  result <- split_batch(data, 3)

  expect_length(result, 4)  # 10 elements -> 4 batches (3,3,3,1)
  expect_equal(result[[1]], c(1, 2, 3))
  expect_equal(result[[2]], c(4, 5, 6))
  expect_equal(result[[3]], c(7, 8, 9))
  expect_equal(result[[4]], c(10))
})
