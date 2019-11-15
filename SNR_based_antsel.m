function output=SNR_based_antsel(SNR,output)

SNR=10^(0.1*SNR);
Mr =10;
Mr_sel =5;
Mt=5;

%10000 Monte-Carlo runs
for K=1:10000
   T=randn(Mr,Mt)+j*randn(Mr,Mt);
   T=0.707*T;
   
   SNRs= [sum(T(1,:).^2), sum(T(2,:).^2), sum(T(3,:).^2), sum(T(4,:).^2), sum(T(5,:).^2), sum(T(6,:).^2),  sum(T(7, :).^2),  sum(T(8, :).^2),  sum(T(9, :).^2), sum(T(10, :).^2)];
   
   %SNRs= [sum(T(1,:)).^2, sum(T(2,:)).^2, sum(T(3,:)).^2, sum(T(4,:)).^2, sum(T(5,:)).^2, sum(T(6,:)).^2,  sum(T(7, :)).^2,  sum(T(8, :)).^2,  sum(T(9, :)).^2, sum(T(10, :)).^2];

   [B, I] = sort(SNRs,'descend');
   
   T1= [T(I(1),:); T(I(2),:); T(I(3),:);  T(I(4),:); T(I(5),:)];
   
   
   clear I,
     
   I=eye(Mr_sel);
     a=(I+(SNR/Mt)*T1*T1');
     %a=(I+ T1*T1');
     a=det(a);
   y(K)=log2(a);    
end

%output= sum(y)/max(K); 
[n1 x1]=hist(y,40);
n1_N=n1/max(K);
a=cumsum(n1_N);
b=abs(x1);
if output == 'erg'
    output=interp1q(a,b',0.5);   %ergodic capacity
elseif output == 'out'
    output=interp1q(a,b',0.1);   %outage capacity 
end 


