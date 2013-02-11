#!/usr/bin/env ruby

require 'rubygems'
require 'pp'
require 'digest/md5'
require 'thread'

module Style


	## records 		= Style.create_records( ["bucket1", "bucket2", "bucket3"], 4 )
	## analysis 	= Style.Analyzer.new( "wi" )	
	class Analyzer
		

		## get_tokens( record.id ) 
		def self.get_tokens( rid )

			mcw 	= Hash.new		# most common word

			begin 
					lines = IO.read "./records/#{rid}.txt"
				rescue => e
					puts "[!] Error! #{e}"
			end

			str_array = lines.downcase.scan(/\w+/)

			for string in str_array
				mcw[string] += 1
			end

			mcw.sort{ |a,b| a[1] <=> b[1] }.reverse
		end



		#
		# 		http://en.wikipedia.org/wiki/Stylometry#Writer_invariant
		#
		#		The primary stylometric method is the writer invariant: a property of a text which
		# is invariant of its author. An example of a writer invariant is frequency of function
		# words used by the writer.

		#		In one such method, the text is analyzed to find the 50 most common words. The text
		# is then broken into 5,000 word chunks and each of the chunks is analyzed to find the frequency of
		# those 50 words in that chunk. This generates a unique 50-number identifier for each chunk.
		# These numbers place each chunk of text into a point in a 50-dimensional space. This
		# 50-dimensional space is flattened into a plane using principal components analysis (PCA).
		# This results in a display of points that correspond to an author's style. If two literary
		# works are placed on the same plane, the resulting pattern may show if both works were by the
		# same author or different authors.

		def self.writer_invariant( record_set )

			lines = get_tokens( 

			lines.each do |l|
				mcw = get_tokens(l)

				mcw.each do |w|
					puts "Common Found --- #{w[0]}: #{w[1]}" if w[1] > 5
				end
			end
		end
	
		def self.collocation
		end

		
	end


	class Record

		attr_accessor :id, :stats
		
		# Record.new( "__AUTHOR__FILE__" )
		def initialize( author = "null" )
			salt    = "260d98e6f9fcdebea77edcd808c592ec"
			@id 	= Digest::MD5.hexdigest( author + ":" + salt ) 
			@stats  = { :lines => 0, :words => 0 }
		end

	end

	### Style.parse_bucket( string bucket )
	def self.parse_bucket( bucket )
		
		## start timer
		start = Time.now

		## Number of lines skipped ( < 5 words, invalid nicks
		skipped = 0    	# skip log in debug.log

		mutex = Mutex.new()
		## split lines and put them into their respective author records
		IO.read("./#{bucket}").split(/\n/).each do |data|
			begin
				nick, line = data.split("\t")

				
				if nick.nil? or line.nil? or line.split(/ /).count < 5
					skipped += 1

					mutex.synchronize {
						File.open("./debug.log", "w+") { |f| f.write("[#{bucket}][SKIP] #{nick} --- #{line}") }
					}
				end


				record = Record.new( nick )

				mutex.synchronize {
					File.open( "./records/#{record.id}.txt", "a+") { |f| f.write "#{line}\n" }
				}

			rescue => e
				print "Borked on buckets/#{nick}.txt #{line}\t#{e}\n"
			end

			
		end

		print "[!] Parsed #{bucket} in #{(Time.now - start).to_s.match(/^(\d+\.\d)/)[1]} seconds.  Lines skipped: #{skipped}\n"
	end

	### Style.create_records( string array buckets, string thread_pool_size )
	### Returns list of type Record (at some point)
	def self.create_records( buckets, pool_size = 8 )

		threads 	= Array.new()

		buckets.each do |b|

			until threads.map { |t| t.status }.count("run") < pool_size do sleep 2 end

			threads << Thread.new() {
				puts "New thread: #{threads.map { |t| t.status }.count("run")}"
				sleep( "0.#{rand(10)}".to_i )
				parse_bucket( b )
			}

		end

		output = threads.map { |t| t.value }
	end
end


## List of data sources
#buckets     = %x{ ls split_* }.split(/\n/)

## Pass them to the record creater, and pool_size
#Style.create_records( buckets, 3 )


analyzer = Style.Analyzer.new( :method => "wi" )
