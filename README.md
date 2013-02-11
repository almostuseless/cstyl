<pre>The split_* files were generated by grepping hundreds of my irc client's logs and dropping them 
into one massive log file in "nick\tline" format.  Then I just split them into 50M chunks.

This will eventaully become a little gem, in the mean time (while nobody is looking at this let alone 
using it) it will be littered with debug prints and bugs.


  ┌[gift@hercales] [/dev/pts/2] [master ⚡] [1]
  └[~/code/ruby/styleometry]> wc -l split_* | tail -n1
  64714194 total
  ┌[gift@hercales] [/dev/pts/2] [master ⚡] [1]
  └[~/code/ruby/styleometry]> ls split_* | wc -l
  62

┌[gift@hercales] [/dev/pts/2] [master ⚡] [1]
└[~/code/ruby/styleometry]> ruby style.rb 
[!] Parsed split_af in 17.690817853 seconds
[!] Parsed split_ag in 19.397118967 seconds
[!] Parsed split_ad in 24.621972469 seconds
[!] Parsed split_ai in 14.297384109 seconds
[!] Parsed split_aj in 14.291513438 seconds
[!] Parsed split_ae in 20.250193035 seconds
[!] Parsed split_ah in 17.32401369 seconds
[!] Parsed split_ak in 4.987984362 seconds
[!] Parsed split_al in 4.550254255 seconds
[!] Parsed split_am in 4.452305244 seconds
[!] Parsed split_an in 3.112541644 seconds
[!] Parsed split_ao in 2.625462347 seconds
[!] Parsed split_ap in 6.897675846 seconds
[!] Parsed split_aq in 5.894091006 seconds
[!] Parsed split_ar in 12.252251286 seconds
[!] Parsed split_at in 9.116133221 seconds
[!] Parsed split_as in 9.472793855 seconds
[!] Parsed split_au in 6.523935429 seconds
[!] Parsed split_ac in 53.890311108 seconds
[!] Parsed split_av in 4.289261033 seconds
[!] Parsed split_aw in 5.05737248 seconds
[!] Parsed split_ax in 3.955730088 seconds
[!] Parsed split_ay in 5.425470104 seconds
[!] Parsed split_az in 5.318637343 seconds
[!] Parsed split_bb in 4.387725621 seconds
[!] Parsed split_ba in 12.009313425 seconds
[!] Parsed split_bd in 10.538917874 seconds
[!] Parsed split_bc in 10.38006617 seconds
[!] Parsed split_bf in 10.860194801 seconds
[!] Parsed split_be in 10.349241939 seconds
[!] Parsed split_bg in 3.972738322 seconds
[!] Parsed split_bi in 6.909467563 seconds
[!] Parsed split_bj in 7.451152706 seconds
[!] Parsed split_bh in 7.324438545 seconds
[!] Parsed split_bk in 5.165533824 seconds
[!] Parsed split_bl in 2.697767691 seconds
[!] Parsed split_bm in 5.65705918 seconds
[!] Parsed split_bn in 11.659711545 seconds
[!] Parsed split_bo in 10.534464531 seconds
[!] Parsed split_bp in 12.751522154 seconds
[!] Parsed split_br in 11.599226551 seconds
[!] Parsed split_bq in 11.84186149 seconds
[!] Parsed split_bs in 6.30683914 seconds
[!] Parsed split_bt in 6.99539126 seconds
[!] Parsed split_bu in 7.168449011 seconds
[!] Parsed split_bx in 4.356216527 seconds
[!] Parsed split_bv in 7.751947135 seconds
[!] Parsed split_bw in 9.442375842 seconds
[!] Parsed split_bz in 7.656396526 seconds
[!] Parsed split_by in 5.924452543 seconds
[!] Parsed split_cb in 3.860343256 seconds
[!] Parsed split_ca in 7.154391087 seconds
[!] Parsed split_cc in 8.615442486 seconds
[!] Parsed split_cd in 11.488097518 seconds
[!] Parsed split_ce in 11.603179415 seconds
[!] Parsed split_cf in 13.777847976 seconds
[!] Parsed split_cg in 9.902605305 seconds
[!] Parsed split_ch in 10.113498802 seconds
[!] Parsed split_ci in 3.691976651 seconds
[!] Parsed split_cj in 2.96978861 seconds
[!] Parsed split_ab in 178.431107721 seconds
[!] Parsed split_aa in 206.378440286 seconds
</pre>