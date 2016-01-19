function main()
    
    %% init VLFeat lib 
    % bitte das Kommando einmalig !lokal! ausführen und anschließend savepath aufrufen
    % bei mir gibts sonst Probleme mit den Pfaden der MEX Files 
    %run('vlfeat-0.9.20/toolbox/vl_setup');     
    figure;
    Part4(1);
    drawnow;
    
    figure;
    Part5();
    drawnow;
    
end

function Part4(c)
    disp('Part4 - begin');
    if c == 1
        panoramaOut = panorama('input/officeview1.jpg', 'input/officeview2.jpg', 'input/officeview3.jpg', 'input/officeview4.jpg', 'input/officeview5.jpg');
        figure(1);
        title('Office View');
        imshow(panoramaOut);
    end
    if c == 2
        panoramaOut = panorama('input/campus1.jpg', 'input/campus2.jpg', 'input/campus3.jpg', 'input/campus4.jpg', 'input/campus5.jpg'); 
        figure(2);
        title('Campus');
        imshow(panoramaOut);
    end
    if c == 3
        panoramaOut = panorama('input/user1.jpg', 'input/user2.jpg', 'input/user3.jpg', 'input/user4.jpg', 'input/user5.jpg'); 
        figure(2);
        title('User');
        imshow(panoramaOut);
    end
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