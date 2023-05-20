## v 3.4.0
```bash
conda search drep -c bioconda # 首先查看版本
conda create -n drep3 drep=3.4.0 -c bioconda # 安装对应版本
source activate drep3
```
Quick start
```bash
dRep  dereplicate  -g fastas/*.fna -p 28 -pa 0.1 -nc 0.3 --ignoreGenomeQuality  --S_algorithm fastANI test
```


### 修改
#### 1、fastANI 报错
如果`which fastANI`可以返回具体路径，那就说明是程序出问题了
```
ValueError: fastANI isn't working- make sure its installed
```
出错脚本在这
`envs/drep3/lib/python3.7/site-packages/drep/d_bonus.py`

函数`find_program`在判断`fastANI`时出错，因为`fastANI -h `返回**非**`0`数值，程序会判断为出错，
所以在函数内部添加判断语句:
当参数为`fastANI`时，直接`work=True`

**找到它，并且修改它为**
`vim envs/drep3/lib/python3.7/site-packages/drep/d_bonus.py`
```python
def find_program(dep):
    '''
    return location of progrgam, works = True/False (based on calling the help)
    '''
    # find the location of the program
    loc = shutil.which(dep)

    # make sure the help on the program works
    works = False
    if (dep == "fastANI"):
        works=True
        return loc,works
    if loc != None:
        try:
            o = subprocess.check_output([loc, '-h'],stderr= subprocess.STDOUT)
            works = True
        except:
            pass

    return loc, works

```

#### 2、fastANI 参数报错
如果不报这个错误，就别修改了
```bash
FileNotFoundError: [Errno 2] No such file or directory: 'test/dRep/test/data/fastANI_files/fastANI_out_beekzjgidy'
```
可能是软件`drep`参数有问题
运行`fastANI -h`
看看返回的结果中是`--minFrag`还是`--minFraction`，然后修改
`
envs/drep3/lib/python3.7/site-packages/drep/d_cluster/external.py
`
将`--minFraction`/`--minFrag`替换为`--minFrag`/`--minFraction`
