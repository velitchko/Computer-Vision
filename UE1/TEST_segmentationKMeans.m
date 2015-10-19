% test function for kmeans - will later be implemented into main
function TEST_segmentationKMeans()
    I=imread('mm.jpg');
    Iout=segmentationKMeans(I,5,false,0.99);
    imshow(Iout);
end