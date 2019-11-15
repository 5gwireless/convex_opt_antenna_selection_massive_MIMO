function z=capacity_plot_main(output)

% use capacity_plot_main('out') to run get outage capacity
% use capacity_plot_main('erg') to run ergodic capacity

% Dependencies
% Intstall CVX from cvxr.com/cvx/download/

% use cvx_setup to run the Convex optimization based AS

%varies SNR through 20 dB
SNR=0:1:20;%SNR is signal-to-noise ratio in dBs
temp2=[];
for i=1:length(SNR)
    
       %          temp1(i)=capacity_plot_ln(SNR(i),output);
       %          temp1(i)=capacity_plot(SNR(i),output);  % Capacity plots 
                  temp1(i)=convex_based_antsel(SNR(i),output); % with AS
       %         temp1(i)=convex_based_antsel_ADC(SNR(i),output); % with AS

       %         temp1(i)=SNR_based_antsel(SNR(i),output);  % with SNR
                                                         
       %         convex_based_antsel_norm_based(SNR(i),output); % with AS
    temp2=[temp2 temp1(i)];
    temp1(i)=0;
end
%save temp2.mat
plot(SNR,temp2,'o-');
grid;
%hold
%plot routines follow. These will change depending upon the type of plot.
%The following routines are based on the given example above
xlabel('SNR');
ylabel('Capacity (Bits/sec)');

