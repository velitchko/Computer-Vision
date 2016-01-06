% classify test images in a given folder
function [conf_matrix] = ClassifyImages(folder,wordsCentroids,training,group)
        
    % list of test images
    [filePaths,~,groupIdx,~,numClasses]=getImageList(folder);
    
    % confusion matrix: classification result of test images
    conf_matrix=zeros([numClasses,numClasses]);
    
    % iterate through all training images
    numFilePaths=length(filePaths);
    %numFilePaths=100; % TODO: remove, just for testing
    
    for n=1:numFilePaths
        % load img
        currFilePath=filePaths{n};               
        I=im2single(imread(currFilePath));                     
        
        % the real group of the image
        realGroup=groupIdx(n);
        
        % now let's classify this image
        classifiedGroup=doClassification(I,wordsCentroids,training,group); %knnclassify(wordHistogram',training,group,3);
        
        % and make an entry in the confusion matrix
        conf_matrix(realGroup,classifiedGroup)=conf_matrix(realGroup,classifiedGroup)+1;
        
        % just some alive message
        if mod(n,100) == 0
            disp(strcat('ClassifyImages: image #',num2str(n)));
        end
    end
end