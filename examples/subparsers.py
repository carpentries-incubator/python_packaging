
# file: subparsers.py
from argparse import ArgumentParser

parser = ArgumentParser(description="A test program")

# set up subparsers, make them required
subparsers = parser.add_subparsers(required=True)

# add two subcommands: cmd1 and cmd2
parser1 = subparsers.add_parser("cmd1")
parser2 = subparsers.add_parser("cmd2")

# add some args to each
parser1.add_argument("foo")
parser1.add_argument("bar")
parser2.add_argument("baz")

# parse args and print what we get
args = parser.parse_args()
print(args)
