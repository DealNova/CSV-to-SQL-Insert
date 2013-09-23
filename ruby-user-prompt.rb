#VERSION 1.2

require 'yaml'

module UserPrompt
	def UserPrompt.ArguUserPrompt( settings )  
		
		#prepare output
		prompt_res = Hash.new
		
		#check if correct num of args given
		numargs = 0
		max = 0
		settings["arguments"].each do |key , val|
			if( val["default"] == nil )
				numargs += 1
			end
			max += 1
		end
		
		
		
			
		#check if arguments were passed
		if(ARGV.size > 0)
			
			#check if first argument is a yaml and if yaml input is enabled
			if( ARGV[0].size >= 4 && ARGV[0][-4,4].upcase == "YAML" && settings["settings"].include?("yaml_input") == true )
				# if only YAML is passed, provide user prompt to select yaml, else attempt load of provided
				if( ARGV[0].upcase == "YAML" )
					toload = FileInput( "Please select a YAML input file:" , settings["settings"]["yaml_input"] , "yaml" )
				else  
					toload = settings["settings"]["yaml_input"] + ARGV[0]
				end
				
				#load yaml
				
				tmp = YAML.load_file(toload)
				puts "==========="
				puts "YAML Loaded"
				puts "===========\n"
				tmp.each do |key , val|
					puts "#{key}: #{val}"
				end
				puts "\n"
				arguments = Hash.new
				settings["arguments"].each do |key , val|
					arguments[key] = tmp[val["name"]]
				end
			else
				arguments = ARGV
			end 
			
			if  ((numargs > arguments.size) && (arguments.size > 0 ) ) || (max < arguments.size)
				puts "ABORTED: Incorrect Arguments. #{arguments.size} Received, #{numargs} Required, #{max} Available."
				abort
			end
		
			settings["arguments"].each do |key , val|
				if arguments[key] === nil
					if val["default"] == nil
						puts "No Default Set for #{val[name]}"
						abort
					else
						 prompt_res[val["name"]] = val["default"]
						 puts "Default of \"#{val["default"]}\" user for #{val["name"]} "
					end
				else
					prompt_res[val["name"]] = arguments[key]
				end
			end
		else
			settings["arguments"].each do |key , val|
					case val["type"]
						when "INTEGER"
							prompt_res[val["name"]] = UserPrompt.IntInput(val["message"])
						when "DOUBLE"
							prompt_res[val["name"]] = UserPrompt.FloatInput(val["message"])
						when "TEXT"
							prompt_res[val["name"]] = UserPrompt.StringInput(val["message"])
						when "FILE"
							prompt_res[val["name"]] = UserPrompt.FileInput(val["message"] , val["directory"] , val["extension"])
						when "ARRAY"
							prompt_res[val["name"]] = UserPrompt.ArrayInput(val["message"] , val["array"])
						when "BOOLEAN"
							prompt_res[val["name"]] = UserPrompt.BooleanInput(val["message"] )
						when "YESNO"
							prompt_res[val["name"]] = UserPrompt.YesNoInput(val["message"] )
						else
							puts "INVALID PROMPT TYPE"
							abort
					end
			end
		end	
			puts "\n"
			return prompt_res
	end

	def UserPrompt.ReRunCommand( theargs  , engine )
		rerun = "#{engine} #{$0}"
		theargs.each do |key , val|
			rerun = " #{rerun} \"#{val}\"" 
		end
		puts "\n===============\n"
		puts "Script Complete\n"
		puts "===============\n"
		puts "Command to rerun:   #{rerun}"
	end
	
	
	def UserPrompt.WriteLast( args , settings )
		if( settings["settings"].include?("yaml_input") == true )
			file_write = File.new( settings["settings"]["yaml_input"] + "last.yaml", "w")
			file_write.write("#{args.to_yaml}")
			file_write.close
		end
	end
	
#HELPER METHODS

	def UserPrompt.FileInput( m ,dir , ext )
		opts = UserPrompt.GetFiles( dir , ext  )
		return UserPrompt.SelectMenu( m , opts )
	end

	def UserPrompt.ArrayInput( m , array )
		return UserPrompt.SelectMenu( m , array )
	end
	
	def UserPrompt.BooleanInput( m )
		if UserPrompt.SelectMenu( m , ["TRUE" , "FALSE"] ) == "TRUE"
			return TRUE
		else
			return FALSE
		end
	end
	
	def UserPrompt.YesNoInput( m )
		if UserPrompt.SelectMenu( m , ["YES" , "NO"] ) == "YES"
			return TRUE
		else
			return FALSE
		end
	end
	
	def UserPrompt.IntInput( m  )
			 begin
				 puts "\n#{m}"
				usr_in = Integer(gets.chomp) rescue nil
			end until (usr_in != nil )
				 
		return usr_in.to_i

	end 

	def UserPrompt.FloatInput( m  )
			 begin
				 puts "\n#{m}"
				usr_in = Float(gets.chomp) rescue nil
			end until (usr_in != nil )
				 
		return usr_in.to_f

	end 

	def UserPrompt.StringInput( m  )
			 begin
				 puts "\n#{m}"
				usr_in = gets.chomp rescue nil
			end until (usr_in != nil )
				 
		return usr_in.to_s

	end 

	def UserPrompt.GetFiles( dir , ext  )
		fls = []
		Find.find(dir) do |path|
		  fls << path if path =~ /.*\.#{ext}$/
		end
		return fls
	end
	
	def UserPrompt.SelectMenu( m , opts )
		 begin
			 puts "\n#{m}"
			 for i in 0 ... opts.size 
				puts "#{i+1}: #{opts[i]}"
			 end
			usr_in = $stdin.gets.chomp.to_i
		end until (usr_in >= 1 && usr_in <= opts.size)	 
		return opts[usr_in.to_i - 1]
	end 
	
end