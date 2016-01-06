% get histogram of visual words contained in a given image
function [wordHistogram] = getWordHistogram(I,wordsCentroids)
    % calc SIFT descriptors
    [~,descriptors]=vl_dsift(I,'Step',2,'Fast');
    descriptors=single(descriptors); % need datatype 'single' for vl_kmeans

    % find nearest words to all those SIFT descriptors
    wordIdx=knnsearch(wordsCentroids',descriptors');

    % count occurences of word indices and normalize
    numWords=size(wordsCentroids,2);
    wordHistogram=histc(wordIdx,1:numWords);
    wordHistogram=wordHistogram/norm(wordHistogram);       
end