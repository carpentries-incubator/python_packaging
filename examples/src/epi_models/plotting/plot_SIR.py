import matplotlib.pyplot as plt
from ..models.SIR import SIR_model

def plot_SIR_model(S, I, R):
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

    Returns
    -------
    None
    """
    plt.plot(range(len(S)), S, label="S")
    plt.plot(range(len(I)), I, label="I")
    plt.plot(range(len(R)), R, label="R")
    plt.xlabel("Time /days")
    plt.ylabel("Population")
    plt.legend()
    plt.show()


if __name__ == "__main__":
    S, I, R = SIR_model(
        pop_size=8000000, beta=0.5, gamma=0.1, days=150, I_0=10
    )
    plot_SIR_model(S, I, R)
