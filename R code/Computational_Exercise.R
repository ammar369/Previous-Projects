#this is for part b, see notes for part a (we can change values of alpha accordingly)

groups_expected_val <- function(N, m, alpha){
  
  expected_value <- N/m*((1-alpha)^m + (1-(1-alpha)^m)*(m+1))
  return(expected_value)
}


my_expected_vals <- groups_expected_val(10000, 1:50, 0.001)

groups_expected_val(10000, 1:50, 0.001)
cbind(1:50,groups_expected_val(10000, 1:50, 0.001))
my_expected_vals[which.min(my_expected_vals)]



#this is for part c

groups_expected_val_s <- function(N, m, alpha){
  
  expected_value_s <- N/m*((0.01*(alpha)^m + (0.95*(1-alpha)^m)) + ((m+1)*(1-(0.01*(alpha)^m + (0.95*(1-alpha)^m))))) #incorrect
  return(expected_value_s)
}


my_expected_vals_s <- groups_expected_val_s(10000, 1:50, 0.001)
my_expected_vals_s
#groups_expected_val_s(10000, 1:50, 0.001)
cbind(1:50,groups_expected_val_s(10000, 1:50, 0.001))
my_expected_vals_s[which.min(my_expected_vals_s)]

qnorm(0.95)
