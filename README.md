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
        puts "\tlc: #{a[:letter_count]}\n\n"

    end


Example Output
--------------
    [gift@hercales cstyl]$ ruby testing.rb 
    ----------------------
            PPHPBB
    ----------------------
    Handling 95090 rows: |=======================================  |
    Analyzing 10 authors: |========================================|
    Author: bd686fd640be98efaae0091fa301e613
        sc: 12279
        wc: 184596
        lc: 784712

    Author: 50dd7100bcbd98c41b1179143a2325a4
        sc: 16997
        wc: 236520
        lc: 1067382

    Author: 8cea559c47e4fbdb73b23e0223d04e79
        sc: 22899
        wc: 283267
        lc: 1394476

    Author: 8a50bae297807da9e97722a0b3fd8f27
        sc: 14639
        wc: 193987
        lc: 873326

    Author: c4ca4238a0b923820dcc509a6f75849b
        sc: 15017
        wc: 202077
        lc: 1008538

    Author: c06d06da9666a219db15cf575aff2824
        sc: 22797
        wc: 460877
        lc: 2065592

    Author: 8b4066554730ddfaa0266346bdc1b202
        sc: 28511
        wc: 302537
        lc: 1511028

    Author: fe70c36866add1572a8e2b96bfede7bf
        sc: 14763
        wc: 235571
        lc: 1159144

    Author: 6cf821bc98b2d343170185bb3de84cc4
        sc: 16805
        wc: 283117
        lc: 1339730

    Author: 71f07bf95f0113eefab12552181dd832
        sc: 35495
        wc: 528819
        lc: 2646092

