#!/usr/bin/env ruby

require_relative './cstyl.rb'


#corpus = CStyl::Corpus.new
stats  = CStyl::Analysis.new

=begin
corpus.generate( :type => "phpbb", :args => {
                    :db => {    :user => "roobay",
                                :pass => "butts",
                                :host => "localhost",
                                :db_name => "htd0rg"  } } )
=end

stats.generate( :style => "nine_feature", :args => nil )[:stats].each do |a|
    puts a.to_yaml
=begin
    puts "Author: #{a[:id].gsub!(/^.*?\/.\/.\//,"")}"
    puts "\tsentences:\t #{a[:sentence_count]}"
    puts "\twords:\t\t #{a[:word_count]}"
    puts "\tletters:\t #{a[:letter_count]}"
    puts "\tsyllables:\t #{a[:syllable_count]}\n"
    puts "\tflesch:\t\t #{a[:flesch_score]}\n"
    puts a[:common_words].to_yaml
=end
    puts "\n\n"
end

