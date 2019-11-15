function output=convex_based_antsel(SNR,output)

SNR=10^(0.1*SNR);
Mr =16; 
L =4; 
Mt=4;


m = 1;
v = 8;
mu = log((m^2)/sqrt(v+m^2));
sigma = sqrt(log(v/(m^2)+1));

%10000 Monte-Carlo runs
for K=1:100
  T=randn(Mr,Mt)+j*randn(Mr,Mt);
  %T= eye(Mr,Mt);
  T=0.707*T;
  
  D_shad = lognrnd(mu,sigma,1, Mt);
  D_b = diag(D_shad);
  D_b = sqrt(D_b);
  T = T* D_b;
  
    cvx_begin
    variable x(Mr)
  
%    maximize( log_det(eye(Mt) + SNR *T'*diag(x)*T  )/(log(2)) )
     maximize(min( log_det(eye(Mt) + SNR *T'*diag(x)*T  )/(log(2))) )

    % maximize( log_det(eye(Mt) + SNR*T'*diag(x)*T  )/(log(2)) ) %no shadow
    % maximize( log_det( SNR*T'*diag(x)*T  )/(log(2)) )

    
    %  log2(x) = ln(x)/ln(2). 
    subject to
        0 <= x <= 1;
        trace(diag(x)) == L;
    cvx_end
   
      
   [B, I] = sort(x,'descend');
   ant_sel= I(1:L)';
   
   T1 = T(ant_sel,:);   
   
      
   clear I,
     
   I=eye(L);
   a=(I+(SNR/Mt)*T1*T1');
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

