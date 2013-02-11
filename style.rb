#!/usr/bin/env ruby

require 'rubygems'
require 'pp'
require 'digest/md5'
require 'thread'

module Style

	class Record

		attr_accessor :id, :stats
		
		# Record.new( "__AUTHOR__FILE__" )
		def initialize( author = "null" )
			salt    = "260d98e6f9fcdebea77edcd808c592ec"
			@id 	= Digest::MD5.hexdigest( author + ":" + salt ) 
			@stats  = { :lines => 0, :words => 0 }
		end

	end


	### Style.parse_bucket( BUCKET:string )
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

	### Style.create_records( ["array", "of", "buckets"], MAX_CONCURRENT_THREADS:string )
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
buckets     = %x{ ls split_* }.split(/\n/)

## Pass them to the record creater, and pool_size
Style.create_records( buckets, 3 )

