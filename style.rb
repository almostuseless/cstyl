#!/usr/bin/env ruby

require 'rubygems'
require 'pp'
require 'digest/md5'
require 'thread'

module Style

    class << self; end

    @records = Array.new()
    attr_accessor :records


    class Analyzer
        
        attr_accessor :method, :records

        ## records      = Style.create_records( ["bucket1", "bucket2", "bucket3"], 4 )
        ## analysis     = Style::Analyzer.new( "wi" )   
        def initialize( args )

            @method     = args[:method] if args[:method]
        end

        def self.run
            Style::Analyzer.send( @method.to_sym )
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


    class Record

        attr_accessor :id, :stats
        
        # Record.new( "__AUTHOR__FILE__" )
        def initialize( author = "null" )
            salt    = "260d98e6f9fcdebea77edcd808c592ec"
            @id     = Digest::MD5.hexdigest( author + ":" + salt ) 
            @stats  = { :lines => 0, :words => 0 }
        end

    end

    ### Style.parse_bucket( string bucket )
    def self.parse_bucket( bucket )

        ## start timer

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

                @records.push record

            rescue => e
                print "Borked on buckets/#{nick}.txt #{line}\t#{e}\n"
            end

        end

        return @records.count

    end


    ### Style.create_records( string array buckets, string thread_pool_size )
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
                print "seconds yeilding #{@records.count} records\n"
            }

        end

        output = threads.map { |t| t.value }
    end
end

# List of data sources
buckets     = %x{ find ./buckets -name "split_*" }.split(/\n/)

## Pass them to the record creater, and pool_size
analyzer = Style::Analyzer.new( :method => "writer_invariant" )


puts "[!] analyzer"
pp analyzer

Style.create_records( buckets, 10 )

pp Style.records
