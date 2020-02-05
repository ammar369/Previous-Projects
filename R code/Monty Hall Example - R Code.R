# =========================================
# This script is designed to simulate the 
# Monty Hall problem. 
# =========================================

# Clear memory (run this line of code whenever you want to remove all your data, values and functions)
rm(list=ls())

# ---------
# Problem:
# ---------

# There are 3 closed doors. One door contains a car, the other two contain a goat.

# A participant is asked to select a door. One of the non-selected doors is
# revealed to contain a goat. The participant is asked whether he wants to 
# switch door or not. 

# It will be seen in class via conditional probability that it is at the 
# at the advantage of the participant to switch doors. 

# This script demonstrates this fact via simulation of many games played.

# -------------------------
# Monty Hall Game Function
# -------------------------

# door: Door selected (must be either 1, 2 or 3).
# Switch: Boolean variable (TRUE or FALSE) to determine if the participant switches door.

monty.hall <- function(door=1, switch=FALSE){
  
  # Stop if invalid door number
  if(!(door %in% c(1,2,3)))
    stop("The door selected must be either of the numbers 1, 2 or 3.")
  
  # Stop if invalid switch decision
  if(!(switch %in% c(TRUE, FALSE)))
    stop("The switch variable must be either TRUE or FALSE.")
  
  # Setting the car door
  car.door <- sample(c(1,2,3), 1)
  
  # Door revealed with goat
  if(door != car.door)
    car.goat.revealed <- c(1,2,3)[-c(door, car.door)] else
      car.goat.revealed <- sample(c(1,2,3)[-door], 1)
  
  # Switch door?
  if(switch)
    door <- c(1,2,3)[-c(car.goat.revealed, door)]
  
  # Did we win?
  if(door==car.door)
    return("Car!") else
      return("Goat!")
}

# -------------------------
# Monty Hall Simulation
# -------------------------

# n.games: number of games to be played.
# door: Door selected (must be either 1, 2 or 3).
# Switch: Boolean variable (TRUE or FALSE) to determine if the participant switches door.

monty.hall.simulation <- function(n.games=1000, door=1, switch=FALSE){
  
  # Variable to store game results
  monty.games <- numeric(n.games)
  
  # Monty Hall trials (different door per trial possible)
  if(length(door)>1)
    for(game in 1:n.games)
      monty.games[game] <- monty.hall(door[game], switch) else if(length(door)==1)
        for(game in 1:n.games)
          monty.games[game] <- monty.hall(door, switch)
        
        # Proportion of games won
        prop.won <- sum(monty.games=="Car!")/n.games
        
        # Printing the proportion of games won
        cat("You have won ", round(prop.won*100, 2), "% of games.")
}

# Playing the game without switching
monty.hall.simulation(switch=FALSE)

# Playing the game with switching
monty.hall.simulation(switch=TRUE)

# Note that it does not matter if we select a door at random each time
my.doors <- sample(c(1,2,3), 1, size=1000)
monty.hall.simulation(n.games=1000, door=my.doors, switch=FALSE)
monty.hall.simulation(n.games=1000, door=my.doors, switch=TRUE)

# EXERCISE 1 (optional):
# Can you write an R function with the following modification to the Monty Hall problem: the participant has a probibility 
# of switching, and then based on this probability, it is determined whether the participant switches door or not.
# What are the probabilities of winning for P(Switch) = 0.1, 0.2, ..., 0.9?

# EXERCISE 2 (optional):
# Can you write an R function to interactively allow the user to play the Monty Hall Problem?















