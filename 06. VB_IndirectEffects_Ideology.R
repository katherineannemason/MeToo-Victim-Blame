#Victim Blame Primary Analyses
#This code estimates the 95% confidence intervals for the multilevel moderated mediation models estimated in Final Blame and Threat Analyses.sas
#Written by the fifth, second, and first author in 2024/2025
#Last edited by first author 2025.09.18

#Preacher, K. J., & Selig, J. P. (2012). Advantages of Monte Carlo confidence intervals for indirect effects. Communication Methods and Measures, 6, 77-98.
#Selig, J. P., & Preacher, K. J. (2008, June). Monte Carlo method for assessing mediation: An interactive tool for creating confidence intervals for indirect effects [Computer software]. Available from http://quantpsy.org/.

#Enter the m*variable value for "a" and the y*fear_c value for "b"
#Enter the variance values in the 1st and 4th values of acov for those same "a" and "b" coefficients
#Do not change other settings

################################################
#Values from Model 8
################################################

################################################
#SESSION 1 VS 2 - VICTIMS
################################################

require(MASS)
a=-0.06996
b=0.04612
rep=20000
conf=95
pest=c(a,b)
acov <- matrix(c(
  0.08392, 0,
  0, 0.000037
),2,2)
mcmc <- mvrnorm(rep,pest,acov,empirical=FALSE)
ab <- mcmc[,1]*mcmc[,2]
low=(1-conf/100)/2
upp=((1-conf/100)/2)+(conf/100)
LL=quantile(ab,low)
UL=quantile(ab,upp)
LL4=format(LL,digits=4)
UL4=format(UL,digits=4)
mab=mean(ab)
hist(ab,breaks='FD',col='skyblue',xlab=paste(conf,'% Confidence Interval ','LL',LL4,'  UL',UL4),
     main='Distribution of Indirect Effect')
abline(v=mab,col="blue",lwd=2)
text(mab, 18 , round(mab, 4))
print(LL)
print(UL)

################################################
#SESSION 1 VS 3 - VICTIMS
################################################

a=0.9883
b=0.04612
rep=20000
conf=95
pest=c(a,b)
acov <- matrix(c(
  0.07936, 0,
  0, 0.000037
),2,2)
mcmc <- mvrnorm(rep,pest,acov,empirical=FALSE)
ab <- mcmc[,1]*mcmc[,2]
low=(1-conf/100)/2
upp=((1-conf/100)/2)+(conf/100)
LL=quantile(ab,low)
UL=quantile(ab,upp)
LL4=format(LL,digits=4)
UL4=format(UL,digits=4)
mab=mean(ab)
hist(ab,breaks='FD',col='skyblue',xlab=paste(conf,'% Confidence Interval ','LL',LL4,'  UL',UL4),
     main='Distribution of Indirect Effect')
abline(v=mab,col="blue",lwd=2)
text(mab, 18 , round(mab, 4))
print(LL)
print(UL)

################################################
#GENDER - VICTIMS
################################################

a=-0.1703
b=0.04612
rep=20000
conf=95
pest=c(a,b)
acov <- matrix(c(
  0.06469, 0,
  0, 0.000037
),2,2)
mcmc <- mvrnorm(rep,pest,acov,empirical=FALSE)
ab <- mcmc[,1]*mcmc[,2]
low=(1-conf/100)/2
upp=((1-conf/100)/2)+(conf/100)
LL=quantile(ab,low)
UL=quantile(ab,upp)
LL4=format(LL,digits=4)
UL4=format(UL,digits=4)
mab=mean(ab)
hist(ab,breaks='FD',col='skyblue',xlab=paste(conf,'% Confidence Interval ','LL',LL4,'  UL',UL4),
     main='Distribution of Indirect Effect')
abline(v=mab,col="blue",lwd=2)
text(mab, 18 , round(mab, 4))
print(LL)
print(UL)

################################################
#LIBERAL VS MODERATE - VICTIMS
################################################

a=0.1015
b=0.04612
rep=20000
conf=95
pest=c(a,b)
acov <- matrix(c(
  0.06926, 0,
  0, 0.000037
),2,2)
mcmc <- mvrnorm(rep,pest,acov,empirical=FALSE)
ab <- mcmc[,1]*mcmc[,2]
low=(1-conf/100)/2
upp=((1-conf/100)/2)+(conf/100)
LL=quantile(ab,low)
UL=quantile(ab,upp)
LL4=format(LL,digits=4)
UL4=format(UL,digits=4)
mab=mean(ab)
hist(ab,breaks='FD',col='skyblue',xlab=paste(conf,'% Confidence Interval ','LL',LL4,'  UL',UL4),
     main='Distribution of Indirect Effect')
abline(v=mab,col="blue",lwd=2)
text(mab, 18 , round(mab, 4))
print(LL)
print(UL)

################################################
#LIBERAL VS CONSERVATIVE - VICTIMS
################################################

a=0.8991
b=0.04612
rep=20000
conf=95
pest=c(a,b)
acov <- matrix(c(
  0.1502, 0,
  0, 0.000037
),2,2)
mcmc <- mvrnorm(rep,pest,acov,empirical=FALSE)
ab <- mcmc[,1]*mcmc[,2]
low=(1-conf/100)/2
upp=((1-conf/100)/2)+(conf/100)
LL=quantile(ab,low)
UL=quantile(ab,upp)
LL4=format(LL,digits=4)
UL4=format(UL,digits=4)
mab=mean(ab)
hist(ab,breaks='FD',col='skyblue',xlab=paste(conf,'% Confidence Interval ','LL',LL4,'  UL',UL4),
     main='Distribution of Indirect Effect')
abline(v=mab,col="blue",lwd=2)
text(mab, 18 , round(mab, 4))
print(LL)
print(UL)

################################################
#Values from Model 8b
################################################

################################################
#SESSION 1 VS 2 - PERPETRATORS
################################################

a=-0.06996
b=-0.0394
rep=20000
conf=95
pest=c(a,b)
acov <- matrix(c(
  0.08392, 0,
  0, 0.000029
),2,2)
mcmc <- mvrnorm(rep,pest,acov,empirical=FALSE)
ab <- mcmc[,1]*mcmc[,2]
low=(1-conf/100)/2
upp=((1-conf/100)/2)+(conf/100)
LL=quantile(ab,low)
UL=quantile(ab,upp)
LL4=format(LL,digits=4)
UL4=format(UL,digits=4)
mab=mean(ab)
hist(ab,breaks='FD',col='skyblue',xlab=paste(conf,'% Confidence Interval ','LL',LL4,'  UL',UL4),
     main='Distribution of Indirect Effect')
abline(v=mab,col="blue",lwd=2)
text(mab, 18 , round(mab, 4))
print(LL)
print(UL)

################################################
#SESSION 1 VS 3 - PERPETRATORS
################################################

a=0.9883
b=-0.0394
rep=20000
conf=95
pest=c(a,b)
acov <- matrix(c(
  0.07936, 0,
  0, 0.000029
),2,2)
mcmc <- mvrnorm(rep,pest,acov,empirical=FALSE)
ab <- mcmc[,1]*mcmc[,2]
low=(1-conf/100)/2
upp=((1-conf/100)/2)+(conf/100)
LL=quantile(ab,low)
UL=quantile(ab,upp)
LL4=format(LL,digits=4)
UL4=format(UL,digits=4)
mab=mean(ab)
hist(ab,breaks='FD',col='skyblue',xlab=paste(conf,'% Confidence Interval ','LL',LL4,'  UL',UL4),
     main='Distribution of Indirect Effect')
abline(v=mab,col="blue",lwd=2)
text(mab, 18 , round(mab, 4))
print(LL)
print(UL)

################################################
#GENDER - PERPETRATORS
################################################

a=-0.1703
b=-0.0394
rep=20000
conf=95
pest=c(a,b)
acov <- matrix(c(
  0.06433, 0,
  0, 0.000029
),2,2)
mcmc <- mvrnorm(rep,pest,acov,empirical=FALSE)
ab <- mcmc[,1]*mcmc[,2]
low=(1-conf/100)/2
upp=((1-conf/100)/2)+(conf/100)
LL=quantile(ab,low)
UL=quantile(ab,upp)
LL4=format(LL,digits=4)
UL4=format(UL,digits=4)
mab=mean(ab)
hist(ab,breaks='FD',col='skyblue',xlab=paste(conf,'% Confidence Interval ','LL',LL4,'  UL',UL4),
     main='Distribution of Indirect Effect')
abline(v=mab,col="blue",lwd=2)
text(mab, 18 , round(mab, 4))
print(LL)
print(UL)

################################################
#LIBERAL VS MODERATE - PERPETRATORS
################################################

a=0.1015
b=-0.0394
rep=20000
conf=95
pest=c(a,b)
acov <- matrix(c(
  0.06926, 0,
  0, 0.000029
),2,2)
mcmc <- mvrnorm(rep,pest,acov,empirical=FALSE)
ab <- mcmc[,1]*mcmc[,2]
low=(1-conf/100)/2
upp=((1-conf/100)/2)+(conf/100)
LL=quantile(ab,low)
UL=quantile(ab,upp)
LL4=format(LL,digits=4)
UL4=format(UL,digits=4)
mab=mean(ab)
hist(ab,breaks='FD',col='skyblue',xlab=paste(conf,'% Confidence Interval ','LL',LL4,'  UL',UL4),
     main='Distribution of Indirect Effect')
abline(v=mab,col="blue",lwd=2)
text(mab, 18 , round(mab, 4))
print(LL)
print(UL)

################################################
#LIBERAL VS CONSERVATIVE - PERPETRATORS
################################################

a=0.8991
b=-0.0394
rep=20000
conf=95
pest=c(a,b)
acov <- matrix(c(
  0.1502, 0,
  0, 0.000029
),2,2)
mcmc <- mvrnorm(rep,pest,acov,empirical=FALSE)
ab <- mcmc[,1]*mcmc[,2]
low=(1-conf/100)/2
upp=((1-conf/100)/2)+(conf/100)
LL=quantile(ab,low)
UL=quantile(ab,upp)
LL4=format(LL,digits=4)
UL4=format(UL,digits=4)
mab=mean(ab)
hist(ab,breaks='FD',col='skyblue',xlab=paste(conf,'% Confidence Interval ','LL',LL4,'  UL',UL4),
     main='Distribution of Indirect Effect')
abline(v=mab,col="blue",lwd=2)
text(mab, 18 , round(mab, 4))
print(LL)
print(UL)

################################################
#Values from Model 8c
################################################

################################################
#SESSION 2 VS 3 - VICTIMS
################################################

a=1.0583
b=0.04612
rep=20000
conf=95
pest=c(a,b)
acov <- matrix(c(
  0.09375, 0,
  0, 0.000037
),2,2)
mcmc <- mvrnorm(rep,pest,acov,empirical=FALSE)
ab <- mcmc[,1]*mcmc[,2]
low=(1-conf/100)/2
upp=((1-conf/100)/2)+(conf/100)
LL=quantile(ab,low)
UL=quantile(ab,upp)
LL4=format(LL,digits=4)
UL4=format(UL,digits=4)
mab=mean(ab)
hist(ab,breaks='FD',col='skyblue',xlab=paste(conf,'% Confidence Interval ','LL',LL4,'  UL',UL4),
     main='Distribution of Indirect Effect')
abline(v=mab,col="blue",lwd=2)
text(mab, 18 , round(mab, 4))
print(LL)
print(UL)

################################################
#MODERATE VS CONSERVATIVE - VICTIMS
################################################

a=0.7976
b=0.04612
rep=20000
conf=95
pest=c(a,b)
acov <- matrix(c(
  0.1582, 0,
  0, 0.000037
),2,2)
mcmc <- mvrnorm(rep,pest,acov,empirical=FALSE)
ab <- mcmc[,1]*mcmc[,2]
low=(1-conf/100)/2
upp=((1-conf/100)/2)+(conf/100)
LL=quantile(ab,low)
UL=quantile(ab,upp)
LL4=format(LL,digits=4)
UL4=format(UL,digits=4)
mab=mean(ab)
hist(ab,breaks='FD',col='skyblue',xlab=paste(conf,'% Confidence Interval ','LL',LL4,'  UL',UL4),
     main='Distribution of Indirect Effect')
abline(v=mab,col="blue",lwd=2)
text(mab, 18 , round(mab, 4))
print(LL)
print(UL)

################################################
#Values from Model 8d
################################################

################################################
#SESSION 2 VS 3 - PERPETRATORS
################################################

a=1.0583
b=-0.0394
rep=20000
conf=95
pest=c(a,b)
acov <- matrix(c(
  0.09375, 0,
  0, 0.000029
),2,2)
mcmc <- mvrnorm(rep,pest,acov,empirical=FALSE)
ab <- mcmc[,1]*mcmc[,2]
low=(1-conf/100)/2
upp=((1-conf/100)/2)+(conf/100)
LL=quantile(ab,low)
UL=quantile(ab,upp)
LL4=format(LL,digits=4)
UL4=format(UL,digits=4)
mab=mean(ab)
hist(ab,breaks='FD',col='skyblue',xlab=paste(conf,'% Confidence Interval ','LL',LL4,'  UL',UL4),
     main='Distribution of Indirect Effect')
abline(v=mab,col="blue",lwd=2)
text(mab, 18 , round(mab, 4))
print(LL)
print(UL)

################################################
#MODERATE VS CONSERVATIVE - PERPETRATORS
################################################

a=0.7976
b=-0.0394
rep=20000
conf=95
pest=c(a,b)
acov <- matrix(c(
  0.1582, 0,
  0, 0.000029
),2,2)
mcmc <- mvrnorm(rep,pest,acov,empirical=FALSE)
ab <- mcmc[,1]*mcmc[,2]
low=(1-conf/100)/2
upp=((1-conf/100)/2)+(conf/100)
LL=quantile(ab,low)
UL=quantile(ab,upp)
LL4=format(LL,digits=4)
UL4=format(UL,digits=4)
mab=mean(ab)
hist(ab,breaks='FD',col='skyblue',xlab=paste(conf,'% Confidence Interval ','LL',LL4,'  UL',UL4),
     main='Distribution of Indirect Effect')
abline(v=mab,col="blue",lwd=2)
text(mab, 18 , round(mab, 4))
print(LL)
print(UL)