library(testthat)

test_that("html report is getting generated", {
  in_df <- data.frame(Var1=rep(1,10), Var2=1:10)
  uniq_df <- get_unique_vars(in_df)
  output <- list(structure(list(unique_count = 1L, Column.Name = "Var1"), .Names = c("unique_count",
                                                                                     "Column.Name"), row.names = "Var1", class = "data.frame"), 1)
  expect_equal(uniq_df, output)
})
