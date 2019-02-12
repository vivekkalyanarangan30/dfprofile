library(testthat)

test_that("get var types mtcars", {
  var_df <- get_var_types(mtcars)
  output <- structure(list(`Data types` = structure(1L, .Label = "numeric", class = "factor"),
                           Frequency = "11"), .Names = c("Data types", "Frequency"), row.names = c(NA,
                                                                                                   -1L), class = "data.frame")
  expect_equal(var_df, output)
})
