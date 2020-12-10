%input parameters 1
Betas=.20; %slope shoreline toe position (%) Rise/Run (1V:5H USACOE 2014)
Betab=.10; %slope of back portions of dune (%) Rise/Run (1V:10H USACOE 2014)
p=1/Betas+1/Betab;
%% utilize the hold on; function at the end to run all 5 beta values on the plot %%
beta=.3;           %hedonic model exponent for HEIGHT (backwards from manuscript) nourishment coefficient
% beta=.1;
% beta=.05;
% beta=.005;
% beta=.001;
%% ------ %%
%input parameters 2
theta=.5;          %hedonic model exponent for WIDTH (backwards from manuscript) coefficient (Gopalakrishnan et al 2011 pp.307-308 Theta=.5)
DR=0.06875;       %annualized discount rate (Goplakrishnan = .06 - USACE-Philly 1999 feasibility report, page 11 or I)
DT=8.84;            %8.84..Depth of Closure under USACOE 2014 %average depth of closure for beach width (W) - Ortiz 2016 and Lorenzo-Trueba et al 2014 values of 10m-30m for DT
Halpha=3.66;        %minimum height (100yr SWFL)
Walpha=30;           %mimimum berm width
CPIn=4.17;

%EXTERNAL LOOP INPUTS VECTORS
alpha=70:100:4000;
n=length(alpha);
Hstar=zeros(1,n);

%intial guess
H0=.01;

%fsolve 
for i=1:n;
  Hstar(i)=fsolve(@funH,H0,[],p,CPIn,alpha(i),beta,theta,DR,DT,Halpha,Walpha);
  if Hstar(i)>7; Hstar(i)=7; end
end

%plots
figure (1)
hold on
plot(alpha,Hstar,'linewidth',2,'LineStyle','--')
xlim([0 4000])
ylim([0 7])
hold on;