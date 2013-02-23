#!/usr/bin/env ruby

require_relative './cstyl.rb'


corpus = CStyl::Corpus.new
stats  = CStyl::Analysis.new

#=begin
corpus.generate( :type => "phpbb", :args => {
                    :db => {    :user => "roobay",
                                :pass => "butts",
                                :host => "localhost",
                                :db_name => "some_phpbb_db"  } } )
#=end

stats.generate( :style => "nine_feature", :args => nil )[:stats].each do |a|
    puts a.to_yaml
end

