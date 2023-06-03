% function coba
clear all




% digitDatasetPath = fullfile(matlabroot,'toolbox','nnet','nndemos', ...
%     'nndatasets','DigitDataset');
% digitDatasetPath ='D:\Tel-U\30. Mahasiswa\2023-1\ghifar\Data\watermark\Fontfolder\';
% imds = imageDatastore(digitDatasetPath, ...
%     'IncludeSubfolders',true,'LabelSource','foldernames');

digitDatasetPath ='C:\Users\AICOMS\Documents\Goki\0. Python\cnn_font\';


imds = imageDatastore(digitDatasetPath, ...
    'IncludeSubfolders',true,'LabelSource','foldernames');

% for i=1:length(imds.Files)
% [p,q]=find(char(imds(i).Files)=='\');
% continue
% end
% imds
% x=imds.Labels
whos

labelCount = countEachLabel(imds);
img = readimage(imds,1);
size(img)

% numTrainFiles = length(imds.Labels)-36;
numTrainFiles = 12;%dari 12
% numTrainFiles = 750;

[imdsTrain,imdsValidation] = splitEachLabel(imds,numTrainFiles,'randomize');

layers = [
    imageInputLayer([56 28 1])
    
    convolution2dLayer(3,8,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,16,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,32,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    fullyConnectedLayer(26)
    softmaxLayer
    classificationLayer];

% options = trainingOptions('sgdm', ...
%     'InitialLearnRate',0.3, ...
%     'MaxEpochs',60, ...
%     'Shuffle','every-epoch', ...
%     'ValidationData',imdsValidation, ...
%     'ValidationFrequency',150, ...
%     'Verbose',false, ...
%     'Plots','training-progress');
options = trainingOptions('sgdm', ...
    'InitialLearnRate',0.3, ...
    'MaxEpochs',60, ...
    'Shuffle','every-epoch', ...
    'Verbose',false, ...
    'Plots','training-progress');


net = trainNetwork(imdsTrain,layers,options);

YPred = classify(net,imds);
YValidation = imds.Labels;

accuracy = sum(YPred == YValidation)/numel(YValidation)