 %Analysis of Optimization Equations for Subsidies as a function of Theta & Alpha%%%%%%%%%%%%%%%%%%%%

%% Input Parameters%%
Betas=.20; %slope shoreline toe position (%) Rise/Run (1V:5H USACOE 2014)
Betab=.10; %slope of back portions of dune (%) Rise/Run (1V:10H USACOE 2014)
p=(1/Betas)+(1/Betab);
beta=.5;           %hedonic model exponent for nourishment coefficient
DR=0.06875;        %annualized discount rate (Goplakrishnan = .06 - USACE-Philly 1999 feasibility report, page 11 or I)
DT=8.84;           %8.84.Depth of Closure under USACOE 2014 %average depth of closure for beach width (W) - Ortiz 2016 and Lorenzo-Trueba et al 2014 values of 10m-30m for DT
Halpha=3.66;       %minimum height (100yr SWFL @12ft highest +NDVI for Long Beach Island)
Walpha=30;         %mimimum berm width
TRUECPIn=4.17;     %cost of local nourishment $/m^3 $4.17 & $13.07
H=6.71;            %FEMA "540-Rule" threshold dune height

%% External Loop Vectors for Storage
run=100;
thetaV=linspace(0,.3,run);
itl=length(thetaV);
alphaV=linspace(0,4000,run);
ial=length(alphaV);

%% Building Result Matrix for regime plot
result_matrixC1=zeros(1,ial);
result_matrixMAX=zeros(1,ial);
result_matrixPERCENT=zeros(1,ial);
%% Result Matrix Storage for regime plot
C1=NaN(1,ial);
CPInMAX_star=NaN(1,ial);
CPInPERCENT_star=NaN(1,ial);

%% Subsidies Forloops
for it=1:itl;
    theta_star=thetaV(it);
    it=it;
    
    for ia=1:ial;
         alpha_star=alphaV(ia);
         C1(ia)=(((((H/Halpha)^(-theta_star))*Walpha*DR*DT)/beta)^(beta/(beta-1)))*((H^(theta_star-1))*(Halpha^(-theta_star)));
         C2=((DR*p*DT)+(DR*p*H));
         CPInMAX_star(ia)=((alpha_star*theta_star*C1(ia)*((C2/(theta_star*C1(ia)))^beta))/C2);
         CPInPERCENT_star(ia)=((TRUECPIn-CPInMAX_star(ia))/TRUECPIn)*100;
    
%     if CPInPERCENT_star(ia)<12.5;
%        CPInPERCENT_star(ia)=NaN;
%     end
%     if CPInPERCENT_star(ia)>50;
%        CPInPERCENT_star(ia)=NaN;
%     end
    end
    result_matrixC1=[result_matrixC1;C1];
    C1=NaN(1,ial);
    result_matrixMAX=[result_matrixMAX;CPInMAX_star];
    CPInMAX_star=NaN(1,ial);
    result_matrixPERCENT=[result_matrixPERCENT;CPInPERCENT_star];
    CPInPERCENT_star=NaN(1,ial);
end
result_matrixC1(1,:)=[];
result_matrixTC1=transpose(result_matrixC1);
result_matrixMAX(1,:)=[];
result_matrixTMAX=transpose(result_matrixMAX);
result_matrixPERCENT(1,:)=[];
result_matrixTPERCENT=transpose(result_matrixPERCENT);

%% Plots
figure (1)
pcolor(alphaV,thetaV,result_matrixPERCENT)
hold on
%     if CPInPERCENT_star(ia)<12.5;
%        CPInPERCENT_star(ia)=NaN;
%     end
shading flat
caxis([0 100])
colormap(flipud(white))
% colormap('pink');
Z=result_matrixPERCENT;
[X,Y]=meshgrid(alphaV,thetaV);
set(gca,'PlotBoxAspectRatio',[1,1,1])
set(gcf,'rend','painters')
[c,h]=contour(X,Y,Z,[0,12.5,50],'LineStyle','--','levelstep',5,'linecolor','k'); %%-- 0-50% cost shares (12.5% for the local minimum)
clabel(c,h)
%contour3(X,Y,result_matrixPERCENT,[0 0],'linewidth',1.5,'linecolor','k');
contour3(X,Y,result_matrixPERCENT,[12.5 12.5],'LineStyle','--','levelstep',5,'linecolor','b') %highlights the local minimum 12.5%
%contour3(X,Y,result_matrixPERCENT,[50 50],'LineStyle','--','linewidth',1.5,'linecolor','b');
%contour3(X,Y,result_matrixPERCENT,[0 0],'LineStyle','--','linewidth',1.5,'linecolor','k');
view(0,90)
axis tight
hold off
ylim([0 .3])    %zoom for CPIn=4.17
xlim([0 4000])  %zoom for CPIn=4.17
xlabel('Annualized Baseline Rental Values($1K/yr/m)','fontsize',12)
ylabel('Hedonic Value for Height (theta)','fontsize',12)
title('%Subsidies Required for Dune Construction','fontsize',15)
hold on;