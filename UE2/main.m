function main()
    Part4();
    Part5();
end


function Part4()
    disp('Part4 - begin');
end


function Part5()
    disp('Part5 - begin');  
    num_clusters=50;
    folderTrain='input/train';
    folderTest='input/test';
    

    wordsCentroids = BuildVocabulary(folderTrain, num_clusters);
    [training, group] = BuildKNN(folderTrain,wordsCentroids);
    conf_matrix = ClassifyImages(folderTest,wordsCentroids,training,group);
    
    imagesc(conf_matrix);
end