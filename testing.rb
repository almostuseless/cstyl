#!/usr/bin/env ruby

require_relative './cstyl.rb'


#corpus = CStyl::Corpus.new
stats  = CStyl::Analysis.new

#=begin
#corpus.generate( :type => "phpbb", :args => {
#                    :db => {    :user => "roobay",
#                                :pass => "butts",
#                                :host => "localhost",
#                                :db_name => "some_phpbb_db"  } } )
#=end


##  stats.generate returns a list of analyzed author ids
##  reports generated in ./reports/3/d/3dd48ab31d016ffcbf3314df2b3cb9ce
#   ["3dd48ab31d016ffcbf3314df2b3cb9ce",
#    "2912bbeedc16c67bd0529ab7d438c1ac",...]
stats = stats.generate( :style => "nine_feature", :args => { :count => 5 } )

stats.count.times do |n|
    puts "  (#{n+1}/#{stats.count}) Generated report for #{stats[n]}"
end


