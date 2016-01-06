% classify a single image
function [classifiedGroup]=doClassification(I,wordsCentroids,training,group)
    % calc histogram of current image
    wordHistogram=getWordHistogram(I,wordsCentroids);
    
    % warnings off
    warningsOrigState = warning;
    warning('off','all');
    
    % classify
    classifiedGroup=knnclassify(wordHistogram',training,group,3);
    
    % warning on again
    warning(warningsOrigState);
end