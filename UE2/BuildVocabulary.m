%
%
function [wordsCentroids] = BuildVocabulary(folder, num_clusters)
    wordsCentroids=[];
    
    % get list of all images and their labels
    [filePaths,~,~,~,~]=getImageList(folder);
    
    % init matrix containing a list of all SIFT descriptors, 
    % this is a 128(rows) x numDescriptors (cols) matrix
    allDescriptors=[];
    
    % iterate through all training images
    numFilePaths=length(filePaths);
    % numFilePaths=100; % TODO: remove, just for testing
    
    for n=1:numFilePaths
        currFilePath=filePaths{n};
        I=im2single(imread(currFilePath));
        [~,descriptors]=vl_dsift(I,'Step',5,'Fast');
        descriptors=single(descriptors); % need datatype 'single' for vl_kmeans
        sampledIndices=randsample(size(descriptors,2),100); % get 100 indices from all possible indices
        allDescriptors=[allDescriptors, descriptors(:,sampledIndices)]; % only take a subset of all descriptors
        
        if mod(n,100) == 0
            disp(strcat('BuildVocabulary: image #',num2str(n)));
        end
    end
    
    % now we have all descriptors. let's cluster them into num_clusters
    % clusters with kmeans
    disp('BuildVocabulary: clustering data');
    [wordsCentroids,~]=vl_kmeans(allDescriptors,num_clusters);
    
end