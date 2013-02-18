#!/usr/bin/env ruby

require_relative './cstyl.rb'


#corpus = CStyl::Corpus.new
stats  = CStyl::Analysis.new

#corpus.generate( :type => "phpbb", :args => {
#                    :db => {    :user => "roobay",
#                                :pass => "butts",
#                                :host => "localhost",
#                                :db_name => "some_phpbb_db"  } } )


stats.generate( :style => "nine_feature", :args => nil )[:stats].each do |a|
    puts "Author: #{a[:id].gsub!(/^.*?\/.\/.\//,"")}"
    puts "\tsentences:\t #{a[:sentence_count]}"
    puts "\twords:\t\t #{a[:word_count]}"
    puts "\tletters:\t #{a[:letter_count]}"
    puts "\tsyllables:\t #{a[:syllable_count]}\n\n"
end

