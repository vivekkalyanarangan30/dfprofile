library(testthat)

test_that("html report is getting generated", {
  library(rmarkdown)
  report_loc <- "C:/Users/FGB3140/Desktop/output.html"
  profile_report(mtcars, report_loc)
  expect_equal(file.exists(report_loc), T)
})
