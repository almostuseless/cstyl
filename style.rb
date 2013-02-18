#!/usr/bin/env ruby

require 'rubygems'
require 'pp'
require 'digest/md5'
require 'thread'
require 'mechanize'
require 'mysql'
require 'ruby-progressbar'

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


    ##
    ##  corpus = Corpus.new()
    ##  corpus.generate( :type => "phpbb", :args => { :db => { :host => "localhost", :db_name => "htd0rg" } } )
    ##  pp corpus
    ##
    ##  { Corpus.@authors => [] }
    ##
    class Corpus
        
        def generate( opts )

            type = opts.fetch :type
            args = opts.fetch :args

            self.send type, args
        end


        ## Will have to vallidate arguments at some point
        def phpbb( args )

            db = args[:db]
            mysql = Mysql.new( db[:host], db[:user], db[:pass], db[:db_name] )

            rs = mysql.query("select poster_id,post_subject,post_text from phpbb_posts where length(post_text) - length( replace( post_text, ' ', '')) > 10")

            pb = ProgressBar.create(:title => "Rows", :starting_at => 0, :total => rs.num_rows )

            rs.num_rows.times do 
                row   = rs.fetch_row
                chunk = Hash.new


                ## need to make a id_number => md5 map somewhere to keep this from
                ## running 50 times for the same row[0] value
                chunk[:id]      = Digest::MD5.hexdigest row[0]
                chunk[:sub]     = row[1]
                chunk[:text]    = row[2]

                dirs = chunk[:id].match(/^(?<first>.)(?<second>.)/)
                path = File.join( "./corpus", dirs['first'], dirs['second'] )

                unless File.directory?( path )
                    %x{ mkdir -p #{ path } }
                end

                ##  Make this a comprehensive method
                ##  Normalization and classification/removal of unuseable substrings

                chunk[:text].gsub!(/\[url.*?\[\/url.*?\]/," ")
                chunk[:text].gsub!(/\\[rn]/,"")
                chunk[:text].gsub!(/[\r\n]/,"")
                chunk[:text].gsub!(/\s+/," ")
                chunk[:text].gsub!(/http\S+/,"")
                chunk[:text].gsub!(/<!--.*?-->/,"")
                chunk[:text].gsub!(/<img.*?\/>/,"")
                chunk[:text].gsub!(/\.\.+/,".")

                next unless chunk[:text].split(/\s/).count >= 10
                
                File.open( "#{path}/#{chunk[:id]}", "a+" ) { |f| f.write "#{chunk[:text]}\n" }
                
                pb.increment
            end
        end
    end

    module Aggregator

    end


    
    ##  corpus  = CStyl::Corpus.new
    ##  stats   = CStyl::Analysis.new
    ##
    ##  corpus.generate(...)
    ##  stats.generate( :style => "nine_feature" )
    ##
    ##  pp stats => { :unique_words => 0, :complexity => 0, :sentence_count => 0,
    ##                :letter_count => 0, :syllable_count => 0, :gunning_fog => 0, 
    ##                :flesch_score => 0 }
    ##
    class Analysis
        
        attr_accessor :data, :analysis

        def initialize
            @@data               = Hash.new
            @@analysis           = Array.new
            @@data[:top_authors] = %x{ wc -l corpus/*/*/* | sort  |tail -n30 | head -n29 |awk '{ print $2 }' }.split(/\n/)

            if @@data[:top_authors].count < 5
                puts "Error, only got #{@data[:top_authors]} authors.  Check your corpus"
                exit
            end

        end

        def generate( opts )
            style = opts.fetch :style
            args  = opts.fetch :args
            CStyl::Analysis.send( style.to_sym, args )
        end


        ##  9-Feature set
        ##  Unique words, complexity/rarity of words, sentence count, letter count,
        ##  syllable count, gunning-fog index, flesch score
        ##
        def self.nine_feature( args )
       
            ##  Sentence count first, then loop through sentences adding /new/ words 
            ##  to the 'unique_words' array.
            puts "Generating 9-feature set statistics on #{@@data[:top_authors].count} authors"

            ## Going to push different author stats (type Hash) into this array
            @@data[:stats] = Array.new

            @@data[:top_authors].each do |a|

                ## We will push this onto @@data[:authors]
                author_data = Hash.new
                author_data[:id] = a

                sentences = IO.read( a ).force_encoding("ISO-8859-1").encode("utf-8", replace: nil ).split(/[.!?]/)
                author_data[:sentence_count] = sentences.count

                sentences.each do |sen|
                end

                @@data[:stats].push author_data
            end

            @@data
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


    ## Ripped this out at e57312e3a3b8762fe7dc719cd5d5c45311af8e9b
    ## 
    module Bucket
    end

    ## Ripped this out at e57312e3a3b8762fe7dc719cd5d5c45311af8e9b
    ## 
    class Record
    end

end


#corpus = CStyl::Corpus.new
stats  = CStyl::Analysis.new

#corpus.generate( :type => "phpbb", :args => {
#                    :db => {    :user => "roobay",
#                                :pass => "butts",
#                                :host => "localhost",
#                                :db_name => "htd0rg"  } } )


pp stats.generate( :style => "nine_feature", :args => nil )[:stats]

    ##  corpus  = CStyl::Corpus.new
    ##  stats   = CStyl::Analysis.new
    ##
    ##  corpus.generate(...)
    ##  stats.generate( :style => "nine_feature" )
    ##
    ##  pp stats => { :unique_words => 0, :complexity => 0, :sentence_count => 0,
    ##                :letter_count => 0, :syllable_count => 0, :gunning_fog => 0, 
    ##                :flesch_score => 0 }
    ##
