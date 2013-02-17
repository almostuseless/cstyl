#!/usr/bin/env ruby

require 'rubygems'
require 'pp'
require 'digest/md5'
require 'thread'
require 'sqlite3'
require 'mechanize'


module DB
    class << self; end

    

    ## db = DB::IO.new( "records.db" )
    class IO
        attr_accessor :db

        def initialize( file )
            if file
                @db = SQLite3::Database.new file
            else
                die "nope"
            end
        end
    end

end


module CStyl

#    class << self; end


    module Corpus
        def self.create
        end
    end

    module Aggregator

        class << self; end

        ## res = CStyl::Aggregator::Quora.new("http://www.quora.com/What-are-some-useful-technical-skills-I-can-learn-within-a-day")
        class Quora

            class << self; end

            attr_accessor :data, :link
            
            def initialize( args )
                @data = Hash.new
                @link = args[:link] if args[:link]

                mech = Mechanize.new

                mech.get( @link ) do |page|

                    doc = Nokogiri::HTML( page.content, nil, "UTF-8" )

                    pp doc.at_css("#__w2_")

#                    doc.xpath('//div[starts-with(@id, "__w2_")]').each do |div|
#                        puts "Div: #{div}"
#                    end
                        
                     
                end

            end
        end
    end


    class Analyzer
        
        attr_accessor :method, :records
        @@records = Array.new()

        ## records      = CStyl.create_records( ["bucket1", "bucket2", "bucket3"], 4 )
        ## analysis     = CStyl::Analyzer.new( "wi" )   
        def initialize( args )
            pp args
            @method     = args[:method] if args[:method]
        end

        def self.run
            CStyl::Analyzer.send( @method.to_sym )
        end


        ## get_tokens( record.id ) 
        def self.get_tokens( rid )

            mcw     = Hash.new(0)       # most common word

            record_file = IO.read("./records/#{rid}.txt").downcase

            tokens = record_file.scan(/\w+/)

            for string in tokens
                mcw[string] += 1
            end

            mcw.sort{ |a,b| a[1] <=> b[1] }.reverse
        end


        #
        #       http://en.wikipedia.org/wiki/Stylometry#Writer_invariant
        #
        #       The primary stylometric method is the writer invariant: a property of a text which
        # is invariant of its author. An example of a writer invariant is frequency of function
        # words used by the writer.

        #       In one such method, the text is analyzed to find the 50 most common words. The text
        # is then broken into 5,000 word chunks and each of the chunks is analyzed to find the frequency of
        # those 50 words in that chunk. This generates a unique 50-number identifier for each chunk.
        # These numbers place each chunk of text into a point in a 50-dimensional space. This
        # 50-dimensional space is flattened into a plane using principal components analysis (PCA).
        # This results in a display of points that correspond to an author's style. If two literary
        # works are placed on the same plane, the resulting pattern may show if both works were by the
        # same author or different authors.

        def self.writer_invariant

            tokens = get_tokens( "0b41df3d3a4a7efdf3ef9cdb3aadc640" )

            print "[+] Got #{tokens.count} tokens...\n"

            tokens.each do |w|
                print "[+] Token: (#{w[1]})\t#{w[0]}\n" if w[1] > 5
            end
        end
    
        def self.collocation
        end
    end



    module Bucket

        class << self; end


        class Aggregator

        end

        class Parser < CStyl::Analyzer

            ### CStyl::Parser.parse_bucket( string bucket )
            def self.parse_bucket( bucket )

                ## start timer
                start = Time.new

                ## Number of lines skipped ( < 5 words, invalid nicks
                skipped = 0     # skip log in debug.log

                mutex = Mutex.new()
                ## split lines into their respective author records

                buckets = File.open( bucket, "a+" )

                print "[!] Parsing #{bucket}\n"

                buckets.each_line do |data|
                    begin
                        nick, line = data.split("\t")

                        
                        if nick.nil? or line.nil? or line.split(/ /).count < 5
                            skipped += 1
                            
                            mutex.synchronize {
                                File.open("./debug.log", "a+") { |f| f.write("[#{bucket}][SKIP] #{nick} --- #{line}") }
                            }
                        end


                        record = Record.new( nick )

                        mutex.synchronize {
                            File.open( "./records/#{record.id}.txt", "a+") { |f| f.write "#{line}" }
                        }

                        @@records.push record

                        pp @@records
                        sleep 2

                    rescue => e
                        print "Borked on buckets/#{nick}.txt #{line}\t#{e}\n"
                    end

                end

                return @@records.count

            end


            ### CStyl.create_records( string array buckets, string thread_pool_size )
            ### Returns list of type Record (at some point)
            def self.create_records( buckets, pool_size = 3 )

                threads     = Array.new()

                buckets.each do |b|

                    until threads.map { |t| t.status }.count("run") < pool_size do sleep 5 end

                    threads << Thread.new() {
                        #print "New thread: #{threads.map { |t| t.status }.count("run")}\n"

                        start = Time.now

                        res = parse_bucket( b )
            
                        print "[+] Parsed #{b} in #{(Time.now - start).to_s.match(/^(\d+\.\d)/)[1]} "
                        print "seconds yeilding #{@@records.count} records\n"
                    }

                end

                output = threads.map { |t| t.value }
            end
        end
    end




    class Record

        attr_accessor :id, :stats
        
        # Record.new( "__AUTHOR__FILE__" )
        def initialize( author = "null" )
            salt    = "260d98e6f9fcdebea77edcd808c592ec"
            @id     = Digest::MD5.hexdigest( author + ":" + salt ) 
            @stats  = { :lines => 0, :words => 0 }
        end

    end




    


end


q = CStyl::Aggregator::Quora.new( :link => "http://www.quora.com/What-are-some-useful-technical-skills-I-can-learn-within-a-day" )
pp q

#pp CStyl::Aggregator::Quora.fetch

=begin
# List of data sources
buckets     = %x{ find ./buckets -name "split_*" }.split(/\n/)

## Pass them to the record creater, and pool_size
analyzer = CStyl::Analyzer.new( :method => "writer_invariant" )


puts "[!] analyzer"
pp analyzer

CStyl::Bucket::Parser.create_records( buckets, 10 )

pp CStyl.records

=end
