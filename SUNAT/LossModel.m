function [F] = LossModel(params1, params2, moments, observed_data, tol, bbb, stepsize, W_matrix , numIter, moments_dummy)

%% Reading Data
N = size(observed_data,1);
Overreport               = observed_data(:,1);
TotalDeclaredCost        = observed_data(:,2);
R_i                      = observed_data(:,3);
mu                       = observed_data(:,4);
DummyInf                 = observed_data(:,5);
DummyRem                 = observed_data(:,6);
DummyCon                 = observed_data(:,7);

%% Parameters we know
PHI = params1(1); %Tax shield
ETA = params1(2); %Risk Aversion
TAU = params1(3); %Taxes
P1 = params1(4); %Slope of probability of detection
P0 = params1(5); %Baseline probability of detection

%% Parameters we are gonna estimate
lambda0 = params2(1) ; %perception that I will get caught
Blambda = params2(2) ; %effect on lambda from treatment
M0 =  params2(3); %degree of inattention
Bm = params2(4) ; %effect on innatention from treatment
V =  params2(5); %semi elasticity from utility to probility of cheating
K = params2(6); %social norms

%% Infer True Costs, Profits, and Compute lambda and m
C_i =  TotalDeclaredCost - Overreport;
Pi_i = R_i - C_i;
Lambda = lambda0 + Blambda*DummyInf;
m = M0 +Bm*DummyInf + Bm*DummyRem;

%% Restricting Values for Lambda and m

if length(Lambda(Lambda >1))>0 ||  length(Lambda(Lambda <0))>0 || length(m(m >1))>0 || length(m(m<0))>0

    if moments_dummy == 1
        F=[NaN NaN NaN NaN NaN NaN];
    else
        F=NaN;
    end
    display("Skip Iteration because of restricted value of lambda or m")
else
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
    
        if mod(iloop,25000)==0
            display(max(abs(FOC-0)))
            if (max(abs(FOC-0))) < tol
                break
            end
        end
    
     %smoothing
      c_a_tilde = bbb.*c_a_tilde + (1-bbb).*c_a ;
    end
    
    mu_model = exp((1/V)*eu)./(exp((1/V)*eu)+ K*exp((1/V)*u_nocheat)) ;
    Overreport_model = m.*C_i + c_a;
    
    %%  Generate Model Moments
%         M1=mean(mu_model(DummyCon==1));
%         M2=mean(log(mu_model(DummyCon==1).*Overreport_model(DummyCon==1)));
%         M3=mean(mu_model(DummyInf==1)) - mean(mu_model(DummyCon==1));
%         M4=mean(mu_model(DummyRem==1)) - mean(mu_model(DummyCon==1));
%         M5=mean(log(mu_model(DummyInf==1).*Overreport_model(DummyInf==1))) - mean(log(mu_model(DummyCon==1).*Overreport_model(DummyCon==1)));
%         M6=mean(log(mu_model(DummyRem==1).*Overreport_model(DummyRem==1))) - mean(log(mu_model(DummyCon==1).*Overreport_model(DummyCon==1)));
 
        M1=mean(mu_model(DummyCon==1));
        M2=mean(Overreport_model(DummyCon==1));
        M3=mean(mu_model(DummyInf==1)) - mean(mu_model(DummyCon==1));
        M4=mean(mu_model(DummyRem==1)) - mean(mu_model(DummyCon==1));
        M5=mean(Overreport_model(DummyInf==1)) - mean(Overreport_model(DummyCon==1));
        M6=mean(Overreport_model(DummyRem==1)) - mean(Overreport_model(DummyCon==1));        
        moments_model = [M1 M2 M3 M4 M5 M6];
        Loss = (moments_model-moments)*W_matrix*(moments_model-moments)';
    
    %% Export
        if moments_dummy == 1
            F=moments_model;
        else
            F=Loss*1000000;
        end
            display(params2)
            display(Loss)          
            display(moments_model)
            display(moments)
end
end
