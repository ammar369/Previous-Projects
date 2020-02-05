n = 10000  #the simulation is run 10000 times
x = sample(1:8, n*20, rep=T) #first parameter is 1 to 8 numbers which can come in the 8 face die, second is that we roll 20 times, rep means replication, which is true in this case as we can get one number multiple times
X = matrix(x,n,20) #this makes a matrix, first argument is data it takes/maps, second is nrows and third is ncols
Y1 = (X>=4)*1 #this makes matrix like X where 0 if less than 4 and 1 if more than or equal to 4
Y2 = (X>=6)*1 #this makes matrix like X where 0 if less than 6 and 1 if greater than or equal to 6
r1 = apply(Y1,1,sum) #first parameter is a matrix, second is margin for performing manipulation (1 for rows, 2 for columns) and last is the function to execute
r2 = apply(Y2,1,sum) #here we are summing up rows of our matrix
r3 = ifelse(r1>=8,1,0) #here we test for each element of r1, if condition true, then we get 1, else we get 0
r4 = ifelse(r1>=8 & r2>=12,1,0)
sum(r4)/sum(r3)
