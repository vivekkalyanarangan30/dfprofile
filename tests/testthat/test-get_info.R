library(testthat)

test_that("get info on mtcars", {
  info_df <- get_info(mtcars)
  output <- structure(list(Properties = structure(c(2L, 1L, 3L, 4L), .Label = c("Number of observations",
                                                                                "Number of variables", "Total missing (%)", "Total size in memory"
  ), class = "factor"), Values = structure(c(3L, 4L, 1L, 2L), .Label = c("0",
                                                                         "0.01 MB", "11", "32"), class = "factor")), .Names = c("Properties",
                                                                                                                                "Values"), row.names = c(NA, -4L), class = "data.frame")
  expect_equal(info_df, output)
})
