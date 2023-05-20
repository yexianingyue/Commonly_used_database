# 如何更新NCBI真菌信息库

## 1、首先从NCBI中下载Funig信息表

这个地址中的文件包含了所有biosample的信息 https://ftp.ncbi.nlm.nih.gov/biosample/
```bash
# 用于格式化数据，为了安全起见，还是得看看命令和处理结果有没有差异
le biosample_set.xml.gz | perl -e 'while(<>){chomp;if (/<Id db="BioSample".*?>(.*)<\/\S+>/){$sam="$1";next};if(/<Attribute attribute_name="(.*?)".*>(.*?)</){print "$sam\t$1\t$2\n"}}' | le
```

链接地址:https://www.ncbi.nlm.nih.gov/datasets/genome/?taxon=4751
这个网址也可以下载对应物种分类的信息表,只是不能过滤：
只有几个大分类：原核，真核，病毒，古细菌，细菌（这个表有taxid）
https://ftp.ncbi.nlm.nih.gov/genomes/genbank/

## 2、提取Genebank数据路径

```shell {.line-numbers}
# 二选一即可,然后去除第一行的表头就行
# 1.wget 
# awk -F "\t"  '{print $15"\t"$6}' eukaryotes.txt  | awk  '{split($1,a,"/");print "wget " $1"/"a[10]"_genomic.fna.gz -O Fungi/"$2".genomic.fna.gz"}' | le
# 2.mwget
awk -F "\t"  '{print $15"\t"$6}' eukaryotes.txt  | awk  '{split($1,a,"/");print "mwget -n 28 -f Fungi/"$2".genomic.fna.gz "$1"/"a[10]"_genomic.fna.gz"}' | le
```

## 3、去重

有个很大的坑：
就是如果数据有更新，版本号回变化，所以得注意 

```shell {.line-numbers, highlight=12}
# downloaded.list
fungi_1
fungi_2
fungi_3

# all.fungi.list
fungi_1
fungi_2
fungi_3

# 考虑版本号变化
le downloaded | perl -e '%h;while(<>){chmop;@l=split/\s+/;$h{$l[0]}=1;};open I,"all.fungi.list"; while(<I>){chmop;@l=split/\s+/;next if exists($h{$l[0]}); print $_}' > should.down.list 

# 不考虑版本号
# le downloaded | perl -e '%h;while(<>){chomp;$_=~m/(GCA_\d+)\.\d.*/;$h{$1}=1;};open I,"aaa"; while(<I>){chmop;$_=~m/(GCA_\d+)\.\d.*/;next if exists($h{$1}); print $_}'

```

## 4、fastANI

### 4.1、获取列表

### 5、根据taxid获取物种分类

到这个网址下载：https://ftp.ncbi.nih.gov/pub/taxonomy/
taxdump.tar.gz 
这里面就是注释需要的两个文件
names.dmp和nodes.dmp

```
# 这个可以根据taxid获取具体的分类信息
perl /share/data5/lish/database/genomes/taxid.fullname.pl 
# 输入文件格式: taxid  name
```

### 6、根据so，生成每个基因组的信息

```
parse_so_result.py Fungi_so/*.so | perl -ne 'chmop;@l=split/\t/;$l[0] =~ m/(GCA_\d+\.\d)/;print $1."\t".join("\t", @l[1..$#l])' > so.stat.f
```

### 7、肠道真菌种名

就是根据biosample的描述，直接确认的

|species|
|:-|
|[Candida] glabrata|
|Aspergillus flavus|
Candida albicans|
Candida parapsilosis|
Clavispora lusitaniae|
Diutina rugosa|
Enterocytozoon bieneusi|
Purpureocillium lilacinum|
Trichosporon asahii|
Saccharomyces cerevisiae|
Saccharomyces jurei|
Saccharomyces paradoxus|

#### 7.1、metagenome

之前有292个kidney样本，用他们mapping真菌，mapping上的即为肠道真菌。
种的列表如下，不包括  __sp.__(不定种)
|>|species|
|:-:|:-:|:-|:-|
Cyberlindnera fabianii| Sporothrix globosa|
Exophiala oligosperma| Cladophialophora bantiana|
Cladophialophora immunda| Trichosporon asahii|
Fonsecaea pedrosoi| Talaromyces marneffei|
Exophiala spinifera| Naumovozyma dairenensis|
Malassezia sympodialis| Candida dubliniensis|
[Candida] duobushaemulonis| Pichia kudriavzevii|
Pneumocystis jirovecii| Arthrocladium fulminans|
Cryptococcus gattii| Malassezia restricta|
[Candida] haemulonis| Stachybotrys chartarum|
Purpureocillium lilacinum| Lichtheimia corymbifera|
Phialophora verrucosa| Candida parapsilosis|
Paracoccidioides brasiliensis| Cladophialophora carrionii|
Cladosporium sphaerospermum| Malassezia yamatoensis|
Aureobasidium pullulans| Madurella mycetomatis|
Saccharomyces jurei| Rhizopus delemar|
Ochroconis constricta| Curvularia papendorfii|
Emergomyces orientalis| Syncephalastrum racemosum|
Phialophora americana| Exophiala xenobiotica|
Aspergillus fumigatus| Mucor indicus|
Candida orthopsilosis| Scedosporium boydii|
[Candida] pseudohaemulonis| Trichophyton rubrum|
Mucor irregularis| Malassezia japonica|
Saccharomyces paradoxus| Fonsecaea nubica|
[Candida] auris| Saccharomyces cerevisiae|
Fonsecaea monophora| Pallidocercospora crystallina|
Cryptococcus neoformans| Cokeromyces recurvatus|
Sporothrix schenckii| Cunninghamella bertholletiae|
Syncephalastrum monosporum| Aspergillus turcosus|
[Candida] glabrata| Penicillium capsulatum|
Debaryomyces fabryi| Malassezia globosa|
Candida albicans| Corynespora cassiicola|
Aspergillus thermomutatus| Lichtheimia ramosa|
Rhizopus oryzae| Pichia norvegensis|
Saksenaea oblongispora| Yarrowia lipolytica|
Apophysomyces trapeziformis| Trichosporon inkin|
Blastomyces percursus| Lomentospora prolificans|
Trichophyton mentagrophytes| Scedosporium apiospermum|
Clavispora lusitaniae| Aspergillus flavus|
Apophysomyces variabilis| Fusarium proliferatum|
Rhizopus microsporus| Histoplasma capsulatum|
Malassezia furfur| Hortaea werneckii|
Saksenaea vasiformis| Mucor velutinosus|
Mucor circinelloides| 


Cryptococcus neoformans AD hybrid是一个杂合的种，所以不计算在内

### 8、根据biosample寻找肠道真菌

|中文|英文|
|:-:|:-:|
口腔|oral cavity|
粪便|feces|
口腔粘膜|oral mucosa|


### 9、过滤

长度大于100M的不考虑
N50 < 20000的，不考虑

```

```
