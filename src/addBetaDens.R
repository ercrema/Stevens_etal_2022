# Adds Violin-plot for Posterior estimates of Binomial using conjugate Beta prior
# x ... x coordinate  of the violin plot
# w ... width of the violin
# beta1,beta2 ... parameters of the beta distribution
# col ... fill color
# hpd ... quantile percentage range for region to be color filled


addBetaDens  <- function(x,beta1,beta2,w,col,hpd=0.9)
{
	xx  <- round(seq(0,1,length.out=1000),3)
	dens  <- dbeta(xx,beta1,beta2)
	dens999lo  <- round(qbeta(0.001,beta1,beta2),3)
	dens999hi  <- round(qbeta(0.999,beta1,beta2),3)
	denshpdlo  <- round(qbeta(1-hpd,beta1,beta2),3)
	denshpdhi  <- round(qbeta(hpd,beta1,beta2),3)

	d999i  <- which(xx>=dens999lo&xx<=dens999hi)
	dhpdi  <- which(xx>=denshpdlo&xx<=denshpdhi) 
	
	maxLeft = x-w
	maxRight= x+w
	leftVals.999 = (dens[d999i]/(max(dens[d999i]))) * (maxLeft - x) + x
	rightVals.999 = (dens[d999i]/(max(dens[d999i]))) * (maxRight - x) + x 
	leftVals.hpd = (dens[dhpdi]/(max(dens[dhpdi]))) * (maxLeft - x) + x
	rightVals.hpd = (dens[dhpdi]/(max(dens[dhpdi]))) * (maxRight - x) + x 
	polygon(c(leftVals.999,rev(rightVals.999)),c(xx[d999i],rev(xx[d999i])),col=NULL,border = 'lightgrey')
	polygon(c(leftVals.hpd,rev(rightVals.hpd)),c(xx[dhpdi],rev(xx[dhpdi])),col=col,border=col)
	lines(c(maxLeft,maxRight),rep((beta1-1)/(beta1+beta2-2),2),lwd=2,col=1)
}
