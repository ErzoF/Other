%% Generate Data
clear all
numIter =1000000;
stepsize = 0.5;
tol = 0.000000001;
bbb = 0.90;
rng(123)

%% Set Parameter Values

%parameters we estimate
%{
lambda0 = 0.1 ; %perception that I will get caught
Blambda = 0.6  ; %effect on lambda from treatment
M0 =   0.1 ; %degree of inattention
Bm = -0.05 ; %effect on innatention from treatment
V =  0.05; %semi elasticity from utility to probility of cheating
K = 15; %social norms
%}
%Theta0 = [0.4   0.3     0.5    -0.3  0.5 10]';anteriores
lambda0 = 0.4 ; %perception that I will get caught
Blambda = 0.3  ; %effect on lambda from treatment
M0 =   0.5 ; %degree of inattention
Bm = -0.3 ; %effect on innatention from treatment
V =  0.5; %semi elasticity from utility to probility of cheating
K = 10; %social norms

%parameters we calibrate
PHI = 0.5; %Tax shield
ETA = 2.5; %Risk Aversion
TAU = 0.28; %Taxes
P1 = 0.05; %Slope of probability of detection
P0 = 0.2; %Baseline probability of detection

%% Exogenous Characterstics: [Pi_i,C_i,R_i,DummyInf,DummyRem,DummyCon]
sunat_data = readtable('sunat.csv');
sunat_data = table2array(sunat_data);
N = size(sunat_data,1);
TotalDeclaredCost = sunat_data(:,2); %declared costs
R_i = sunat_data(:,1);  %revenues
Overreport = sunat_data(:,4);  %revenues
%% Treatment Status and Final Lambda and M
DummyInf = sunat_data(:,4);
DummyRem = sunat_data(:,5);
DummyCon = sunat_data(:,6);

Lambda = lambda0 + Blambda*DummyInf;
m = M0 +Bm*DummyInf + Bm*DummyRem;

%% 
C_i=TotalDeclaredCost-Overreport  
c_a=TotalDeclaredCost-C_i-m.*C_i ;
Pi_i=R_i-C_i
p = max(min(P0 + P1.*Lambda.*c_a,1),0);
%%
y_g = (1-TAU).*Pi_i + TAU*(c_a + m.*C_i);
y_b = (1-TAU).*Pi_i +TAU.*m.*C_i - PHI.*TAU.*c_a;
u_g = (y_g.^(1-ETA))/(1-ETA);
u_b = (y_b.^(1-ETA))/(1-ETA);
eu = (1-p).*u_g + p.*u_b;
%when cheating == 0
y_nocheat = (1-TAU)*Pi_i +TAU*m.*C_i;
u_nocheat = (y_nocheat.^(1-ETA))/(1-ETA);
mu = exp((1/V)*eu)./(exp((1/V)*eu)+ K*exp((1/V)*u_nocheat)) ;
%check some regression results

%%
ModDummyInf=DummyInf;
ModDummyRem=DummyRem;
ModDummyCon=DummyCon;
ModDummyInf(isnan(mu))=NaN;
ModDummyRem(isnan(mu))=NaN;
ModDummyCon(isnan(mu))=NaN;
ou=Overreport.*mu;
ou(isnan(mu))=NaN;

%%
~any(isnan(ModDummyInf), 2)
%%
ModDummyInf=ModDummyInf(~any(isnan(ModDummyInf), 2));
ModDummyRem=ModDummyRem(~any(isnan(ModDummyRem), 2));
ModDummyCon=ModDummyCon(~any(isnan(ModDummyCon), 2));
mumod=mu(~any(isnan(mu), 2));
ou=ou(~any(isnan(ou), 2));
Overreportmod=Overreport(~any(isnan(mu), 2));
mumod=real(mumod)
ou=real(ou)

TotalDeclaredCostmod=TotalDeclaredCost(~any(isnan(mu), 2));
R_imod=R_i(~any(isnan(mu), 2));
%%
fitlm([ModDummyInf ModDummyRem],mumod)
fitlm([ModDummyInf ModDummyRem],Overreportmod)
fitlm([ModDummyInf ModDummyRem],ou)
%%

%export
sunat_data_para_estimation = [Overreportmod, TotalDeclaredCostmod, R_imod, mumod, ModDummyInf, ModDummyRem, ModDummyCon];
writematrix(sunat_data_para_estimation,'sunat_data_para_estimation.csv') 
