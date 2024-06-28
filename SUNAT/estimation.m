%% Model Estimation
clear all
%% Import Data
observed_data = readtable('observed_data.csv');
observed_data = table2array(observed_data);
N = size(observed_data,1);
Overreport               = observed_data(:,1);
TotalDeclaredCost        = observed_data(:,2);
R_i                      = observed_data(:,3);
mu                       = observed_data(:,4);
DummyInf                 = observed_data(:,5);
DummyRem                 = observed_data(:,6);
DummyCon                 = observed_data(:,7);


%% Calibrate Parameters "We know"
PHI = 0.5; %Tax shield
ETA = 2.5; %Risk Aversion
TAU = 0.28; %Taxes
P1 = 0.05; %Slope of probability of detection
P0 = 0.2; %Baseline probability of detection
params1 = [PHI ETA TAU P1 P0] ;

%% Infer "True" Costs for a given value of "m"
    %Generate Data Moments
%     D1=mean(mu(DummyCon==1));
%     D2=mean(log(mu(DummyCon==1).*Overreport(DummyCon==1)));
%     D3=mean(mu(DummyInf==1)) - mean(mu(DummyCon==1));
%     D4=mean(mu(DummyRem==1)) - mean(mu(DummyCon==1));
%     D5=mean(log(mu(DummyInf==1).*Overreport(DummyInf==1))) - mean(log(mu(DummyCon==1).*Overreport(DummyCon==1)));
%     D6=mean(log(mu(DummyRem==1).*Overreport(DummyRem==1))) - mean(log(mu(DummyCon==1).*Overreport(DummyCon==1)));

    D1=mean(mu(DummyCon==1));
    D2=mean(Overreport(DummyCon==1));
    D3=mean(mu(DummyInf==1)) - mean(mu(DummyCon==1));
    D4=mean(mu(DummyRem==1)) - mean(mu(DummyCon==1));
    D5=mean(Overreport(DummyInf==1)) - mean(Overreport(DummyCon==1));
    D6=mean(Overreport(DummyRem==1)) - mean(Overreport(DummyCon==1));    
    moments = [D1 D2 D3 D4 D5 D6];

%% Model Loss
    W_matrix = eye(6,6);
    tol = 0.0000001;
    bbb = 0.95;
    stepsize = 0.5;
    numIter =1000000;    
    moments_dummy = 0; %1 if I wanna grab moments from model, 0 if I wanna gran loss function
    Loss = (@(params2) LossModel(params1, params2, moments, observed_data, tol, bbb, stepsize, W_matrix, numIter, moments_dummy));

    %To check Loss = 0 when params2 = true params2
    params2 = [0.1 0.6 0.1 -0.05 0.05 15];
    Loss(params2);

%% Model estimation
    LB = [0 0 0 -1 0.001 0];
    UB = [1 1 1 0 1 inf]; 
    options = optimoptions('particleswarm','SwarmSize',50,'UseParallel',true);    
    [params_est_tilde] = particleswarm(Loss,6,LB,UB,options);




