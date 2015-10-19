% test function for kmeans - will later be implemented into main
function TEST_segmentationKMeans()
    %I=imread('mm.jpg');
    I=imread('future.jpg');
    Iout=segmentationKMeans(I,5,true,0.9,1000);
    imshow(Iout);
end