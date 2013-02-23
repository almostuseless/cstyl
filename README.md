Example usage
-------------

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


Example output
--------------
    [gift@heracles cstyl]$ ruby testing.rb 
    ----------------------
            PPHPBB
    ----------------------
    Handling 39937 rows: |=========================================|
    Normalizing 3595 buckets: |====================================|
    Analyzing 3 authors: |=========================================|
    ---
    :id: corpus/f/e/fe70c36866add1572a8e2b96bfede7bf
    :letter_count: 405880
    :word_count: 80100
    :syllable_count: 125726
    :sentence_count: 4558
    :common_words:
      the: 2942
      to: 2273
      a: 2214
      i: 1965
      quot: 1760
      it: 1728
      you: 1567
      and: 1506
      of: 1493
      that: 1231
      is: 1147
    :flesch_score: 2.84
    ---
    :id: corpus/6/c/6cf821bc98b2d343170185bb3de84cc4
    :letter_count: 531288
    :word_count: 109806
    :syllable_count: 166918
    :sentence_count: 5971
    :common_words:
      the: 4768
      to: 3357
      i: 2993
      a: 2863
      it: 2469
      and: 2173
      you: 1863
      that: 1853
      of: 1745
      quot: 1569
      is: 1406
    :flesch_score: 3.2300000000000004
    ---
    :id: corpus/c/0/c06d06da9666a219db15cf575aff2824
    :letter_count: 982626
    :word_count: 216335
    :syllable_count: 322641
    :sentence_count: 10293
    :common_words:
      the: 8128
      to: 6021
      a: 5598
      and: 5016
      you: 4862
      of: 3908
      i: 3846
      it: 3736
      is: 2720
      that: 2416
      for: 2213
    :flesch_score: 4.400000000000002
    ---

