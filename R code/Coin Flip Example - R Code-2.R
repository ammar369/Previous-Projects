
# Clear memory (run this line of code whenever you want to remove all your data, values and functions)
rm(list=ls())

# --------------------
# Coin Flip Function
# --------------------

# n_flips: number of coin flips to perform (default is set to 1)
# prob_H: probability to flip H (default is set to 0.5)

coin_flip <- function(n_flips=1, prob_H=0.5){
  
  index_flip <- rbinom(n=n_flips, size=1, prob = prob_H)
  
  coin_flips <- character(n_flips)
  coin_flips[index_flip==1] <- "H"
  coin_flips[index_flip==0] <- "T"
  
  return(coin_flips)
}

# Testing the function for 20 flips of a fair coin
coin_flip(20)

# Testing the function for 20 flips of a biased coin (probability of H is 0.9)
coin_flip(20, 0.9)
# How many heads out of 100 do we get if we flip a biased coin (probability of H is 0.85) 100 times?
sum(coin_flip(1000, 0.8)=="H")
# Proportion
sum(coin_flip(1000, 0.8)=="H")/1000

# Note that if we keep running the function, we get different results.
# To reproduce a sequence of flips, we must set the seed for the random 
# number generator in R.
set.seed(1)
coin_flip(20)
set.seed(1) # Comment this line out and you will likely end up with a different sequence
coin_flip(20)

# ---------------------
# Coin Flips Sequences
# ---------------------

# n_sequences: number of coin flips to perform (default is set to 1)
# sequence_size: number of flips in a sequence (default is set to 1)
# prob_H: probability to flip H (default is set to 0.5)

coin_flips_sequences <- function(n_sequences=1, sequence_size=1, prob_H=0.5){
  
  flips_sequences <- matrix(nrow=n_sequences, ncol=sequence_size)
  
  for(seq in 1:n_sequences)
    flips_sequences[seq,] <- coin_flip(n_flips=sequence_size, prob_H=prob_H)
  
  return(flips_sequences)
}

# Generating 1000 sequences of size 5
my_sequences <- coin_flips_sequences(n_sequences=1000, sequence_size=2, prob_H=0.5)
condition_1 <- condition_2 <- c()
# Condition for first H
for(seq in 1:nrow(my_sequences))
  condition_1[seq] <- my_sequences[seq,1]=="H"
# Condition for second H
for(seq in 1:nrow(my_sequences))
  condition_2[seq] <- my_sequences[seq,2]=="H"
# Computing P({HH}|{H})
sum(condition_1*condition_2)/sum(condition_1)
# Computing P({H in for second flip})
sum(condition_2)/1000

# Generating 1000 sequences of size 5
my_sequences <- coin_flips_sequences(n_sequences=1000, sequence_size=5, prob_H=0.5)
# Only keeping the sequences satisfying the condition that we have at least 2 H
condition_3 <- c()
for(seq in 1:nrow(my_sequences))
  condition_3[seq] <- sum(my_sequences[seq,]=="H")>=2
# Computing the probability of at least 2 H
sum(condition_3)/1000
# Only keeping the sequences satisfying the condition that we have at least 4 H
condition_4 <- c()
for(seq in 1:nrow(my_sequences))
  condition_4[seq] <- sum(my_sequences[seq,]=="H")>=4
# Computing the probability of at least 4 H
sum(condition_4)/1000
# Computing probability of at least 4 H if we know we have at least 2 H
sum(condition_4)/sum(condition_3)















