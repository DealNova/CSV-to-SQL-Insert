CSV to SQL Insert Script
=============

# INSTALL

* place "ruby-prog-bar.rb" into directory
* place "ruby-user-prompt.rb" into directory
* create following directories or point YAML file to correct directories.
    - csv_input_path: Path to location of CSV files to convert
	- sql_output_path: Path to where .sql files will be saved
	- yaml_input: Path of saved seeds for rerunning

# USAGE

* Place csv file into csv_input_path directory
* Execute csv_to_sql.rb ruby file
* Select input file from options
* Enter table name for SQL table to insert into.
* View results in sql_output_path.  Script name will be the input file name, but with .sql extension

