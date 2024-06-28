%% Model Estimation
clear all
%% Import Data
sunat_data_para_estimation = readtable('sunat_data_para_estimation.csv');
sunat_data_para_estimation = table2array(sunat_data_para_estimation);
N = size(sunat_data_para_estimation,1);
Overreport               = sunat_data_para_estimation(:,1);
TotalDeclaredCost        = sunat_data_para_estimation(:,2);
R_i                      = sunat_data_para_estimation(:,3);
mu                       = sunat_data_para_estimation(:,4);
DummyInf                 = sunat_data_para_estimation(:,5);
DummyRem                 = sunat_data_para_estimation(:,6);
DummyCon                 = sunat_data_para_estimation(:,7);


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
    Loss = (@(params2) LossModel(params1, params2, moments, sunat_data_para_estimation, tol, bbb, stepsize, W_matrix, numIter, moments_dummy));

    %To check Loss = 0 when params2 = true params2
    params2= [0.4   0.3     0.5    -0.3  0.5 10]
    %params2 = [0.1 0.6 0.1 -0.05 0.05 15];
    g=Loss(params2)


    %% Building Grid
   % Define los rangos para cada dimensión
%Theta0 = [0.4   0.3     0.5    -0.3  0.5 10]';anteriores
%{
range1 = 0:0.1:0.2;
range2 = 0.4:0.2:0.6;
range3 = 0:0.1:0.2;
range4 = -0.10:0.05:0;
range5 = 0.001:0.049:0.05;
range6 = 10:5:15;
%}
range1 = 0:0.025:0.4;
range2 = 0.2:0.025:0.4;
range3 = 0.4:0.025:0.5;
range4 = -0.4:0.025:-0.3;
range5 = 0.25:0.0625:0.75;
range6 = 5:1.25:10;

% Inicializa la matriz de pérdida (LossGrid) con ceros
LossGrid = zeros(length(range1), length(range2), length(range3), ...
                 length(range4), length(range5), length(range6));

% Define el valor de pérdida para cada combinación de parámetros
for i1 = 1:length(range1)
    for i2 = 1:length(range2)
        for i3 = 1:length(range3)
            for i4 = 1:length(range4)
                for i5 = 1:length(range5)
                    for i6 = 1:length(range6)
                        params2 = [range1(i1) range2(i2) range3(i3) range4(i4) range5(i5) range6(i6)];
                        moments_dummy = 0;
                        Loss = LossModel(params1, params2, moments, sunat_data_para_estimation, tol, bbb, stepsize, W_matrix, numIter, moments_dummy);
                        LossGrid(i1, i2, i3, i4, i5, i6) = Loss;
                    end
                end
            end
        end
    end
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
%{
fprintf('Los parámetros que hacen que LossGrid sea mínimo son:\n');
fprintf('i1: %f\n', 0.1 * (index1 - 1));
fprintf('i2: %f\n', 0.2 * (index2 - 1) + 0.4);
fprintf('i3: %f\n', 0.1 * (index3 - 1));
fprintf('i4: %f\n', 0.05 * (index4 - 1) - 0.10);
fprintf('i5: %f\n', 0.049 * (index5 - 1) + 0.001);
fprintf('i6: %f\n', 5 * (index6 - 1) + 10);
%}
fprintf('i1: %f\n', 0.025 * (index1 - 1));
fprintf('i2: %f\n', 0.025 * (index2 - 1) + 0.2);
fprintf('i3: %f\n', 0.025 * (index3 - 1)+0.4);
fprintf('i4: %f\n', 0.025 * (index4 - 1) - 0.4);
fprintf('i5: %f\n', 0.0625 * (index5 - 1) + 0.25);
fprintf('i6: %f\n', 1.25 * (index6 - 1) + 5);
