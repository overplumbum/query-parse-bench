#!/usr/bin/env python3
from subprocess import check_call
from time import time
import sys


cmds = [
    # (runner, method, cmd_build, cmd_run)
    ("c",    "strpos", "gcc  -O3 parse-strpos.c -o bin/parse-strpos.c.out", ["./bin/parse-strpos.c.out"]),
    ("java", "split",  "javac parse_split.java", ["java", "parse_split"]),
    ("pypy", "split",  "true", ["pypy", "-S", "parse-split.py"]),
    ("go",   "split",  "go build parse-split.go", ["./parse-split"]),
    ("java", "fair",   "javac parse_fair.java", ["java", "parse_fair"]),
    ("go",   "fair",   "go build parse-fair.go", ["./parse-fair"]),
    ("pypy", "fair",   "true", ["pypy", "-S", "parse-fair.py"]),
    ("node", "split",  "true", ["node", "parse-split.js"]),
    ("php",  "split",  "true", ["php", "parse-split.php"]),
    ("php",  "fair",   "true", ["php", "parse-fair.php"]),
    ("perl", "split",  "true", ["perl", "parse-split.pl"]),
    ("node", "fair",   "true", ["node", "parse-fair.js"]),
    ("py2",  "split",  "true", ["python", "-S", "parse-split.py"]),
    ("py3",  "split",  "true", ["python3", "-S", "parse-split.py"]),
    ("py2",  "fair",   "true", ["python", "-S", "parse-fair.py"]),
    ("py3",  "fair",   "true", ["python3", "-S", "parse-fair.py"]),
    ("perl", "fair",   "true", ["perl", "parse-fair.pl"]),
    ("erlang", "split", "erlc parse_split.erl", ["erl", "-noshell", "-s", "parse_split",
                                                 "-s", "init", "stop"])
]

if len(sys.argv) == 3:
    cmds = filter(lambda cmd: cmd[0] == sys.argv[1] and cmd[1] == sys.argv[2], cmds)

methods = {}
runners = {}

results = {}
for runner, method, cmd_build, cmd_run in cmds:
    check_call(cmd_build, shell=True)

    t0 = time()
    check_call(cmd_run)
    t1 = time()
    dt = t1 - t0
    dt = round(dt, 1)

    results[(runner, method)] = dt
    print(runner, method, dt, "seconds")

    runners[runner] = min(runners.get(runner, float('+infinity')), dt)
    methods[method] = min(methods.get(method, float('+infinity')), dt)


runners = [k for k, v in sorted(runners.items(), key=lambda kv: kv[1])]
methods = [k for k, v in sorted(methods.items(), key=lambda kv: kv[1])]

with open('results.md', 'w') as f:
    f.write('<table>\n')
    f.write('<tr><td></td>')
    for method in methods:
        f.write('<td>{}</td>'.format(method))
    f.write('</tr>\n')
    for runner in runners:
        f.write('<tr><td>{}</td>'.format(runner))
        for method in methods:
            f.write('<td>{}</td>'.format(results.get((runner, method), '-')))
        f.write('</tr>\n')
    f.write('</table>\n')
