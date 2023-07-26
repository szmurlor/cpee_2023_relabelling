clear all;
close all;
%%

wyn=[]; wynVal=[];
Pred_y=[]; Pred_yVal=[];
liczba_cech = [];

% the variable should be accessible by the customreader so let we make them
% global
global images
global idx

%images = imageDatastore( 'C:\Users\szmurlor\Nextcloud\ALEX_obrazy_all',...
images = imageDatastore( '/home/szmurlor/Nextcloud/ALEX_obrazy_all',...
    'IncludeSubfolders',true,...
    'ReadFcn', @customreader, ...
    'LabelSource','foldernames');

original_labels = images.Labels;

imageAugmenter = imageDataAugmenter( ...
    'RandRotation',[-20,20], ...
    'RandXTranslation',[-3 3], ...
    'RandYTranslation',[-3 3]);


wrr = 0:0.05:0.75;
wrong_labelss = [];
good_labels = [];
good_labels_corrected = [];

for iwrr=wrr

    % add wrong labels to the dataset
    all_labels = unique(original_labels);
    n = size(original_labels,1);
    idx = randi([1 n], int16(n*iwrr),1);
    new_labels = original_labels;
    new_labels(idx) = randsample(all_labels, int16(n*iwrr), true);
    wrong_labels = sum(original_labels ~= new_labels) / n;
    images.Labels = new_labels;
    wrong_labelss = [wrong_labelss wrong_labels];

    % configure Alexnet CNN model
    net = alexnet;
    layersTransfer = net.Layers(1:end-6);
    inputSize = net.Layers(1).InputSize;

    layer = 'fc7';
    if 1==1 % change to 1==0 to skip correction procedure
        %augimds = augmentedImageDatastore(inputSize(1:2),images);
        features = activations(net,images,layer,'OutputAs','rows');
        
        %Mdl = fitcknn(features,new_labels,'NumNeighbors',4,'Standardize',1, 'DistanceWeight','inverse')
        Mdl = fitcknn(features,new_labels,'NumNeighbors',5,'Standardize',1)
        [yy,sc, cst] = predict(Mdl, features);        
        good_labels = [good_labels sum(new_labels==original_labels)/numel(yy)]
        good_labels_corrected = [ good_labels_corrected sum(yy==original_labels)/numel(yy) ]
        images.Labels = yy;
    else
        display("*********** SKIPPING CORRECTIONS **********************")
    end
    
    
    [uczImages,testImages] = splitEachLabel(images,0.7,'randomized');
    i=1
    [trainingImages,validationImages] = splitEachLabel(uczImages,0.70+0.25*rand(1),'randomized');
    numTrainImages = numel(trainingImages.Labels);    
    
    augimdsTrain = augmentedImageDatastore(inputSize(1:2),trainingImages,'DataAugmentation',imageAugmenter);
    augimdsTest = augmentedImageDatastore(inputSize(1:2),testImages);
    featuresTrain = activations(net,augimdsTrain,layer,'OutputAs','rows');
    featuresTest = activations(net,augimdsTest,layer,'OutputAs','rows');
    
    numClasses = numel(categories(trainingImages.Labels));
    layers = [
        layersTransfer
        fullyConnectedLayer(700+35*i,'WeightLearnRateFactor',20,'BiasLearnRateFactor',20)
        reluLayer()
        dropoutLayer(0.4+0.23*rand(1))
        fullyConnectedLayer(numClasses,'WeightLearnRateFactor',20,'BiasLearnRateFactor',20)
        softmaxLayer
        classificationLayer];
    
    miniBatchSize = 10; % was 10
    numIterationsPerEpoch = floor(numel(trainingImages.Labels)/miniBatchSize);
    options = trainingOptions('sgdm',...
        'MiniBatchSize',miniBatchSize,...
        'MaxEpochs',20,...
        'ExecutionEnvironment','gpu',...
        'InitialLearnRate',1.3e-4,...
        'Verbose',true,...
        'ValidationPatience',10,...% was 10
        'ValidationData',validationImages,...
        'ValidationFrequency',numIterationsPerEpoch);
    
    netTransfer = trainNetwork(augimdsTrain,layers,options);
    
    % print model architecture
    % analyzeNetwork(netTransfer)
    predictedLabels = classify(netTransfer,testImages);
    testLabels = testImages.Labels;
    accuracy = (mean(predictedLabels == testLabels))*100;
    xu=double(featuresTrain);  maxu=max(abs(xu)); xu=xu./maxu;
    xt=double(featuresTest);   xt=xt./maxu;
    ducz=double(trainingImages.Labels);
    dtest=double(testLabels);
    liczba_cech = [liczba_cech size(xu,2)]
    wyn=[wyn accuracy]
    
    plot(wrong_labelss, wyn);
    pause(0.1)
    
    
end

plot(wrong_labelss, wyn, 'or',wrong_labelss, wyn, 'b')
xlabel('Wrong labels ratio')
ylabel('Accuracy')
title('CNN with wrong labelling ratio')
grid;
