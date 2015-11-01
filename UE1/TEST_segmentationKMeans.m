% test function for kmeans - will later be implemented into main
function TEST_segmentationKMeans()

    close all;

    filenames={'mm.jpg', 'future.jpg', 'simple.PNG'};
    I=imread(filenames{1});
    
    numClusters=5;
    useXY=true;
    thres=0.999999;
    maxIter=1000;
    useMatlabKMeans=false;
    
    
    Iout=segmentationKMeans(I, numClusters, useXY, thres, maxIter, useMatlabKMeans);
    
    
    %close all;
    figure;
    imshow(Iout);
end