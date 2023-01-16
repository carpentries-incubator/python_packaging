from argparse import ArgumentParser
from .plotting.plot_SIR import main as SIR_main
from .plotting.plot_SEIR import main as SEIR_main
from .plotting.plot_SIS import main as SIS_main
from .plotting.plot_SIR import _add_arguments as add_SIR_arguments
from .plotting.plot_SIR import _add_arguments as add_SEIR_arguments
from .plotting.plot_SIR import _add_arguments as add_SIS_arguments

# Create ArgumentParser, which can read inputs from the command line
parser = ArgumentParser(
    prog="epi_models",
    description="Tool for solving epidemiology models",
)

# Set up subparsers
subparsers = parser.add_subparsers(required=True)

# Add subcommand for each model
SIR_parser = subparsers.add_parser("SIR")
SEIR_parser = subparsers.add_parser("SEIR")
SIS_parser = subparsers.add_parser("SIS")

# Setup each parser
add_SIR_arguments(SIR_parser)
add_SEIR_arguments(SEIR_parser)
add_SIS_arguments(SIS_parser)

# Ensure each parser knows which function to
# call. set_defaults can be used to set a new
# arg which isn't set on the command line.
SIR_parser.set_defaults(main=SIR_main)
SEIR_parser.set_defaults(main=SEIR_main)
SIS_parser.set_defaults(main=SIS_main)

# Extract command line arguments and run
args = parser.parse_args()
args.main(args)
