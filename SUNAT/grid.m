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
%{
    LossGrid = [length(0:0.1:0.2), length(0.4:0.2:0.6), length(0:0.1:0.2), length(-0.10:0.05:0), length( 0.001:0.049:0.05), length(10:5:15)];
for i1 = 0:0.1:0.2
    counter1 = counter1 + 1;
    display(counter1)    
    for i2 =0.4:0.2:0.6
        counter2 = counter2 + 1;
        for i3 = 0:0.1:0.2
            counter3 = counter3 + 1;
            for i4 = -0.10:0.05:0
                counter4 = counter4 + 1;
                for i5 = 0.001:0.049:0.05
                    counter5 = counter5 + 1;
                    for i6 = 10:5:15
                        counter6 = counter6 + 1;
                        params2 = [i1 i2 i3 i4 i5 i6];
                        moments_dummy = 0;
                        Loss = (@(params2) LossModel(params1, params2, moments, observed_data, tol, bbb, stepsize, W_matrix, numIter, moments_dummy));                        
                        LossGrid(counter1,counter2,counter3,counter4,counter5,counter6)=Loss(params2);
                    end       
                    counter5=0;
                end            
                counter4=0;
            end            
            counter3=0;
        end
        counter2=0;
    end        
    counter1=0;
end
%}
  
LossGrid = [length(0:0.025:0.2), length(0.4:0.05:0.8), length(0:0.025:2), length(-0.2:0.025:0), length( 0.001:0.005:0.2), length(0:1:30)];
for i1 = 0:0.025:0.2
    counter1 = counter1 + 1;
    display(counter1)    
    for i2 =0.4:0.05:0.8
        counter2 = counter2 + 1;
        for i3 = 0:0.025:2
            counter3 = counter3 + 1;
            for i4 = -0.2:0.025:0
                counter4 = counter4 + 1;
                for i5 =  0.001:0.005:0.2
                    counter5 = counter5 + 1;
                    for i6 = 0:1:30
                        counter6 = counter6 + 1;
                        params2 = [i1 i2 i3 i4 i5 i6];
                        moments_dummy = 0;
                        Loss = (@(params2) LossModel(params1, params2, moments, observed_data, tol, bbb, stepsize, W_matrix, numIter, moments_dummy));                        
                        LossGrid(counter1,counter2,counter3,counter4,counter5,counter6)=Loss(params2);
                    end       
                    counter5=0;
                end            
                counter4=0;
            end            
            counter3=0;
        end
        counter2=0;
    end        
    counter1=0;
end

%%
[minValue, linearIndex] = min(LossGrid(:));
% Linealizar el LossGrid
LossGrid_linear = LossGrid(:);

% Encontrar el índice del valor mínimo
[minValue, linearIndex] = min(LossGrid_linear);

% Convertir el índice lineal a subíndices
[index1, index2, index3, index4, index5, index6] = ind2sub(size(LossGrid), linearIndex);

% Mostrar los valores de los parámetros que hacen que LossGrid sea mínimo
fprintf('Los parámetros que hacen que LossGrid sea mínimo son:\n');
fprintf('i1: %f\n', 0.1 * (index1 - 1));
fprintf('i2: %f\n', 0.2 * (index2 - 1) + 0.4);
fprintf('i3: %f\n', 0.1 * (index3 - 1));
fprintf('i4: %f\n', 0.05 * (index4 - 1) - 0.10);
fprintf('i5: %f\n', 0.049 * (index5 - 1) + 0.001);
fprintf('i6: %f\n', 5 * (index6 - 1) + 10);

%%
LossGrid = [length(0:0.025:0.2), length(0.4:0.05:0.8), length(0:0.025:2), length(-0.2:0.025:0), length( 0.001:0.005:0.2), length(0:1:30)]