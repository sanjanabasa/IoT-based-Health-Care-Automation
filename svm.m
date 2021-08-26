clc;
clear all;
close all;
start= fullfile('C:','matlab','2','final','train_dataset');
allsfolder=genpath(start);
remain=allsfolder;
listoffolder={};
while true
    [singlesubfolder, remain]=strtok(remain,';');
    if isempty(singlesubfolder)
        break;
    end
    listoffolder= [listoffolder singlesubfolder];
end
numberoffolder=length(listoffolder);
features_train=[];
label_train=[];

for k=1: numberoffolder
    thisfolder=listoffolder{k};
    filepattern=sprintf('%s/*.txt',thisfolder);
    basefile=dir(filepattern);
    nofiles=length(basefile);
    if nofiles>=1
        for f=1:nofiles
            filename=fullfile(thisfolder,basefile(f).name);
            [feature_array]=feature_extraction(filename);
            
            features_train=[features_train ; feature_array ];
            if(thisfolder==fullfile(start,'apnea'))
                label_train=[label_train; 1];
            
            elseif(thisfolder==fullfile(start,'norma'))
                    label_train=[label_train; 0];
            end
        end
    end
            
end

%svm
SVMModel = fitcsvm(features_train,label_train,'Standardize',true,'KernelFunction','RBF','KernelScale','auto');
CVSVMModel = crossval(SVMModel);
% classLoss = kfoldLoss(CVSVMModel);

%test
start= fullfile('C:','matlab','2','final','test_dataset');
allsfolder=genpath(start);
remain=allsfolder;
listoffolder={};
while true
    [singlesubfolder, remain]=strtok(remain,';');
    if isempty(singlesubfolder)
        break;
    end
    listoffolder= [listoffolder singlesubfolder];
end
numberoffolder=length(listoffolder);
features_test=[];
label_test=[];

for k=1: numberoffolder
    thisfolder=listoffolder{k};
    filepattern=sprintf('%s/*.txt',thisfolder);
    basefile=dir(filepattern);
    nofiles=length(basefile);
    if nofiles>=1
        for f=1:nofiles
            filename=fullfile(thisfolder,basefile(f).name);
            [feature_array]=feature_extraction(filename);
            
            features_test=[features_test ; feature_array ];
            if(thisfolder==fullfile(start,'apnea'))
                label_test=[label_test; 1];
            
            elseif(thisfolder==fullfile(start,'norma'))
                    label_test=[label_test; 0];
            end
        end
    end
            
end

[outputs,score] = predict(SVMModel,features_test);
%table(YTest(1:10),label(1:10),score(1:10,2),'VariableNames',{'TrueLabel','PredictedLabel','Score'})
plotconfusion(label_test.',outputs.');
