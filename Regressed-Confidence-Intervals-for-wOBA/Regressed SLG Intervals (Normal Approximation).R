#Define functions to create Covariance matrices


cov.matrix <- function(pars) {
  
   k <- length(pars)
   m <- matrix(rep(0,k*k),k,k)

   a0 <- sum(pars)

   for(i in 1:k) {
    for(j in 1:k) {
      
      if(i == j) m[i,j] = pars[i]*(a0-pars[i])/(a0^2*(a0 + 1))
      if(i != j) m[i,j] = -pars[i]*pars[j]/(a0^2*(a0 + 1))
    }
   }

   return(m)

}

cov.pred.matrix <- function(pars,n.new) {
  
   k <- length(pars)
   m <- matrix(rep(0,k*k),k,k)

   a0 <- sum(pars)

   for(i in 1:k) {
    for(j in 1:k) {
      
      if(i == j) m[i,j] = 1/n.new*pars[i]/a0*(1-pars[i]/a0)*(n.new+a0)/(1 + a0)
      if(i != j) m[i,j] = -1/n.new*pars[i]*pars[j]/a0^2*(n.new+a0)/(1+a0)
    }
   }

   return(m)

}



#Specific example: Mike Trout in 2013

#Define array of SLG weights

w <- c(1,2,3,4,0)

#Define array of counts of events for Mike Trout 2013

x.trout <- c(115,39,9,27,399)

#Define array of Dirichlet prior parameters

alpha <- c(42.44, 12.86, 1.38, 7.07, 176.12)

#Calculate dirichlet posterior for Mike Trout 2013
#And take a weighted average of expectations

post.trout <- x.trout + alpha

#Calculate SLG for Mike Trout 2013

slg.trout <- sum(w*post.trout/sum(post.trout))

#Estimate posterior SLG distribution by Normal Approximation

v <- t(w)%*%cov.matrix(post.trout)%*%w

c(slg.trout - 1.96*sqrt(v), slg.trout + 1.96*sqrt(v))



#Estimate posterior predictive SLG distribution by normal approximation

v <- t(w)%*%cov.pred.matrix(post.trout, sum(x.trout))%*%w

c(slg.trout - 1.96*sqrt(v), slg.trout + 1.96*sqrt(v))

