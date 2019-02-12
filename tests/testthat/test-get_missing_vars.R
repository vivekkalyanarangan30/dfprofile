library(testthat)

test_that("missing vars with custom threshold", {
  miss_df <- get_missing_vars(airquality, missing_threshold = 0.2)
  output <- structure(list(perc_missing_report = 0.241830065359477, Column.Name = "Ozone"), .Names = c("perc_missing_report",
                                                                                                       "Column.Name"), row.names = "Ozone", class = "data.frame")
  expect_equal(miss_df, output)
})

test_that("no missing vars", {
  miss_df <- get_missing_vars(mtcars)
  output <- structure(list(Column.Name = character(0), perc_missing_report = character(0)), .Names = c("Column.Name",
                                                                                                       "perc_missing_report"), row.names = integer(0), class = "data.frame")
  expect_equal(miss_df, output)
})
