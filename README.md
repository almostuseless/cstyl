Example usage
------------- 
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

Example output
--------------
    [gift@heracles cstyl]$ ruby testing.rb 
    ----------------------
            PPHPBB
    ----------------------
    Handling 39937 rows: |=========================================|
    Normalizing 3595 buckets: |====================================|
    Analyzing top 4 buckets: |=====================================|
    ---
    - :id: corpus/f/e/fe70c36866add1572a8e2b96bfede7bf
      :letter_count: 396378
      :word_count: 80100
      :syllable_count: 124083
      :sentence_count: 4558
      :common_words:
        the: 2942
        to: 2273
        a: 2214
        i: 1965
        it: 1728
        you: 1567
        and: 1506
        of: 1493
        that: 1231
        is: 1147
        quote: 972
      :flesch_score: 2.84
    - :id: corpus/6/c/6cf821bc98b2d343170185bb3de84cc4
      :letter_count: 521997
      :word_count: 109806
      :syllable_count: 165572
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
        is: 1406
        s: 1296
      :flesch_score: 3.2300000000000004
    - :id: corpus/c/0/c06d06da9666a219db15cf575aff2824
      :letter_count: 976499
      :word_count: 216335
      :syllable_count: 322174
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
