%%Analysis of Optimization Equations for Height (H*) as a function of CPIn & Alpha%%%%%%%%%%%%%%%%%%%%

%%%%%%%Input Parameters%%%%%%%
Betas=.20; %slope shoreline toe position (%) Rise/Run (1V:5H USACOE 2014)
Betab=.10; %slope of back portions of dune (%) Rise/Run (1V:10H USACOE 2014)
p=1/Betas+1/Betab;
%%%THETA is BETA & BETA is THETA (mixed up from original document, see derivations)
% theta=0.3;           %hedonic model exponent for HEIGHT (backwards from manuscript) nourishment coefficient
theta=0.001
beta=.5;          %hedonic model exponent for WIDTH (backwards from manuscript) coefficient (Gopalakrishnan et al 2011 pp.307-308 Theta=.5)
DR=0.06875;       %annualized discount rate (Goplakrishnan = .06 - USACE-Philly 1999 feasibility report, page 11 or I)
DT=8.84;            %8.84..Depth of Closure under USACOE 2014 %average depth of closure for beach width (W) - Ortiz 2016 and Lorenzo-Trueba et al 2014 values of 10m-30m for DT
Halpha=3.66;        %minimum height (100yr SWFL)
Walpha=30;           %mimimum berm width

%EXTERNAL LOOP INPUTS VECTORS
CPIn_Vector_star=linspace(.1,15,30);
alpha_Vector=linspace(.1,4000,30); %(0=a intersect, 10/20=b scale, 300 cell resolution = approx 20-25min to run)
%scaling the cell resolution to 30 take 10sec to run%
iml=length(CPIn_Vector_star);     %defining the length of CPIn vector
ivl=length(alpha_Vector);         %defining the length of alpha vector

%result matrix for CPIn and alpha%%%
result_matrixH=zeros(1,ivl);
result_matrixW=zeros(1,ivl);
%Temp Storage Vetor for CPIn and alpha%%
Hstar=NaN(1,ivl);
Wstar=NaN(1,ivl);
H0=.1;

%%%%%%%Optimization Equations%%%%%%%

for im=1:iml; %create the first portion of the forloop%
    CPIn_star=CPIn_Vector_star(im);
    im=im;
   
    for iv=1:ivl;
        alpha_star=alpha_Vector(iv);
        Hstar(iv)=fsolve(@fun10,H0,[],p,CPIn_star,alpha_star,theta,beta,DR,DT,Halpha,Walpha);
        Wstar(iv)=Walpha*(((Hstar(iv)/Halpha)^(-theta))*Walpha*DR*(CPIn_star*DT)/(beta*alpha_star))^(1/(beta-1));
        
    if Hstar(iv)>7; %%new height of USACOE specs 22'.  OLD-->H=6.71m height of 540ft^2 resovior crest above 100SWFL (min effort height to meet FEMA-insurance requirements)
        Hstar(iv)=NaN;
    elseif Hstar(iv)<3  %%height of 100SWFL ~3m (min height for community at 9-12ft +NDVI for Long Beach Island)
        Hstar(iv)=NaN;
    end
    end
    result_matrixH=[result_matrixH;Hstar];
    result_matrixW=[result_matrixW;Wstar];
    Hstar=NaN(1,ivl);
    Wstar=NaN(1,ivl);
end
result_matrixH(1,:)=[];  %close the first row
result_matrixTH=transpose(result_matrixH);  %switches the rows and columns
result_matrixW(1,:)=[];  %close the first row
result_matrixTW=transpose(result_matrixW);  %switches the rows and columns

%plots%%
figure (1)
pcolor(alpha_Vector,CPIn_Vector_star,result_matrixH)
hold on
shading flat
caxis([0 8])
colormap(flipud(pink))
Z=result_matrixH;
[X,Y]=meshgrid(alpha_Vector,CPIn_Vector_star);
set(gca,'PlotBoxAspectRatio',[1,1,1])
set(gcf,'rend','painters'); %using a different renderer (other options include 'opengl' or 'zbuffer') - weird video card
view(0,90)
axis tight
hold off
ylim([.1 15])
xlim([.1 4000])
xlabel('Annualized Baseline Rental Values($K/yr/m)','fontsize',12)
ylabel('Variable Nourishment Costs($/m^3)','fontsize',12)
title('Sustainability of Dune Construction','fontsize',15)
hold on;
