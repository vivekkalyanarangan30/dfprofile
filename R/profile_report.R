library(rmarkdown)
library(dplyr)
library(ggplot2)

#' Generates profile reports from a DataFrame. The existing implementations are great but a little basic for serious exploratory data analysis.
#'
#' @param df The dataframe to generate the EDA report
#' @param output_file_path Provide the output file path to store the html report
#' @param missing_threshold Flag variables as "Missing" in case this threshold is crossed. This should be between 0 and 1
#' @param cardinality_threshold Flag variables as "High Cardinality" in case this threshold is crossed. This should be between 0 and 1
#' cardinality_threshold Flag variables as "Highly Correlated" in case this threshold is crossed. This should be between 0 and 1
#' @return NULL. The output HTML file is written
#' @examples
#' profile_report(mtcars,"report.html")
#' profile_report(mtcars,"/path/to/report.html",missing_threshold=0.30,cardinality_threshold=50,skewness_threshold=20,correlation_threshold=0.8)
profile_report <- function(df,output_file_path,missing_threshold=0.30,
                           cardinality_threshold=50,skewness_threshold=20,
                           correlation_threshold=0.8){
  if(class(df)=="data.frame"){
    output_format_extn <- "html_document"

    render(input=system.file("rmd", "report.Rmd", package = "dfprofile"), output_format=output_format_extn,
           params=list(df = df, missing_threshold = missing_threshold,
                       cardinality_threshold=cardinality_threshold,
                       skewness_threshold=skewness_threshold),
           output_file=output_file_path)
  } else{
    stop("You need to pass an instance of data.frame!")
  }
}


