function [conf_matrix] = ClassifyImages(folder,wordsCentroids,training,group)
        
    [filePaths,~,groupIdx,~,numClasses]=getImageList(folder);
    conf_matrix=zeros([numClasses,numClasses]);
    
    % iterate through all training images
    numFilePaths=length(filePaths);
    % numFilePaths=100; % TODO: remove, just for testing
    
    for n=1:numFilePaths
        % load img
        currFilePath=filePaths{n};
        I=im2single(imread(currFilePath));
                
        wordHistogram=getWordHistogram(I,wordsCentroids);
        
        % classify (disable warnings cause knnclassify warns about its
        % removal in a future release)
        warningsOrigState = warning;
        warning('off','all');
        realGroup=groupIdx(n);
        classifiedGroup=knnclassify(wordHistogram',training,group,3);
        warning(warningsOrigState);
        
        conf_matrix(realGroup,classifiedGroup)=conf_matrix(realGroup,classifiedGroup)+1;
        
        if mod(n,100) == 0
            disp(strcat('ClassifyImages: image #',num2str(n)));
        end
    end
end