#!/usr/bin/env python3
from subprocess import check_call

cmds = [
    "gcc  -O3 parse-strpos.c -o bin/parse-strpos.c.out && time ./bin/parse-strpos.c.out",
    "javac parse_fair.java && time java parse_fair",
    "go build parse-fair.go && time ./parse-fair",
    "time pypy -S parse-fair.py",
    "time python -S parse-fair.py",
    "time python3 -S parse-fair.py",
    "time node parse-fair.js",
    "erlc parse_fair.erl && time erl -s parse_fair -s init stop -noshell",
]
for n in range(5):
    for cmd in cmds:
        print("\n-----", cmd)
        check_call(cmd, shell=True)
