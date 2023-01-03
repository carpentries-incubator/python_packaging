from argparse import ArgumentParser
import yaml
from .models import SIR_model, SEIR_model, SIS_model
from .plotting import plot_SIR_model, plot_SEIR_model, plot_SIS_model

# Create ArgumentParser, which can read inputs from the command line
parser = ArgumentParser(
    prog="epi_models",
    description="Tool for solving epidemiology models",
)

# Add arguments that the user must supply
parser.add_argument("model")
parser.add_argument("input_file")

# Read command line args
args = parser.parse_args()

# Get data from input file
with open(args.input_file, "r") as f:
    data = yaml.load(f, yaml.Loader)

# Run models and plot
# Note: In real code, you should validate the input data and
# raise helpful errors if something goes wrong!
if args.model == "SIR":
    S, I, R = SIR_model(**data)
    plot_SIR_model(S, I, R)
elif args.model == "SEIR":
    S, E, I, R = SEIR_model(**data)
    plot_SEIR_model(S, E, I, R)
elif args.model == "SIS":
    S, E, I, R = SIS_model(**data)
    plot_SIS_model(S, E, I, R)
else:
    raise ValueError(f"The model '{args.model}' is not recognised.")
