#' @importFrom stats cor filter
#' @import dplyr
#' @importFrom utils object.size

requireNamespace("knitr", quietly = TRUE)
requireNamespace("kableExtra", quietly = TRUE)
requireNamespace("moments", quietly = TRUE)
requireNamespace("dplyr", quietly = TRUE)
requireNamespace("reshape2", quietly = TRUE)
requireNamespace("ggplot2", quietly = TRUE)

missing_threshold_pkg_default=0.30
cardinality_threshold_pkg_default=50
skewness_threshold_pkg_default=20
correlation_threshold_pkg_default=0.8

usethis::use_data(missing_threshold_pkg_default,
         cardinality_threshold_pkg_default,
         skewness_threshold_pkg_default,
         correlation_threshold_pkg_default,
         internal = T, overwrite = T)

.kexpand <- function(ht, cap, .p1, counter) {
  .p1 <- .p1
  ftext <- "```{r message=FALSE,warning=FALSE,results='asis', %s, fig.height=%s, fig.cap='%s'}\n .p1 \n```"

  paste(knit(text = knit_expand(text =
                                  sprintf(ftext, counter, ht, cap)
  )))}

#' Returns meta information of the dataframe like Number of variables, Number of observations, Total missing percentage, Total size in memory
#'
#' @export
#' @param df The dataframe to generate the EDA report
#' @return df_info The output dataframe containing the Property and a corresponding value
#' @examples
#' get_info(df)
get_info <- function(df){
  df_info <- data.frame("Properties" = c("Number of variables", "Number of observations", "Total missing (%)", "Total size in memory"),
                        "Values"=c(ncol(df), nrow(df), round((sum(is.na(df))/prod(dim(df)))*100,1), paste( round(object.size(df) / 1000000, 2), "MB", sep=" ") ) )
  df_info
}

#' Returns meta information of the dataframe - The distribution of variables by type (factor, integer, etc.)
#'
#' @export
#' @param df The dataframe to generate the EDA report
#' @return var_summary The output dataframe containing the various data types and their corresponding frequencies (number of variables)
#' @examples
#' get_var_types(df)
get_var_types <- function(df){
  var_types <- data.frame(sapply(df, class))
  names(var_types) <- c("Types")
  var_summary <- data.frame(table(var_types$Types))
  names(var_summary) <- c("Data types", "Frequency")
  var_summary$Frequency <- as.character(var_summary$Frequency)
  var_summary
}

#' Returns missing information of the dataframe - The distribution of variables by type (factor, integer, etc.)
#'
#' @export
#' @param df The dataframe to generate the EDA report
#' @param missing_threshold OPTIONAL. The threshold based on which variables will be flagged as "Missing". Default value is 0.3
#' @return perc_missing_report The output dataframe containing the column name and the percentage of missing values
#' @examples
#' get_missing_vars(df)
#' get_missing_vars(df, missing_threshold=0.3)
get_missing_vars <- function(df,missing_threshold=missing_threshold_pkg_default){
  perc_missing <- sapply(df,function(x){sum(is.na(x)) / length(x)})
  perc_missing_report <- perc_missing[perc_missing > missing_threshold]
  if(length(perc_missing_report) > 0){
    column_names <- names(perc_missing_report)
    perc_missing_report <- data.frame(perc_missing_report)
    perc_missing_report$Column.Name <- column_names
  }else{
    perc_missing_report <- data.frame(Column.Name=character(),
                                      perc_missing_report=character(),
                                      stringsAsFactors=FALSE)
  }
  perc_missing_report
}

#' Returns cardinality information of the dataframe - The cardinalities for the variables (applies to factor variables)
#'
#' @export
#' @param df The dataframe to generate the EDA report
#' @param cardinality_threshold OPTIONAL. The threshold based on which variables will be flagged as "High Cardinality". Default value is 50
#' @return cardinalities The output dataframe containing the column name and the cardinality
#' @examples
#' get_cardinal_vars(df)
#' get_cardinal_vars(df, cardinality_threshold=0.3)
get_cardinal_vars <- function(df,cardinality_threshold=cardinality_threshold_pkg_default){
  df_factor <- df %>% Filter(f = is.factor)
  cardinalities <- sapply(df_factor, function(x){length(unique(x[!is.na(x)]))})
  cardinalities <- cardinalities[cardinalities > cardinality_threshold]
  if(length(cardinalities) > 0){
    column_names <- names(cardinalities)
    cardinalities <- data.frame(cardinalities)
    cardinalities$Column.Name <- column_names
  }else{
    cardinalities <- data.frame(Column.Name=character(),
                                cardinalities=character(),
                                stringsAsFactors=FALSE)
  }
  cardinalities
}

#' Returns information of the dataframe - The variables which have a constant value
#'
#' @export
#' @param df The dataframe to generate the EDA report
#' @return list(unique_count, values) A list containing two elements - a dataframe with the column name and the unique_count and another named list of the variables and their constant values.
#' @examples
#' get_unique_vars(df)
get_unique_vars <- function(df){
  unique_count <- sapply(df, function(x){length(unique(x[!is.na(x)]))})
  unique_count <- unique_count[unique_count == 1]
  if(length(unique_count) > 0){
    column_names <- names(unique_count)
    values <- df[1,column_names]
    unique_count <- data.frame(unique_count)
    unique_count$Column.Name <- column_names
  } else{
    unique_count <- data.frame(Column.Name=character(),
                               unique_count=character(),
                               stringsAsFactors=FALSE)
    values <- NULL
  }
  list(unique_count, values)
}

#' Returns skewness information of the dataframe
#'
#' @export
#' @param df The dataframe to generate the EDA report
#' @param skewness_threshold OPTIONAL. The threshold based on which variables will be flagged as "Highly Skewed". Default value is 20
#' @return list(skewness_vars, values) A list containing two elements - a dataframe with the column name and the skewness and another named list of the variables and their skewness values.
#' @examples
#' get_skewed_vars(df)
#' get_skewed_vars(df, skewness_threshold=20)
get_skewed_vars <- function(df,skewness_threshold=skewness_threshold_pkg_default){
  df_numeric <- df %>% Filter(f = is.numeric)
  skewness_vars <- sapply(df_numeric, function(x){moments::skewness(x,na.rm=T)})
  skewness_vars <- skewness_vars[(skewness_vars > skewness_threshold)&(!is.na(skewness_vars))]
  if(length(skewness_vars) > 0){
    column_names <- names(skewness_vars)
    values <- skewness_vars
    skewness_vars <- data.frame(skewness_vars)
    skewness_vars$Column.Name <- column_names
  } else{
    skewness_vars <- data.frame(Column.Name=character(),
                                skewness_vars=character(),
                                stringsAsFactors=FALSE)
    values <- NULL
  }
  list(skewness_vars, values)
}

#' Returns highly correlated variables (applies to numeric variables only)
#'
#' @export
#' @param df The dataframe to generate the EDA report
#' @param correlation_threshold OPTIONAL. The threshold based on which variables will be flagged as "Highly Correlated". Default value is 0.8
#' @param method_name a character string indicating which correlation coefficient (or covariance) is to be computed. One of "pearson" (default), "kendall", or "spearman": can be abbreviated.
#' @return melted_cormat_f_one A dataframe containing the correlated variables and their corresponding pearson correlation coefficient
#' @examples
#' get_correlated_vars(df)
#' get_correlated_vars(df, correlation_threshold=0.8)
get_correlated_vars <- function(df,correlation_threshold=correlation_threshold_pkg_default,
                                method_name="pearson"){
  melted_cormat <- .get_cor_mat_private(df,method=method_name)
  melted_cormat_f_one <- .get_correlated_vars_private(melted_cormat,
                                                      correlation_threshold)
  melted_cormat_f_one
}

.get_cor_mat_private <- function(df, method_name="pearson"){
  df_numeric <- df %>% Filter(f = is.numeric)
  if(dim(df_numeric)[2] > 0){
    cormat_pearson <- round(stats::cor(df_numeric, use="pairwise.complete.obs", method=method_name),2)
    melted_cormat <- reshape2::melt(cormat_pearson)
    melted_cormat
  }
}

.get_correlated_vars_private <- function(melted_cormat,correlation_threshold=correlation_threshold_pkg_default){
  melted_cormat_f <- melted_cormat %>% dplyr::filter(Var1 != Var2, value >= correlation_threshold)
  if(nrow(melted_cormat_f) > 0){
    melted_cormat_f_one <- data.frame(t(apply(melted_cormat_f[c("Var1","Var2")], 1, sort)))
    melted_cormat_f_one$value <- melted_cormat_f$value
    colnames(melted_cormat_f_one) <- c("Var1","Var2","Value")
    melted_cormat_f_one <- melted_cormat_f_one %>% dplyr::group_by(Var1, Var2) %>% dplyr::filter(dplyr::row_number() == 1)
  } else{
    melted_cormat_f_one <- data.frame(Var1=character(),
                                      Var2=character(),
                                      Value=numeric(),
                                      stringsAsFactors=FALSE)
  }

  melted_cormat_f_one
}

#' Returns consolidated warnings found in dataframe.
#'
#' @export
#' @param df The dataframe to generate the EDA report
#' @param missing_threshold OPTIONAL. The threshold based on which variables will be flagged as "Missing". Default value is 0.3
#' @param cardinality_threshold OPTIONAL. The threshold based on which variables will be flagged as "High Cardinality". Default value is 50
#' @param skewness_threshold OPTIONAL. The threshold based on which variables will be flagged as "Highly Skewed". Default value is 20
#' @param correlation_threshold OPTIONAL. The threshold based on which variables will be flagged as "Highly Correlated". Default value is 0.8
#' @return df_warnings A dataframe containing all the warnings and recommendations per variable based on different threshold values
#' @examples get_full_warnings(df)
#' get_full_warnings(df,
#' missing_threshold=0.3,
#' cardinality_threshold=50,
#' skewness_threshold=20,
#' correlation_threshold=0.8)
get_full_warnings <- function(df,missing_threshold=missing_threshold_pkg_default,
                              cardinality_threshold=cardinality_threshold_pkg_default,
                              skewness_threshold=skewness_threshold_pkg_default,
                              correlation_threshold=correlation_threshold_pkg_default){
  df_warnings <- data.frame(Column_Name=character(),
                            Type=character(),
                            Comments=character(),
                            stringsAsFactors=FALSE)

  # Missing
  perc_missing_report <- get_missing_vars(df,missing_threshold)
  if(nrow(perc_missing_report) > 0){
    perc_missing_report$Type <- "Missing"
    perc_missing_report$perc_missing_report <- paste0(round(perc_missing_report$perc_missing_report*100,1), "% missing values")
    colnames(perc_missing_report) <- c("Comments", "Column_Name", "Type")
    perc_missing_report <- perc_missing_report[c("Column_Name", "Type", "Comments")]

    df_warnings <- rbind(df_warnings, perc_missing_report)
  }

  #Cardinality
  cardinalities <- get_cardinal_vars(df,cardinality_threshold)
  if(nrow(cardinalities) > 0){
    cardinalities$cardinalities <- paste0("High Cardinality: ",cardinalities$cardinalities, " distinct values")
    cardinalities$Type <- "Warning"
    colnames(cardinalities) <- c("Comments", "Column_Name", "Type")
    cardinalities <- cardinalities[c("Column_Name", "Type", "Comments")]

    df_warnings <- rbind(df_warnings, cardinalities)
  }

  #Constant Value Rejected
  list_op_unique <- get_unique_vars(df)
  unique_count <- list_op_unique[[1]]
  values_unique <- list_op_unique[[2]]
  if(nrow(unique_count) > 0){
    unique_count$unique_count <- paste0("Has constant value: ",values_unique)
    unique_count$Type <- "Rejected"
    colnames(unique_count) <- c("Comments", "Column_Name", "Type")
    unique_count <- unique_count[c("Column_Name", "Type", "Comments")]

    df_warnings <- rbind(df_warnings, unique_count)
  }

  #Skewness
  list_op_skew <- get_skewed_vars(df,skewness_threshold)
  skewness_vars <- list_op_skew[[1]]
  values_skew <- list_op_skew[[2]]
  if(nrow(skewness_vars) > 0){
    skewness_vars$skewness_vars <- paste0("Highly Skewed: y1=", round(values_skew,2))
    skewness_vars$Type <- "Skewed"
    colnames(skewness_vars) <- c("Comments", "Column_Name", "Type")
    skewness_vars <- skewness_vars[c("Column_Name", "Type", "Comments")]

    df_warnings <- rbind(df_warnings, skewness_vars)
  }

  # Correlation
  melted_cormat <- .get_cor_mat_private(df)
  if(!is.null(melted_cormat)){
    melted_cormat_f_one <- .get_correlated_vars_private(melted_cormat,
                                                        correlation_threshold)
    if(nrow(melted_cormat_f_one) > 0){
      correlation_vars <- data.frame(Column_Name=melted_cormat_f_one$Var1,Type="Warning",
                                     Comments=paste0("Is highly correlated with ",
                                                     melted_cormat_f_one$Var2,"(p=",
                                                     melted_cormat_f_one$Value,")"))

      df_warnings <- rbind(df_warnings, correlation_vars)
    }
  }
  df_warnings
}
