function output=convex_based_antsel_norm_based(SNR,output)

SNR=10^(0.1*SNR);
Mr =10;
Nr =5;
Mt=10;
Nt =5;
%10000 Monte-Carlo runs
for K=1:100
   F=randn(Mr,Mt)+j*randn(Mr,Mt);
   F=0.707*F;

    cvx_begin
    variable t(Mt)
    variable r(Mr)

%for ii=1:Mt
%    for jj=1:Mr

%    maximize( SNR * norm(F(ii,jj), 2 ) * diag(r)* diag(t))
        maximize( log_det(eye(Mt) + SNR*F'*diag(t)* diag(r)* F  )/(log(2)) )

    
    subject to
        0 <= t <= 1;
        0 <= r <= 1;
        trace(diag(t)) == Nt;
        trace(diag(r)) == Nr;
     cvx_end
   
      
   [B, I] = sort(t,'descend');
   ant_sel_T = I(1:5)';
   T1 = F(ant_sel_T,:);   

   [B, I] = sort(r,'descend');
   ant_sel_R= I(1:5)';
   T1 = T1(:, ant_sel_R);   

     
       
    clear I,
     
   I=eye(min(Nr,Nt));
   a=(I+(SNR/Mt)*T1*T1');
   a=det(a);
   y(K)=log2(a);    
    end
% end
% end
[n1 x1]=hist(y,40);
n1_N=n1/max(K);
a=cumsum(n1_N);
b=abs(x1);
if output == 'erg'
    output=interp1q(a,b',0.5);   %ergodic capacity
elseif output == 'out'
    output=interp1q(a,b',0.1);   %outage capacity 
end 

