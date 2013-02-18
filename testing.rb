corpus = CStyl::Corpus.new
stats  = CStyl::Analysis.new

corpus.generate( :type => "phpbb", :args => {
                    :db => {    :user => "roobay",
                                :pass => "butts",
                                :host => "localhost",
                                :db_name => "htd0rg"  } } )


pp stats.generate( :style => "nine_feature", :args => nil )[:stats]

