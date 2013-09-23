require 'rubygems'
require 'yaml'
require 'find'
require 'ruby-user-prompt.rb'
require 'ruby-prog-bar.rb'
require 'CSV'

$CONFIG = YAML.load_file("csv_to_sql.yaml")
 
prompt_settings = Hash.new
prompt_settings = { 
		"arguments" => {
				0 => {"type" => "FILE", "name" => "csv_input"  , "message" => "Please select an CSV input file:" , "directory" => $CONFIG['csv_input_path'] , "extension" => "csv"} ,
				1 => {"type" => "TEXT", "name" => "table_name"  , "message" => "Please enter the table name:" } 
				},
				"settings" => {
					"yaml_input" => $CONFIG["yaml_input"] 
				}
			}
$args = UserPrompt.ArguUserPrompt( prompt_settings ) 

file_write = File.new( $args["csv_input"].gsub( $CONFIG['csv_input_path'] , $CONFIG['sql_output_path']).gsub( ".csv" , ".sql" ) , "w")

	def GetFieldNamesCSV( ar )
		resp = Array.new
		
		ar.each do |v|
		  resp << v.gsub("\n","")
	    end
	   return resp
	end


$csv_def = nil
file = File.new($args["csv_input"])
$num_rows =  file.readlines.size
 
file.close
 
CSV.foreach($args["csv_input"] ) do |row|
    if $csv_def.nil? == true
		$csv_def = row.join(",")
	else
		sql = "INSERT INTO #{$args["table_name"]} ( #{$csv_def} ) VALUES ( '#{row.join("','") }' );"
		file_write.puts sql
	end
	Ruby_prog_bar.DefinedBar($num_rows)
  end


file_write.close


UserPrompt.WriteLast($args ,prompt_settings )
