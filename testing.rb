#!/usr/bin/env ruby

require_relative './cstyl.rb'


#corpus = CStyl::Corpus.new
stats  = CStyl::Analysis.new

#=begin
corpus.generate( :type => "phpbb", :args => {
                    :db => {    :user => "roobay",
                                :pass => "butts",
                                :host => "localhost",
                                :db_name => "some_php_db"  } } )
#=end

res = stats.generate( :style => "nine_feature", :args => { :count => 4 } )

puts res[:stats].to_yaml

