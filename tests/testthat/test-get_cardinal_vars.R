library(testthat)

test_that("test cardinal with custom threshold", {
  cardinal_vars <- get_cardinal_vars(iris, cardinality_threshold = 2)
  output <- structure(list(cardinalities = 3L, Column.Name = "Species"), .Names = c("cardinalities",
                                                                                    "Column.Name"), row.names = "Species", class = "data.frame")
  expect_equal(cardinal_vars, output)
})

test_that("test cardinal with default threshold", {
  cardinal_df <- data.frame(Var1=paste("Val", 1:100), Var2=rep(paste("Val", 1:10),10))
  cardinal_vars <- get_cardinal_vars(cardinal_df)
  output <- structure(list(cardinalities = 100L, Column.Name = "Var1"), .Names = c("cardinalities",
                                                                                   "Column.Name"), row.names = "Var1", class = "data.frame")
  expect_equal(cardinal_vars, output)
})

test_that("test cardinal with default threshold for no high cardinalities", {
  cardinal_vars <- get_cardinal_vars(iris)
  output <- structure(list(Column.Name = character(0), cardinalities = character(0)), .Names = c("Column.Name",
                                                                                                 "cardinalities"), row.names = integer(0), class = "data.frame")
  expect_equal(cardinal_vars, output)
})
