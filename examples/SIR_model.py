import matplotlib.pyplot as plt

def SIR_model(pop_size, beta, gamma, days, I_0):
    """
    Solves a SIR model numerically using a simple integration scheme.

    Parameters
    ----------
    pop_size: int
        Total number of susceptible people at the start of an outbreak.
    beta: float
        Average number of new infections per infected person per day.
    gamma: float
        Inverse of the average number of days taken to recover.
    days: int
        Number of days to run the simulation for.     
    I_0: int
        Number of infected people at the start of the simulation.

    Returns
    -------
    S: List[float]
        Number of susceptible people on each day.
    I: List[float]
        Number of infected people on each day.
    R: List[float]
        Number of recovered people on each day.
    """
    # Initialise data
    S = [] # Number of susceptible people each day
    I = [] # Number of infected people each day
    R = [] # Number of recovered people each day
    S.append(pop_size - I_0)
    I.append(I_0)
    R.append(0)

    # Solve model
    for i in range(days):
        # Get rate of change of S, I, and R
        dS = - beta * S[i] * I[i] / pop_size
        dR = gamma * I[i]
        dI = -(dS + dR)
        # Get values on next day
        S.append(S[i] + dS)
        I.append(I[i] + dI)
        R.append(R[i] + dR)

    return S, I, R


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
