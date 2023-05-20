#!/usr/bin/bash

ko=$1
# 下载ko号查询的结果
echo "mwget -n 32 -f $ko 'https://www.kegg.jp/dbget-bin/www_bfind_sub?mode=bfind&max_hit=100000000&locale=en&serv=kegg&dbkey=genes&keywords=$ko&page=1'"

# 根据条件过滤，（根据实际情况过滤）
echo "./parse_ko_search_result.py  $ko > $ko.table"

# 下载蛋白序列
echo "mkdir $ko.fnas"
echo "perl -ne 'chomp;@l=split/\\s+/;print \"mwget -n 32 -f $ko.fnas/\$l[0].fasta \\\"https://www.kegg.jp/dbget-bin/www_bget?-f+-n+a+\$l[0]\\\"\\n\"' $ko.table | parallel -j 8 --plus {}"

# 合并文件
echo "cat $ko.fnas/* > $ko.fasta"

# 提取序列
echo "le $ko.fasta | perl -ne 'chomp;if (\$_=~/^<!-- bget:db:genes -->/){\$_=~/<!-- bget:db:genes --><!--.*-->&gt;(.*)/;print \">\$1\\n\"}elsif( \$_=~/^$/ or \$_=~/^</ ){next}else{print \"\$_\\n\"}' > $ko.fastas"
echo "mv $ko.fastas $ko.fasta"

echo "rm $ko.table $ko"
