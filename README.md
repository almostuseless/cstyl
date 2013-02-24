About
-----
CStyl ([C]omputational [Styl]istics) is a stylometry project that aims to implement some of the functionality of the JStylo-Anonymouth framework (https://psal.cs.drexel.edu/index.php/JStylo-Anonymouth) in ruby.  I don't expect it to actually be useful for weeks.

Usage
----- 
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


    ##  stats.generate returns a list of analyzed author ids
    ##  reports generated in ./reports/3/d/3dd48ab31d016ffcbf3314df2b3cb9ce
    #   ["3dd48ab31d016ffcbf3314df2b3cb9ce",
    #    "2912bbeedc16c67bd0529ab7d438c1ac",...]
    stats = stats.generate( :style => "nine_feature", :args => { :count => 5 } )

    stats.count.times do |n|
        puts "  (#{n+1}/#{stats.count}) Generated report for #{stats[n]}"
    end

Expected output
---------------
    [gift@heracles cstyl]$ ruby testing.rb 

            CStyl -- phpbb analysis
    +---------------------------------------------------------------------+
    | Handling 39937 rows: |==============================================|
    | Normalizing 3595 buckets: |=========================================|
    | Analyzing top 5 buckets: |==========================================|
    +---------------------------------------------------------------------+

      (1/5) Generated report for 8b4066554730ddfaa0266346bdc1b202
      (2/5) Generated report for fe70c36866add1572a8e2b96bfede7bf
      (3/5) Generated report for 6cf821bc98b2d343170185bb3de84cc4
      (4/5) Generated report for c06d06da9666a219db15cf575aff2824
      (5/5) Generated report for 71f07bf95f0113eefab12552181dd832

    [gift@heracles cstyl]$ tree reports/
    reports/
    |-- 6
    |   `-- c
    |       `-- 6cf821bc98b2d343170185bb3de84cc4
    |-- 7
    |   `-- 1
    |       `-- 71f07bf95f0113eefab12552181dd832
    |-- 8
    |   `-- b
    |       `-- 8b4066554730ddfaa0266346bdc1b202
    |-- c
    |   `-- 0
    |       `-- c06d06da9666a219db15cf575aff2824
    `-- f
        `-- e
            `-- fe70c36866add1572a8e2b96bfede7bf

    10 directories, 5 files

    [gift@heracles cstyl]$ cat reports/6/c/6cf821bc98b2d343170185bb3de84cc4 
    ---
    :id: 6cf821bc98b2d343170185bb3de84cc4
    :letter_count: 521997
    :word_count: 109806
    :syllable_count: 165572
    :sentence_count: 5971
    :common_words:
      password: 223
      because: 207
      their: 202
      program: 171
      ...
      class: 85
      encryption: 84
      different: 83
    :flesch_score: 3.2300000000000004

