%
%
function [wordsCentroids] = BuildVocabulary(folder, num_clusters)
    wordsCentroids=[];
    
    % get list of all images and their labels
    [filePaths,groups]=getImageList(folder);
    
    
    for n=1:length(filePaths)
        currFilePath=filePaths{n};
        I=im2single(imread(currFilePath));
        [frames,descrs]=vl_dsift(I,'Step',1,'Fast');
        sampleIndices=randsample(size(descrs,2),100); % get 100 indices from all possible indices
        descrsSampled=descrs(:,sampleIndices);
    end
    
end