# dfprofile
=========
---

Generates HTML based EDA reports on the input dataframe

License: MIT

For more information please contact vivekkalyanarangan30@gmail.com

# Installation #
---

Using the 'devtools' package:

    > install.packages("devtools")
    > library(devtools)
    > install_github('vivekkalyanarangan30/dfprofile', upgrade_dependencies=F, dep=T)
    
# Usage #
---

Using the built in `mtcars` dataset as an example.

    > library(dfprofile)
	> profile_report(mtcars, "/path/to/output.html")

### Example ###
To get specific sections from the report, access the functions below:

    > get_unique_vars(mtcars)
	> get_skewed_vars(mtcars)
	> get_cardinal_vars(mtcars)
	> get_correlated_vars(mtcars)
	> get_full_warnings(mtcars)
	> get_info(mtcars)
	> get_missing_vars(mtcars)


## Get unique variables ##

### Description ###
Returns information of the dataframe - The variables which have a constant value

### Usage ###

	> get_unique_vars(df)

### Arguments ###

	> df - The dataframe to generate the EDA report
	
### Value ###

`list(unique_count, values)` 	 - A list containing two elements - a dataframe with the column name and the unique_count and another named list of the variables and their constant values.

### Examples ###

	> get_unique_vars(df)
	
## Get skewed variables ##

### Description ###
Returns skewness information of the dataframe

### Usage ###

	> get_skewed_vars(df, skewness_threshold = skewness_threshold_pkg_default)

### Arguments ###

	> df - The dataframe to generate the EDA report
	> skewness_threshold - OPTIONAL. The threshold based on which variables will be flagged as "Highly Skewed". Default value is 20
	
### Value ###

`list(skewness_vars, values)` -  A list containing two elements - a dataframe with the column name and the skewness and another named list of the variables and their skewness values.

### Examples ###

	> get_skewed_vars(df)
	> get_skewed_vars(df, skewness_threshold=20)

## Get cardinal variables ##

### Description ###
Returns cardinality information of the dataframe - The cardinalities for the variables (applies to factor variables)

### Usage ###

	> get_cardinal_vars(df, cardinality_threshold = cardinality_threshold_pkg_default)

### Arguments ###

	> df - The dataframe to generate the EDA report
	> cardinality_threshold - OPTIONAL. The threshold based on which variables will be flagged as "High Cardinality". Default value is 50
	
### Value ###

`cardinalities` - The output dataframe containing the column name and the cardinality.

### Examples ###

	> get_cardinal_vars(df)
	> get_cardinal_vars(df, cardinality_threshold=0.3)
	
## Get correlated variables ##

### Description ###
Returns highly correlated variables (applies to numeric variables only)

### Usage ###

	> get_correlated_vars(df, correlation_threshold = correlation_threshold, method_name = "pearson")

### Arguments ###

	> df - The dataframe to generate the EDA report
	> correlation_threshold - OPTIONAL. OPTIONAL. The threshold based on which variables will be flagged as "Highly Correlated". Default value is 0.8
	
### Value ###

`melted_cormat_f_one` - A dataframe containing the correlated variables and their corresponding pearson correlation coefficient

### Examples ###

	> get_correlated_vars(df)
	> get_correlated_vars(df, correlation_threshold=0.8)
	
## Get All Warnings ##

### Description ###
Returns consolidated warnings found in dataframe.

### Usage ###

	> get_full_warnings(df, missing_threshold = missing_threshold_pkg_default, cardinality_threshold = cardinality_threshold_pkg_default, skewness_threshold = skewness_threshold_pkg_default, correlation_threshold = correlation_threshold_pkg_default)

### Arguments ###

	> df - The dataframe to generate the EDA report
	> missing_threshold - OPTIONAL. The threshold based on which variables will be flagged as "Missing". Default value is 0.3
	> cardinality_threshold - OPTIONAL. The threshold based on which variables will be flagged as "High Cardinality". Default value is 50
	> skewness_threshold - OPTIONAL. The threshold based on which variables will be flagged as "Highly Skewed". Default value is 20
	> correlation_threshold - OPTIONAL. OPTIONAL. The threshold based on which variables will be flagged as "Highly Correlated". Default value is 0.8
	
### Value ###

`df_warnings` - A dataframe containing all the warnings and recommendations per variable based on different threshold values

### Examples ###

	> get_full_warnings(df)
	> get_full_warnings(df, missing_threshold=0.3,cardinality_threshold=50,skewness_threshold=20,correlation_threshold=0.8)

## Get Info ##

### Description ###
Returns meta information about the dataframe like number of variables, number of observations, total missing percentage, total size in memory.

### Usage ###

	> get_info(mtcars)

### Arguments ###

	> df - The dataframe to generate the EDA report
	
### Value ###

`df_info` - A dataframe containing all properties and their corresponding values.

### Examples ###

	> get_info(df)

## Get Missing variables ##

### Description ###
Returns missing information of the dataframe - The distribution of variables by type (factor, integer, etc.)

### Usage ###

	> get_missing_vars(df, missing_threshold = missing_threshold_pkg_default)

### Arguments ###

	> df - The dataframe to generate the EDA report
	> missing_threshold - OPTIONAL. The threshold based on which variables will be flagged as "Missing". Default value is 0.3
	
### Value ###

`perc_missing_report` - The output dataframe containing the column name and the percentage of missing values

### Examples ###

	> get_missing_vars(df)
	> get_missing_vars(df, missing_threshold=0.3)
