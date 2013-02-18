#!/usr/bin/env ruby

require_relative './cstyl.rb'


corpus = CStyl::Corpus.new
stats  = CStyl::Analysis.new

corpus.generate( :type => "phpbb", :args => {
                    :db => {    :user => "roobay",
                                :pass => "butts",
                                :host => "localhost",
                                :db_name => "htd0rg"  } } )


stats.generate( :style => "nine_feature", :args => nil )[:stats].each do |a|
    puts "Author: #{a[:id].gsub!(/^.*?\/.\/.\//,"")}"
    puts "\tsc: #{a[:sentence_count]}"
    puts "\twc: #{a[:word_count]}"
    puts "\tlc: #{a[:letter_count]}\n\n"

end

