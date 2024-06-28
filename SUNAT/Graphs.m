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

%% Building Grid
    counter1 = 0;
    counter2 = 0;
    counter3 = 0;
    counter4 = 0;
    counter5 = 0;
    counter6 = 0;

LossGrid1 = [length(0:0.05:1)];
%%for i1 = 0:0.05:1
for i1 = 0:0.05:1
    counter1 = counter1 + 1;
                        params2 = [i1 0.6 0.1 -0.05 0.05 15];
                        moments_dummy = 0;
                        Loss = (@(params2) LossModel(params1, params2, moments, observed_data, tol, bbb, stepsize, W_matrix, numIter, moments_dummy));                        
                        LossGrid1(counter1)=Loss(params2);
       
end

LossGrid2 = [length(0:0.05:1)];
for i2 = 0:0.05:1
    counter2 = counter2 + 1;
                        params2 = [0.1 i2 0.1 -0.05 0.05 15];
                        moments_dummy = 0;
                        Loss = (@(params2) LossModel(params1, params2, moments, observed_data, tol, bbb, stepsize, W_matrix, numIter, moments_dummy));                        
                        LossGrid2(counter2)=Loss(params2);
       
end

LossGrid3 = [length(0:0.05:1)];
for i3 = 0:0.05:1
    counter3 = counter3 + 1;
                        params2 = [0.1 0.6 i3 -0.05 0.05 15];
                        moments_dummy = 0;
                        Loss = (@(params2) LossModel(params1, params2, moments, observed_data, tol, bbb, stepsize, W_matrix, numIter, moments_dummy));                        
                        LossGrid3(counter3)=Loss(params2);
       
end

LossGrid4 = [length(-1:0.05:0)];
for i4 =-1:0.05:0
    counter4 = counter4 + 1;
                        params2 = [0.1 0.6 0.1 i4 0.05 15];
                        moments_dummy = 0;
                        Loss = (@(params2) LossModel(params1, params2, moments, observed_data, tol, bbb, stepsize, W_matrix, numIter, moments_dummy));                        
                        LossGrid4(counter4)=Loss(params2);
       
end

LossGrid5 = [length(0.001:0.005:0.5)];
for i5 = 0.001:0.005:0.5
    counter5 = counter5 + 1;
                        params2 = [0.1 0.6 0.1 -0.05 i5 15];
                        moments_dummy = 0;
                        Loss = (@(params2) LossModel(params1, params2, moments, observed_data, tol, bbb, stepsize, W_matrix, numIter, moments_dummy));                        
                        LossGrid5(counter5)=Loss(params2);
       
end

LossGrid6 = [length(0:0.25:50)];
for i6 = 0:0.25:50
    counter6 = counter6 + 1;
                        params2 = [0.1 0.6 0.1 -0.05 0.05 i6];
                        moments_dummy = 0;
                        Loss = (@(params2) LossModel(params1, params2, moments, observed_data, tol, bbb, stepsize, W_matrix, numIter, moments_dummy));                        
                        LossGrid6(counter6)=Loss(params2);
       
end
%%
% 0:0.05:1
space = linspace(0,1,length(0:0.05:1))
plot(space,LossGrid1,'red', 'LineStyle','-')
xlabel("l0")
ylabel("Loss") 
saveas(gcf, fullfile(pwd, 'Graph', 'l0_loss.png'))
saveas(gcf, fullfile(pwd, 'Graph', 'l0_loss.fig'))

% 0:0.05:1
space = linspace(0,1,length(0:0.05:1))
plot(space,LossGrid2,'red', 'LineStyle','-')
xlabel("Bl")
ylabel("Loss") 
saveas(gcf, fullfile(pwd, 'Graph', 'Bl_loss.png'))
saveas(gcf, fullfile(pwd, 'Graph', 'Bl_loss.fig'))

% 0:0.05:1
space = linspace(0,1,length(0:0.05:1))
plot(space,LossGrid3,'red', 'LineStyle','-')
xlabel("m0")
ylabel("Loss") 
saveas(gcf, fullfile(pwd, 'Graph', 'm0_loss.png'))
saveas(gcf, fullfile(pwd, 'Graph', 'm0_loss.fig'))

% 0:0.05:1
space = linspace(-1,0,length(-1:0.05:0))
plot(space,LossGrid4,'red', 'LineStyle','-')
xlabel("bm")
ylabel("Loss") 
saveas(gcf, fullfile(pwd, 'Graph', 'bm_loss.png'))
saveas(gcf, fullfile(pwd, 'Graph', 'bm_loss.fig'))

% 0:0.05:1
space = linspace(0.001,0.5,length(0.001:0.005:0.5))
plot(space,LossGrid5,'red', 'LineStyle','-')
xlabel("v")
ylabel("Loss") 
saveas(gcf, fullfile(pwd, 'Graph', 'v_loss.png'))
saveas(gcf, fullfile(pwd, 'Graph', 'v_loss.fig'))

% 0:0.05:1
space = linspace(0,50,length(0:0.25:50))
plot(space,LossGrid6,'red', 'LineStyle','-')
xlabel("k")
ylabel("Loss") 
saveas(gcf, fullfile(pwd, 'Graph', 'k_loss.png'))
saveas(gcf, fullfile(pwd, 'Graph', 'k_loss.fig'))


