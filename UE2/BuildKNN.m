function [training, group] = BuildKNN(folder,wordsCentroids)
    training=[];
    group=[];    
    
    
    [filePaths,~,groupIdx,~,~]=getImageList(folder);
    
    
     % iterate through all training images
    numFilePaths=length(filePaths);
    % numFilePaths=100; % TODO: remove, just for testing
    for n=1:numFilePaths
        % load img
        currFilePath=filePaths{n};
        I=im2single(imread(currFilePath));
        
        wordHistogram=getWordHistogram(I,wordsCentroids);
        
%         % calc SIFT descriptors
%         [~,descriptors]=vl_dsift(I,'Step',2,'Fast');
%         descriptors=single(descriptors); % need datatype 'single' for vl_kmeans
%         
%         % find nearest words to all those SIFT descriptors
%         wordIdx=knnsearch(wordsCentroids',descriptors');
%         
%         % count occurences of word indices and normalize
%         wordHistogram=histc(wordIdx,1:numWords);
%         wordHistogram=wordHistogram/norm(wordHistogram);
        
        % put result into training matrix and specify class label (group
        % name)
        training(n,:)=wordHistogram';
        group(n,1)=groupIdx(n);
        
        if mod(n,100) == 0
            disp(strcat('BuildKNN: image #',num2str(n)));
        end
    end
end