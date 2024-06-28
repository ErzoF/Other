%% Generate Data
cd 'C:\Users\Erzo\OneDrive - Universidad del Pacífico\Univesidad del Pacífico\Ciclo\lCiclo 7 2024 I\Asistente\GND\CODE_DANIEL'

tic
%Code that generates simulated data from model in Castro, Heredia, and Velasquez (2024)
clear all
numIter =1000000;
stepsize = 0.5;
tol = 0.000000001;
bbb = 0.90;
rng(123)

%% Set Parameter Values

%parameters we estimate
lambda0 = 0.1 ; %perception that I will get caught
Blambda = 0.6  ; %effect on lambda from treatment
M0 =   0.1 ; %degree of inattention
Bm = -0.05 ; %effect on innatention from treatment
V =  0.05; %semi elasticity from utility to probility of cheating
K = 15; %social norms

%parameters we calibrate
PHI = 0.5; %Tax shield
ETA = 2.5; %Risk Aversion
TAU = 0.28; %Taxes
P1 = 0.05; %Slope of probability of detection
P0 = 0.2; %Baseline probability of detection

%% Exogenous Characterstics
N = 102; %num obs
Pi_i = randn(N,1)+3; %profits
C_i = randn(N,1) + 3; %costs
R_i = Pi_i +C_i;   %revenues

%% Treatment Status and Final Lambda and M
DummyInf = zeros(N,1);
DummyRem = zeros(N,1);
DummyCon = zeros(N,1);

DummyInf(1:N/3) = 1;
DummyRem(N/3+1:2*N/3) = 1;
DummyCon(2*N/3:N) = 1;

Lambda = lambda0 + Blambda*DummyInf;
m = M0 +Bm*DummyInf + Bm*DummyRem;

%% Solving FOC given exogenous characteristics, and computing logistic

%guess of c_a: 
c_a = ones(N,1);
c_a_tilde = c_a;

for iloop = 1:numIter
c_a = c_a_tilde;

%when cheating == 1
y_g = (1-TAU).*Pi_i + TAU*(c_a + m.*C_i);
y_b = (1-TAU).*Pi_i +TAU.*m.*C_i - PHI.*TAU.*c_a;
u_g = (y_g.^(1-ETA))/(1-ETA);
u_b = (y_b.^(1-ETA))/(1-ETA);
p = max(min(P0 + P1.*Lambda.*c_a,1),0);
eu = (1-p).*u_g + p.*u_b;

%when cheating == 0
y_nocheat = (1-TAU)*Pi_i +TAU*m.*C_i;
u_nocheat = (y_nocheat.^(1-ETA))/(1-ETA);

%FOC wrt c_a
FOC = p.*y_b.^(-ETA).*(-PHI.*TAU) + TAU.*(1-p).*y_g.^(-ETA) - Lambda.*(u_g-u_b).*P1;

%update
    %if FOC <0, marginal utility from cheating is too low --> decrease cheating to increase MU
    %if FOC >0, marginal utility from cheating is too high --> increase cheating to decrease MU
    c_a_tilde = c_a .* ( 1 - (0-FOC).*stepsize);

    if mod(iloop,5000)==0
        display(max(abs(FOC-0)))
        if (max(abs(FOC-0))) < tol
            break
        end
    end

 %smoothing
  c_a_tilde = bbb.*c_a_tilde + (1-bbb).*c_a ;
end
toc

mu = exp((1/V)*eu)./(exp((1/V)*eu)+ K*exp((1/V)*u_nocheat)) ;
Overreport = m.*C_i + c_a;
TotalDeclaredCost = C_i + c_a+m.*C_i ;

%check some regression results
fitlm([DummyInf DummyRem],mu)
fitlm([DummyInf DummyRem],Overreport)
fitlm([DummyInf DummyRem],Overreport.*mu)

%export
observed_data = [Overreport, TotalDeclaredCost, R_i, mu, DummyInf, DummyRem, DummyCon];
writematrix(observed_data,'observed_data.csv') 
