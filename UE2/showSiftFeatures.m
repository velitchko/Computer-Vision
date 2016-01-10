function showSiftFeatures(I)
    features = vl_sift(I);
    image(I);
    vl_plotframe(features);

end