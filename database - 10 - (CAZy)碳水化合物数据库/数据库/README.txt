# download the detail infomation of CAZY class
http://bcb.unl.edu/dbCAN2/download/Databases/FamInfo.txt.04232020.xls

http://bcb.unl.edu/dbCAN2/download/CAZyDB.07312020.fa

# 处理下载的cazy数据库蛋白序列，因为有写有异常
perl -e 'open I, $ARGV[0];while(<I>){chomp;if ($_=~/>(.*)/){@l=split(/\|/, $1);$k=$_;$n=$l[0];next}elsif($k !~ /\|/){open (E, ">>$ARGV[2]");print E "$k\n$_\n";close (E)}elsif($_=~/[^ATCGatcg]/){print "$k\n$_\n"}else{open (M,">>$ARGV[1]");print M "$k\n$_\n";close(M)}}' CAZyDB.07312020.fa CAZyDB.07312020.seq.error.fna CAZyDB.07312020.name.error.faa > CAZyDB.07312020.clean.faa&
