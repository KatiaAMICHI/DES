function [meanVector, stdVector, processingTime, selectorPerformance] = scriptStart2(base, withENN , ennK, classifier, withAKNN)

% Variaveis para an�lise
processingTime = [];
resultsVector = [];

prwarning(0); % surpress prtools warning

for i = 1 : 3

% Define o n�mero de classificadores e de vizinhos (k)
k = 7;                % N�mero (k) de vizinhos
numClassifiers = 10;  % N�mero de classificadores a serem gerados (ensemble)

% M�todos de gera��o de Ensemble
bagging = 0;          % Bagging ensemble
boosting = 1;         % Boosting ensemble 
randomSubspaces = 2;  % RSS ensemble 

[trainDataset, testDataset, validationDataset, range] = initDataset(base, withENN, ennK);

% % Pegando os dados de Treinamento, Valida��o e Teste
train.data = getdata(trainDataset);
train.labels = getlab(trainDataset);
validation.data = getdata(validationDataset);
validation.labels = getlab(validationDataset);
test.data = getdata(testDataset);
test.labels = getlab(testDataset);

adaptiveWeights = getAdaptiveWeights(validation.data, validation.labels);

% Gerando o Ensemble (Boosting, Bagging ou Random Subspaces)
[ensemble, adaboostCombination] = generateEnsemble(trainDataset, numClassifiers, bagging, classifier);

tic;

% KNORA-Eliminate
[totalError, error, results, selectorPerformance] = KNORAE(validation, test, range, ensemble, numClassifiers, k, adaptiveWeights, withAKNN);

% KNORA-Union
% [totalErrorKNORAU, results] = KNORAU(validation, test, range, ensemble, numClassifiers, k, adaptiveWeights, withAKNN);

% Vari�veis para an�lise: Tempo de execu��o e resultado
processingTime = [processingTime toc];
resultsVector = [resultsVector results];

end;

meanVector = mean(resultsVector);
stdVector = std(resultsVector);
processingTime = mean(processingTime);

