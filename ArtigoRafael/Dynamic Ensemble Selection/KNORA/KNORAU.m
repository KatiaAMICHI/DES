%Implements the KNORAE dynamic ensemble weighting algorithm. 

function [ totalError, accuracy ] = KNORAU( train, test, range, ensemble, numClassifiers, k, adaptiveWeights, withAKNN  )

[numTest,numCol] = size(test.data);

totalError = 0;
%for each test pattern

h = waitbar(0,'KNORA-UNION...');

for testIndex = 1 : numTest
   
    waitbar(testIndex/numTest)
    %testIndex
    
    testPr = dataset(test.data(testIndex,:),test.labels(testIndex,:));
  if allAgree(ensemble,testPr,numClassifiers),
        
        %if all classifiers have the same output, use the result of the
        %first
        temp = testc(testPr,ensemble{1});
    
  else
    

    if withAKNN,
         [nearests.data,distances,idx] = aknn(train.data,test.data(testIndex,:),range,k,adaptiveWeights);
    else
        [nearests.data,distances,idx] = knn(train.data,test.data(testIndex,:),range,k);
    end;
      

        for nearestIndex = 1 : k

            nearests.labels(nearestIndex,:) = train.labels( idx(:,nearestIndex), : );

        end;

        nearestsDataset = dataset(nearests.data,nearests.labels);

        weights = getWeights( nearestsDataset, ensemble, numClassifiers  );


        comb = wvotec(ensemble,weights);
        temp = testc(testPr,comb);
  end;
  
    if temp ~= 0,
        totalError = totalError + 1;
    end;
    
end;
accuracy = (1 - (totalError/numTest)) * 100;
fprintf('\n  Test results result for KNORAU %f',(totalError/numTest) * 100);
close(h);
