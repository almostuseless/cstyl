Example usage
-------------

    #!/usr/bin/env ruby
    require_relative './cstyl.rb'


    corpus = CStyl::Corpus.new
    stats  = CStyl::Analysis.new

    corpus.generate( :type => "phpbb", :args => {
                        :db => {    :user => "roobay",
                                    :pass => "butts",
                                    :host => "localhost",
                                    :db_name => "some_phpbb_db"  } } )


    stats.generate( :style => "nine_feature", :args => nil )[:stats].each do |a|
        puts "Author: #{a[:id].gsub!(/^.*?\/.\/.\//,"")}"
        puts "\tsc: #{a[:sentence_count]}"
        puts "\twc: #{a[:word_count]}"
        puts "\tlc: #{a[:letter_count]}\n"
        puts "\tflesch:\t\t #{a[:flesch_score]}\n\n"

    end


Example output
--------------
    [gift@hercales cstyl]$ ruby testing.rb 
    ----------------------
            PPHPBB
    ----------------------

    Handling 95090 rows: |=========================================|
    Analyzing 3 authors: |=========================================|

    Author: fe70c36866add1572a8e2b96bfede7bf
        sentences:   7382
        words:       117785
        letters:     579572
        syllables:   181198
        flesch:      2.0600000000000023

    Author: 6cf821bc98b2d343170185bb3de84cc4
        sentences:   8403
        words:       141558
        letters:     669865
        syllables:   212069
        flesch:      2.4499999999999993

    Author: 71f07bf95f0113eefab12552181dd832
        sentences:   17748
        words:       264409
        letters:     1323046
        syllables:   407555
        flesch:      1.6700000000000017

