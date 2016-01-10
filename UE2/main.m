function main()
    Part4();
    Part5();
end

function Part4()
    disp('Part4 - begin');
    
    % Part A:
    I = im2single(rgb2gray(imread('input/officeview1.jpg')));
    showSiftFeatures(I);
    
    % Part B:
    N = 1000;
    T = 5;
    
    I1 = im2single(rgb2gray(imread('input/officeview1.jpg')));
    I2 = im2single(rgb2gray(imread('input/officeview2.jpg')));
    
    interestPointMatching(I1, I2, N, T);
    
end


function Part5()
    disp('Part5 - begin');  
    
    % some constants
    num_clusters=50;
    folderTrain='input/train';
    folderTest='input/test';    
    
    
    % lets train the classifier and then test it on the test data set
    wordsCentroids = BuildVocabulary(folderTrain, num_clusters);
    [training, group] = BuildKNN(folderTrain,wordsCentroids);
    conf_matrix = ClassifyImages(folderTest,wordsCentroids,training,group);
    
    
    % show confision matrix
    imagesc(conf_matrix);
    
    
    % now let's test some of our own images
    Iforest=im2single(imread('input/ownImg/forest.jpg'));
    Imountain=im2single(imread('input/ownImg/mountain.jpg'));
    Istreet=im2single(imread('input/ownImg/street.jpg'));
    
    % classify
    IforestClassifiedAs=doClassification(Iforest,wordsCentroids,training,group);
    ImountainClassifiedAs=doClassification(Imountain,wordsCentroids,training,group);
    IstreetClassifiedAs=doClassification(Istreet,wordsCentroids,training,group);
    
    % show results
    disp('Classification of own images:');
    disp(strcat('forest.jpg: ',num2str(IforestClassifiedAs)));
    disp(strcat('mountain.jpg: ',num2str(ImountainClassifiedAs)));
    disp(strcat('street.jpg: ',num2str(IstreetClassifiedAs)));
    
end