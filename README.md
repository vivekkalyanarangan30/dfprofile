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
	> get_ful_warnings(mtcars)
	> get_info(mtcars)
	> get_missing_vars(mtcars)


## Get unique variables ##

### Description ###
Returns information of the dataframe - The variables which have a constant value

### Usage ###

`get_unique_vars(df)`

### Arguments ###

	> df - The dataframe to generate the EDA report
	
### Value ###

	> list(unique_count, values) - A list containing two elements - a dataframe with the column name and the unique_count and another named list of the variables and their constant values.

### Examples ###

	> get_unique_vars(df)
    
