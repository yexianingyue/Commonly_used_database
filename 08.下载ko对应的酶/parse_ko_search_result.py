#!/share/data1/zhangy/software/miniconda/envs/bio37/bin/python
import re
import sys
import argparse

def get_args():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawTextHelpFormatter)
    parser.add_argument("i", metavar="<html>", help="download the result of search for ko number")
    args = parser.parse_args()
    return args

def main(file_):
    f = open(file_, 'r')
    for line in f:
        # 找定位行
        if re.search(r"div\s+style=.width:600px.>", line.strip()):
            # 解析
            pattern = re.compile(r'<div style="width:600px"><a href=.*?>(.*?)</a><br><div style=.margin-left:2em">\s+(K\d{5})\s+(.*?)</div></div>')
            gene_iter = re.finditer(pattern, line.strip())
            for gene in gene_iter:
                print(f'{gene.group(1)}\t{gene.group(2)}\t{gene.group(3)}')
    f.close()



if __name__ == "__main__":
    args = get_args()
    input_file = args.i
    main(input_file)
