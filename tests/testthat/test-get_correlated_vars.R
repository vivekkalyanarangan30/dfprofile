library(testthat)

test_that("highly correlated default", {
  corr_df <- get_correlated_vars(mtcars)
  output <- structure(list(Var1 = structure(c(1L, 1L, 2L), .Label = c("cyl",
                                                                      "disp"), class = "factor"), Var2 = structure(1:3, .Label = c("disp",
                                                                                                                                   "hp", "wt"), class = "factor"), Value = c(0.9, 0.83, 0.89)), row.names = c(NA,
                                                                                                                                                                                                              -3L), class = c("grouped_df", "tbl_df", "tbl", "data.frame"), vars = c("Var1",
                                                                                                                                                                                                                                                                                     "Var2"), drop = TRUE, .Names = c("Var1", "Var2", "Value"), indices = list(
                                                                                                                                                                                                                                                                                       0L, 1L, 2L), group_sizes = c(1L, 1L, 1L), biggest_group_size = 1L, labels = structure(list(
                                                                                                                                                                                                                                                                                         Var1 = structure(c(1L, 1L, 2L), .Label = c("cyl", "disp"), class = "factor"),
                                                                                                                                                                                                                                                                                         Var2 = structure(1:3, .Label = c("disp", "hp", "wt"), class = "factor")), row.names = c(NA,
                                                                                                                                                                                                                                                                                                                                                                                 -3L), class = "data.frame", vars = c("Var1", "Var2"), drop = TRUE, .Names = c("Var1",
                                                                                                                                                                                                                                                                                                                                                                                                                                                               "Var2")))
  expect_equal(corr_df, output)
})

test_that("highly correlated custom", {
  corr_df <- get_correlated_vars(mtcars, correlation_threshold = 0.9)
  output <- structure(list(Var1 = structure(1L, .Label = "cyl", class = "factor"),
                           Var2 = structure(1L, .Label = "disp", class = "factor"),
                           Value = 0.9), row.names = c(NA, -1L), class = c("grouped_df",
                                                                           "tbl_df", "tbl", "data.frame"), vars = c("Var1", "Var2"), drop = TRUE, .Names = c("Var1",
                                                                                                                                                             "Var2", "Value"), indices = list(0L), group_sizes = 1L, biggest_group_size = 1L, labels = structure(list(
                                                                                                                                                               Var1 = structure(1L, .Label = "cyl", class = "factor"), Var2 = structure(1L, .Label = "disp", class = "factor")), row.names = c(NA,
                                                                                                                                                                                                                                                                                               -1L), class = "data.frame", vars = c("Var1", "Var2"), drop = TRUE, .Names = c("Var1",
                                                                                                                                                                                                                                                                                                                                                                             "Var2")))
  expect_equal(corr_df, output)
})

test_that("highly correlated no numeric", {
  corr_df <- get_correlated_vars(as.data.frame(Titanic))
  output <- structure(list(Var1 = character(0), Var2 = character(0), Value = numeric(0)), .Names = c("Var1",
                                                                                                     "Var2", "Value"), row.names = integer(0), class = "data.frame")
  expect_equal(corr_df, output)
})
