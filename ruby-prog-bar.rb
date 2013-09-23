module Ruby_prog_bar
	ITEMS_PER_NOTCH = 1000
	TOTAL_NOTCHES = 50
	PROG_CHAR = ">"
	def Ruby_prog_bar.DefinedBar( totalitems )  
			if( defined?( $V_PROG_BAR ).nil? || $V_PROG_BAR == nil)
				
				$V_PROG_BAR = Hash.new
				$V_PROG_BAR["active"] = false
				$V_PROG_BAR["total_items"] = totalitems
				$V_PROG_BAR["items_remaining"] = totalitems
				$V_PROG_BAR["prog_char"] = ">"
				$V_PROG_BAR["num_notch_count"] = 0
				$V_PROG_BAR["curr_notch_remaining"] = 0
				$V_PROG_BAR["prog_char"] = PROG_CHAR
				$V_PROG_BAR["total_notches"] = TOTAL_NOTCHES
				
				if( $V_PROG_BAR["total_notches"] > $V_PROG_BAR["total_items"] )
					$V_PROG_BAR["total_notches"] = $V_PROG_BAR["total_items"]
				end
				
				if $V_PROG_BAR["items_remaining"] != nil
					$V_PROG_BAR["items_per_notch"] = ($V_PROG_BAR["items_remaining"] / $V_PROG_BAR["total_notches"]).ceil
				else
					$V_PROG_BAR["items_remaining"] = 0
				end
				
				$V_PROG_BAR["curr_notch_remaining"] = $V_PROG_BAR["items_per_notch"]
			end
			
			if $V_PROG_BAR["active"] == false 
				$V_PROG_BAR["active"] = true
				print "\n0% |"
				for i in 0 ... $V_PROG_BAR["total_notches"] 
					print "-"
				end
				print "| 100%\n    "
			end
			
			
			$V_PROG_BAR["items_remaining"] -= 1
			$V_PROG_BAR["curr_notch_remaining"] -= 1
				
			if( $V_PROG_BAR["curr_notch_remaining"] == 0 )
				print $V_PROG_BAR["prog_char"]
				$V_PROG_BAR["curr_notch_remaining"] = $V_PROG_BAR["items_per_notch"]
			end
			
			if( $V_PROG_BAR["items_remaining"] == 0)
				$V_PROG_BAR["active"] = false
				$V_PROG_BAR = nil
			end
				
		
	end
	
		def Ruby_prog_bar.ContinuousBar( items_per_notch )  
			
				if( defined?( $V_PROG_BAR_NS ).nil? )
					$V_PROG_BAR_NS = Hash.new
					$V_PROG_BAR_NS["items_per_notch"] = items_per_notch
					$V_PROG_BAR_NS["count"] = 0
					$V_PROG_BAR_NS["prog_char"] = PROG_CHAR
				end
				$V_PROG_BAR_NS["count"] += 1
				
				if( $V_PROG_BAR_NS["count"] % $V_PROG_BAR_NS["items_per_notch"] == 0 )
					print $V_PROG_BAR_NS["prog_char"]
				end
				
		
	end
end