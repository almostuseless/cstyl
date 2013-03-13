#!/usr/bin/env ruby


=begin

    Copyright (c) 2013, almostuseless
    All rights reserved.

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:
        * Redistributions of source code must retain the above copyright
          notice, this list of conditions and the following disclaimer.
        * Redistributions in binary form must reproduce the above copyright
          notice, this list of conditions and the following disclaimer in the
          documentation and/or other materials provided with the distribution.
        * Neither almostuseless nor the
          names of its contributors may be used to endorse or promote products
          derived from this software without specific prior written permission.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
    ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
    WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
    DISCLAIMED. IN NO EVENT SHALL almostuseless BE LIABLE FOR ANY
    DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
    (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
    ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
    (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
    SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=end


require 'rubygems'
require 'pp'
require 'digest/md5'
require 'thread'
require 'mechanize'
require 'mysql'
require 'ruby-progressbar'
require 'yaml'
require 'active_support/secure_random'


class String
    def hline
        print "+"
        print self * ( %x{stty size | cut -d" " -f2}.to_i - 2 )
        puts "+"
    end
end

def termwidth
    return #{stty size | cut -d" " -f2}.to_i
end




module CStyl

    ##
    ##  corpus = Corpus.new()
    ##  corpus.generate( :type => "phpbb", :args => { :db => { :host => "localhost", :db_name => "some_phpbb_db" } } )
    ##
    ##  Generates ./corpus directory
    ##
    class Corpus
        
        def generate( opts )

            type = opts.fetch :type
            args = opts.fetch :args

            self.send type, args
        end


        ## Will have to validate arguments at some point
        def phpbb( args )

            puts "\n\t\t\tCStyl -- phpbb analysis"
            "-".hline

            db      = args.fetch :db
            mysql   = Mysql.new( db[:host], db[:user], db[:pass], db[:db_name] )

            rs = mysql.query("select poster_id,post_subject,post_text from phpbb_posts where length(post_text) - length( replace( post_text, ' ', '')) > 50")

            pb = ProgressBar.create(:title => "| Handling #{rs.num_rows} rows", :starting_at => 0, :total => rs.num_rows )

            rs.num_rows.times do 
                row   = rs.fetch_row
                chunk = Hash.new


                ## need to make a id_number => md5 map somewhere to keep this from
                ## running 50 times for the same row[0] value
                chunk[:id]      = Digest::MD5.hexdigest( row[0] )
                chunk[:sub]     = row[1]
                chunk[:text]    = row[2]

                dirs = chunk[:id].match(/^(?<first>.)(?<second>.)/)
                path = File.join( "./corpus", dirs['first'], dirs['second'] )

                unless File.directory?( path )
                    %x{ mkdir -p #{ path } }
                end


                ##  Normalization
                ##
                ##  Make this a comprehensive method for nrmalization and 
                ##  classification/removal of unuseable substrings
                


                ##  strip non-printables
                chunk[:text].gsub!(/[^[:print:]]/,"")
                
                ## Fuck all links, cant use them
                chunk[:text].gsub!(/http:\/\/\S+/,"")

                ##  Escaped newlines (not sure where they come from but they're there sometimes)
                chunk[:text].gsub!(/\\[rn]/,"")
                
                ## Actual Newlines and spaces
                chunk[:text].gsub!(/[\r\n]/,"")
                chunk[:text].gsub!(/\s+/," ")
        
                ## Comments and other actual html tags
                chunk[:text].gsub!(/<!--.*?-->/,"")
                chunk[:text].gsub!(/<(?:a|img) .*?\/>/,"")

                chunk[:text].gsub!(/[^\w\s]/," ")
                chunk[:text].gsub!(/\s\s+/," ")
                
                next unless chunk[:text].split(/\s/).count >= 10
                
                File.open( "#{path}/#{chunk[:id]}", "a+" ) { |f| f.write "#{chunk[:text]}\n" }


                
                pb.increment
            end

            files = %x{ find ./corpus/*/*/* }.split(/\n/)
            print "\n"
            pb = ProgressBar.create(:title => "| Normalizing #{files.count} buckets", :starting_at => 0, :total => files.count )

            files.each do |f|

                ##  remove code/link/quote/etc tags from the posts
                ##  Example: [code:kfj293] <source here.. forever and ever .. until> [/code:kfj293] 
                %x{ sed -i 's/\[\([a-z]*\).*:\([a-z0-9]*\)\].*\[\/\1:\2\]//g' #{f} }
                %x{ sed -i 's/&quot;/"/g' #{f} }
                %x{ sed -i 's/&lt;/</g' #{f} }
                %x{ sed -i 's/&gt;/>/g' #{f} }
                pb.increment
            end
        end
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
            @@data              = Hash.new
            @@analysis          = Array.new
        end

        def generate( opts )
            count = opts[:args].fetch :count
            @@data[:top_authors] = %x{ wc -l corpus/*/*/* | sort  |tail -n#{count + 1} | head -n#{count} |awk '{ print $2 }' }.split(/\n/)

            if @@data[:top_authors].count == 0
                puts "Error, only got #{@data[:top_authors]} authors.  Check your corpus"
                exit
            end

            style = opts.fetch :style
            args  = opts.fetch :args
            CStyl::Analysis.send( style.to_sym, args )
        end


        ##
        ##  syllable_count = count_syllables("lolocaust")
        ##
        def self.num_syllables(word)
            word.downcase!
            return 1 if word.length <= 3

            word.sub!(/(?:[^laeiouy]es|ed|[^laeiouy]e)$/, '')
            word.sub!(/^y/, '')
            word.scan(/[aeiouy]{1,2}/).size
        end


        ##  9-Feature set
        ##  Unique words, complexity/rarity of words, sentence count, letter count,
        ##  syllable count, gunning-fog index, flesch score
        ##
        def self.nine_feature( args )
       
            ##  Sentence count first, then loop through sentences counting words,  
            ##  letters, syllables, and indexes

            ## Going to push different author stats (type Hash) into this array
            @@data[:stats] = Array.new
    
            pb = ProgressBar.create(    :title => "| Analyzing top #{@@data[:top_authors].count} buckets", 
                                        :starting_at => 0, :total => @@data[:top_authors].count )
            @@data[:top_authors].each do |a|

                ## FUCKING DO ME FIRST
                ## Split bucket into 50 chunks, run below functions on each
                ## then return the averages.  expirement with give/take limits
                ## for comparisons.


                ## We will push this onto @@data[:authors]

                author_data = { :id => a, :letter_count => 0,
                                :word_count => 0, :syllable_count => 0 }

                chunk_data_collector = []

                ##  Split the authors file into 500 word chunks
                ##
                chunks = IO.read( a ).force_encoding("ISO-8859-1").encode("utf-8", replace: nil )
                chunks = chunks.scan(/((?:\b\w+\b\s*){500})/)

                puts "Chunks: #{chunks.count}"

                chunks.each do |c|
                    pp chunk
                    puts "\n\n\n\n\n\n#####################################################################\n\n\n\n\n"

                    chunk_data = { :id => a, :letter_count => 0,
                                :word_count => 0, :syllable_count => 0 }

                    chunk_data[:word_count]        += c.split(/\s+/).count
                    chunk_data[:letter_count]      += c.scan(/\S/).count

                    sentences = c.split(/[.!?]/)
                    chunk_data[:sentence_count] = sentences.count

                    sentences.each do |sen|
                        sen.split(/[ ,]/).each do |w|
                            chunk_data[:syllable_count]   += self.num_syllables( w )
                        end
                    end



                    ## Get 50 most common words
                    chunk_data[:common_words] = get_tokens( a.to_s, 50 )


                    ##  The result is a number that corresponds with a grade level. For example, a 
                    ##  score of 8.2 would indicate that the text is expected to be understandable 
                    ##  by an average student in eighth grade (usually around ages 12–14 in the 
                    ##  United States of America). The sentence, "The Australian platypus is seemingly 
                    ##  a hybrid of a mammal and reptilian creature" is a 13.1 as it has 26 syllables 
                    ##  and 13 words.
                    pp author_data[:id]
                    p author_data[:word_count].class
                    pp author_data[:word_count]
                    p author_data[:sentence_count].class
                    pp author_data[:sentence_count]

                    chunk_data[:flesch_score] = 0.39 * ( author_data[:word_count] / author_data[:sentence_count] ) + 11.8 
                    chunk_data[:flesch_score] = chunk_data[:flesch_score] * ( author_data[:syllable_count] / author_data[:word_count] ) - 15.59



                    chunk_data_collector.push chunk_data
                end
                
                ## chunk_data_collector
                # a = [ { :a => 1, :b => 2 }, { :a => 4, :b => 6 }, { :a => 5, :b => 8 } ]

                ## collect sums
                sums = chunk_data_collector.each_with_object( { flesch_score: 0, 
                        common_words: 0, unique_words: 0, complexity: 0, sentence_count: 0,
                        letter_count: 0, syllable_count: 0, gunning_fog: 0 } ) do |hsh, sums| 

                    sums[:flesch_score] += hsh[:flesch_score]
                    sums[:common_words] += hsh[:common_words]
                    sums[:letter_count] += hsh[:letter_count]
                    sums[:syllable_count] += hsh[:syllable_count]
                    sums[:gunning_fog] += hsh[:gunning_fog]
                    sums[:unique_words] += hsh[:unique_words]
                    sums[:complexity] += hsh[:complexity]
                    sums[:sentence_count] += hsh[:sentence_count]
                end

                # iterate through sums and calculate averages
                sums.map{ |k,v| [ k, v / chunk_data_collector.size ] }.each do |a|
                    # 0 => :key
                    # 1 => \d
                    author_data[a[0]] = a[1]
                end

                md5 = author_data[:id].gsub!(/^.*\//,"")
                
                dirs = md5.match(/^(?<first>.)(?<second>.)/)
                path = File.join( "./reports/", dirs['first'], dirs['second'] )

                unless File.directory?( path )
                    %x{ mkdir -p #{ path } }
                end

                ##  Create a record file for future comparison 
                File.open( "#{path}/#{md5}", "w" ) { |f| f.write author_data.to_yaml }

                pb.increment
            end

            "-".hline
            puts "\n\n"

            @@data[:top_authors]
        end


        ##  get_tokens( author_file ) 
        def self.get_tokens( input, limit = 50 )
        
            tokens = IO.read( input ).force_encoding("ISO-8859-1").encode("utf-8", replace: nil ).downcase.split(/[\d\W]/)

            mcw     = Hash.new(0)       # most common word

            for string in tokens
                mcw[string] += 1
            end

            ##  Filter out useless words.
            mcw.delete_if do |k,v|
                [   "quote", "about", "would", "there", "which", "people"
                ].include? k or k.length < 5
            end

            ## sort the data, highest occurances first, and hash them        
            Hash[ mcw.sort { |a,b| -1*(a[1] <=> b[1]) }[0..limit] ]
        end
    end

end


