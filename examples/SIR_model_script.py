import matplotlib.pyplot as plt

pop_size = 8000000 # Total number of susceptible people at the start of an outbreak
beta = 0.5 # Average no. of people an infectious person spreads the disease to per day
gamma = 0.1 # Inverse of the average number of days taken to recover
days = 150 # Number of days to run the simulation for
I_0 = 10 # Number of infected people at the start of the simulation

S = [] # Number of susceptible people each day
I = [] # Number of infected people each day
R = [] # Number of recovered people each day

# Set initial data
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

# Plot results
plt.plot(range(len(S)), S, label="S")
plt.plot(range(len(I)), I, label="I")
plt.plot(range(len(R)), R, label="R")
plt.xlabel("Time /days")
plt.ylabel("Population")
plt.legend()
plt.show()
