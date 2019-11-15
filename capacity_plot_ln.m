function output=capacity_plot_ln(SNR,output)

SNR=10^(0.1*SNR);
Mr =16;
Mt= 4;

m = 1;
v = 8;
mu = log((m^2)/sqrt(v+m^2));
sigma = sqrt(log(v/(m^2)+1));

%10000 Monte-Carlo runs
for K=1:10000
   T=randn(Mr,Mt)+j*randn(Mr,Mt);
   T=0.707*T;
  
   D_shad = lognrnd(mu,sigma,1, Mt);
   D_b = diag(D_shad);
   D_b = sqrt(D_b);
   T = T* D_b;
   
   I=eye(Mr);
   a=(I+(SNR/Mt)*T*T');
   a=det(a);
   y(K)=log2(a);    
end
[n1 x1]=hist(y,40);
n1_N=n1/max(K);
a=cumsum(n1_N);
b=abs(x1);
if output == 'erg'
    output=interp1q(a,b',0.5);   %ergodic capacity
elseif output == 'out'
    output=interp1q(a,b',0.1);   %outage capacity 
end 
