x = 1
y = 2
z = x + y
w <- c(1,2,3)
z
x
w[2]
x <- 10:20
x[3]
y <- seq(10,20, by=2)
y <- seq(from=10, to=20, by=2)
w <- seq(0,1, length.out = 101)
length(y)
w

#vector operations
y1 <- c(2,4)
y2 <- c(3,6)
y2 <- 1 #this means that if we add then this will be trated as a (1) vector which will be added to each element, if the vecor is (1,0)
#########instead then it will add 1 to first, then 0 to second, then 1 to third, then 0 to fourth and so on
y1+y2
y1-y2
y1*y2
y1* c(3,6)

#repititive operations, gives error if rep length is not multiple of cancatonated length
rep(1,8)* c(1,2)

#vector LA multiplication
t(c(2,2)) %*% c(1,1)
c(2,2) %*% t(c(1,1))

#matrices are stored as columns as opposed to rows
#matrices-------------------------
mat <- matrix(seq(1,9, by=1),nrow=3, ncol=3) #see that the result is input by row, so the second column of the first row will have 4
mat
mat <- matrix(seq(1,9, by=1),nrow=3, ncol=3, byrow=TRUE) #this will now save it by row so now second column first row will be 2
mat

mat[1:2,]#if nothing after comma then it will give us both rows
mat[,c(1,3)] #this will give us the first and third column, entire column as row is not input, only comma
2*mat
mat*c(1,2,3)#this multiplies the first row by 1, the second row by 2 and the third row by three, so in concatenation each value is in a different row, same column


x1 <- 1:5
x2 <- 6:10

rbind(x1,x2) #this binds the two into two rows
cbind(x1,x2) #this binds the two into two columns



#-------------creating a list
my.list <- list (x=1, my.stringy ="Hello!", a.mat.mine=mat)
my.list


#---------------Looping

for (i in 1:20){
 print(i) 
}

test <- c(5,10,15)
for (i in test){
  print(i)
}


i <- 1
while(i <= 20){
  print(i)
  i <- i+1
  
}

