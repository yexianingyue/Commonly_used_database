#!/usr/bin/bash
ko=$1
echo "ls $ko.fnas/ | awk -F \".fasta\" '{print \$1}'> temp"
echo "grep -v  -f temp $ko.table > temp.name"
echo "perl -ne 'chomp;@l=split/\\s+/;print \"mwget -n 32 -f $ko.fnas/\$l[0].fasta \\\"https://www.kegg.jp/dbget-bin/www_bget?-f+-n+a+\$l[0]\\\"\\n\"' temp.name | parallel -j 8 --plus {}"
echo "rm temp"
