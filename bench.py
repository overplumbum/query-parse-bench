#!/usr/bin/env python3
from subprocess import check_call

cmds = [
    "gcc  -O3 parse-strpos.c -o bin/parse-strpos.c.out && time ./bin/parse-strpos.c.out",
    "go build parse-split.go  && time ./parse-split",
    "javac parse_fair.java && time java parse_fair",
    "go build parse-fair.go && time ./parse-fair",
    "time pypy -S parse-fair.py",
    "time php parse-fair.php",
    "time perl parse-split.pl",
    "time node parse-fair.js",
    "time python -S parse-fair.py",
    "time python3 -S parse-fair.py",
    "time perl parse-fair.pl",
]

for n in range(1):
    for cmd in cmds:
        print("\n-----", cmd)
        check_call(cmd, shell=True)
