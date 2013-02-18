/* Example usage */

corpus = CStyl::Corpus.new
stats  = CStyl::Analysis.new

corpus.generate( :type => "phpbb", :args => {
                    :db => {    :user => "roobay",
                                :pass => "butts",
                                :host => "localhost",
                                :db_name => "some_phpbb_db"  } } )


pp stats.generate( :style => "nine_feature" )[:stats]

/* End example usage */



[gift@hercales ~/code/ruby/cstyl]$ ruby style.rb 

Handling 95090 rows from phpbb_posts
Rows: |============================================================|

Generating 9-feature set statistics on 10 authors
Buckets analyzed: |================================================|


[{:id=>"corpus/b/d/bd686fd640be98efaae0091fa301e613",
  :letter_count=>394931,
  :word_count=>92182,
  :sentence_count=>5839},
 {:id=>"corpus/5/0/50dd7100bcbd98c41b1179143a2325a4",
  :letter_count=>537970,
  :word_count=>118753,
  :sentence_count=>8543},
 {:id=>"corpus/8/c/8cea559c47e4fbdb73b23e0223d04e79",
  :letter_count=>704314,
  :word_count=>141911,
  :sentence_count=>11451},
 {:id=>"corpus/8/a/8a50bae297807da9e97722a0b3fd8f27",
  :letter_count=>455574,
  :word_count=>98134,
  :sentence_count=>7366},
 {:id=>"corpus/c/4/c4ca4238a0b923820dcc509a6f75849b",
  :letter_count=>509432,
  :word_count=>101525,
  :sentence_count=>7529},
 {:id=>"corpus/c/0/c06d06da9666a219db15cf575aff2824",
  :letter_count=>1042758,
  :word_count=>231098,
  :sentence_count=>11436},
 {:id=>"corpus/8/b/8b4066554730ddfaa0266346bdc1b202",
  :letter_count=>763450,
  :word_count=>151812,
  :sentence_count=>14293},
 {:id=>"corpus/f/e/fe70c36866add1572a8e2b96bfede7bf",
  :letter_count=>596388,
  :word_count=>118528,
  :sentence_count=>7416},
 {:id=>"corpus/6/c/6cf821bc98b2d343170185bb3de84cc4",
  :letter_count=>680167,
  :word_count=>142250,
  :sentence_count=>8419},
 {:id=>"corpus/7/1/71f07bf95f0113eefab12552181dd832",
  :letter_count=>1331379,
  :word_count=>265121,
  :sentence_count=>17802}]

