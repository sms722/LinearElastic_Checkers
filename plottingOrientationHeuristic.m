xa = linspace(10,1,1000);
xb = linspace(1,4,400);
ya = 90./(1+exp(-(1/5).*((1./xa)-1)));
yb = 90./(1+exp(-5.*(xb-1)));
plot((1./xa),ya,'b-',xb,yb,'r-');