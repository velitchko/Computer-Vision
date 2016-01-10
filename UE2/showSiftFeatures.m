function showSiftFeatures(I)
    [features, desc] = vl_sift(I);
    imshow(I);
    vl_plotframe(features);

end