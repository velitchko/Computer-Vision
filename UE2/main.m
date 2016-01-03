function main()
    Part4();
    Part5();
end


function Part4()
    
end


function Part5()
    num_clusters=50;
    folderTrain='input/train';
    folderTest='input/test';
    

    wordsCentroids = BuildVocabulary('input/train', num_clusters);
    [training, group] = BuildKNN(folderTrain,wordsCentroids);
    conf_matrix = ClassifyImages(folderTest,wordsCentroids,training,group);
end