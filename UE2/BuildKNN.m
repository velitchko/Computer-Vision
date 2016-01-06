% calc distribution of words of different categories of images
function [training, group] = BuildKNN(folder,wordsCentroids)
    training=[];
    group=[];    
    
    % get list of training images
    [filePaths,~,groupIdx,~,~]=getImageList(folder);
    
    
     % iterate through all training images
    numFilePaths=length(filePaths);
    %numFilePaths=100; % TODO: remove, just for testing
    
    for n=1:numFilePaths
        % load img
        currFilePath=filePaths{n};
        I=im2single(imread(currFilePath));
        
        % calc histogram of words
        wordHistogram=getWordHistogram(I,wordsCentroids);        
        
        % put result into training matrix and specify class label (group
        % name)
        training(n,:)=wordHistogram';
        group(n,1)=groupIdx(n);
        
        % just some alive message
        if mod(n,100) == 0
            disp(strcat('BuildKNN: image #',num2str(n)));
        end
    end
end