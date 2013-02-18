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




┌[gift@hercales] [/dev/pts/0] [master ⚡] 

└[~/code/ruby/cstyl]> ruby style.rb
Generating 9-feature set statistics on 29 authors
[{:id=>"corpus/3/d/3def184ad8f4755ff269862ea77393dd", :sentence_count=>2378},
 {:id=>"corpus/3/8/38ca89564b2259401518960f7a06f94b", :sentence_count=>3984},
 {:id=>"corpus/5/b/5b8add2a5d98b1a652ea7fd72d942dac", :sentence_count=>4512},
 {:id=>"corpus/2/9/299a23a2291e2126b91d54f3601ec162", :sentence_count=>7610},
 {:id=>"corpus/1/7/17fafe5f6ce2f1904eb09d2e80a4cbf6", :sentence_count=>5274},
 {:id=>"corpus/f/c/fcac695db02687ffb7955b66a43fe6e6", :sentence_count=>4226},
 {:id=>"corpus/4/4/44f683a84163b3523afe57c2e008bc8c", :sentence_count=>6649},
 {:id=>"corpus/e/a/eafc8fe9c61d6760ae284c29840bbf0b", :sentence_count=>3519},
 {:id=>"corpus/3/d/3dde889723e33ace6af907cd5cc8e187", :sentence_count=>5009},
 {:id=>"corpus/2/1/211fa07fbd5ca833b4cfd48c462138a9", :sentence_count=>11206},
 {:id=>"corpus/1/6/1679091c5a880faf6fb5e6087eb1b2dc", :sentence_count=>7017},
 {:id=>"corpus/1/0/10a5ab2db37feedfdeaab192ead4ac0e", :sentence_count=>4839},
 {:id=>"corpus/7/f/7ffb4e0ece07869880d51662a2234143", :sentence_count=>9471},
 {:id=>"corpus/3/0/30a237d18c50f563cba4531f1db44acf", :sentence_count=>8140},
 {:id=>"corpus/0/6/0663a4ddceacb40b095eda264a85f15c", :sentence_count=>4462},
 {:id=>"corpus/1/b/1bf2efbbe0c49b9f567c2e40f645279a", :sentence_count=>3767},
 {:id=>"corpus/3/d/3dd48ab31d016ffcbf3314df2b3cb9ce", :sentence_count=>7214},
 {:id=>"corpus/2/9/2912bbeedc16c67bd0529ab7d438c1ac", :sentence_count=>8839},
 {:id=>"corpus/5/0/50dd7100bcbd98c41b1179143a2325a4", :sentence_count=>12345},
 {:id=>"corpus/b/d/bd686fd640be98efaae0091fa301e613", :sentence_count=>7096},
 {:id=>"corpus/7/1/7126c3a6111f0dc9f0bc7ecd4325b63d", :sentence_count=>43839},
 {:id=>"corpus/8/c/8cea559c47e4fbdb73b23e0223d04e79", :sentence_count=>13254},
 {:id=>"corpus/8/a/8a50bae297807da9e97722a0b3fd8f27", :sentence_count=>10001},
 {:id=>"corpus/c/4/c4ca4238a0b923820dcc509a6f75849b", :sentence_count=>10476},
 {:id=>"corpus/c/0/c06d06da9666a219db15cf575aff2824", :sentence_count=>13896},
 {:id=>"corpus/8/b/8b4066554730ddfaa0266346bdc1b202", :sentence_count=>16321},
 {:id=>"corpus/f/e/fe70c36866add1572a8e2b96bfede7bf", :sentence_count=>8323},
 {:id=>"corpus/6/c/6cf821bc98b2d343170185bb3de84cc4", :sentence_count=>18282},
 {:id=>"corpus/7/1/71f07bf95f0113eefab12552181dd832", :sentence_count=>20432}]



