from ..models.SIR import SIR_model
import matplotlib.pyplot as plt
from argparse import ArgumentParser

def plot_SIR_model(S, I, R, ax=None, save_to=None, show=False):
    """
    Plot the results of a SIR simulation.

    Parameters
    ----------
    S: List[float]
        Number of susceptible people on each day.
    I: List[float]
        Number of infected people on each day.
    R: List[float]
        Number of recovered people on each day.
    ax: Optional[plt.Axes], default None
        Axes object on which to create the plot.
        A new Axes is created if this is None.
    save_to: Optional[str], default None
        Name of the file to save the plot to.
        Does not save if None.
    show: bool, default False
        If True, call plt.show() on completion.

    Returns
    -------
    plt.Axes
        The axes object the results have been plotted to.
    """
    # Use plt.subplots to create Figure and Axes objects
    # if one is not provided.
    if ax is None:
        fig, ax = plt.subplots()

    # Create plot
    ax.plot(range(len(S)), S, label="S")
    ax.plot(range(len(I)), I, label="I")
    ax.plot(range(len(R)), R, label="R")
    ax.set_xlabel("Time /days")
    ax.set_ylabel("Population")
    ax.legend()

    # Optionally save the figure
    if save_to is not None:
        fig = ax.get_figure()
        fig.savefig(save_to)

    # Optionally show the figure
    if show:
        plt.show()

    return ax


def _add_arguments(parser):
    parser.add_argument(
        "-p", "--pop_size", type=int, default=10000000,
        help="Total population size",
    )
    parser.add_argument(
        "-b", "--beta", type=float, default=0.5,
        help="Average no. of new infections per infected person per day",
    )
    parser.add_argument(
        "-g", "--gamma", type=float, default=0.1,
        help="Inverse of average number of days taken to recover",
    )
    parser.add_argument(
        "-d", "--days", type=int, default=150,
        help="Number of days to run the simulation",
    )
    parser.add_argument(
        "-i", "--i0", type=int, default=10,
        help="Number of infected people at the start of the simulation",
    )
    parser.add_argument(
        "-o", "--output", default="SIR_model.png",
        help="Output file to save plot to",
    )

def main(args):
    # Run our code, using an ArgumentParser object
    S, I, R = SIR_model(
        pop_size=args.pop_size,
        beta=args.beta,
        gamma=args.gamma,
        days=args.days,
        I_0=args.i0,
    )
    plot_SIR_model(S, I, R, save_to=args.output)

if __name__ == "__main__":
    # Create an argument parser object. We can provide
    # some info about our program here.
    parser = ArgumentParser(
        prog="SIR_model",
        description="Solves SIR model and creates a plot",
    )

    # Add arguments
    _add_arguments(parser)

    # Get each argument from the command line
    args = parser.parse_args()

    # Run
    main(args)
