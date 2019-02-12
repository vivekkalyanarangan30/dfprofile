library(testthat)

test_that("warnings for mtcars", {
  warn_df <- get_full_warnings(mtcars)
  output <- structure(list(Column_Name = structure(c(1L, 1L, 2L), .Label = c("cyl",
                                                                             "disp"), class = "factor"), Type = structure(c(1L, 1L, 1L), .Label = "Warning", class = "factor"),
                           Comments = structure(1:3, .Label = c("Is highly correlated with disp(p=0.9)",
                                                                "Is highly correlated with hp(p=0.83)", "Is highly correlated with wt(p=0.89)"
                           ), class = "factor")), .Names = c("Column_Name", "Type",
                                                             "Comments"), row.names = c(NA, -3L), class = "data.frame")
  expect_equal(warn_df, output)
})
