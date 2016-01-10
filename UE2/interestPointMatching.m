function interestPointMatching(I1, I2, N) 
    [features1, desc1] = vl_sift(I1);
    [features2, desc2] = vl_sift(I2);
    
    matches = vl_ubcmatch(desc1, desc2);
    
    match_plot(I1,I2, features1(1:2, matches(1,:))', features2(1:2, matches(2,:))')
    bestHomography = [];
    bestHomographyMatches = 0;
    
    for i = 1:N
        xRandIdx = randsample(matches(1,:), 4);
        yRandIdx = randsample(matches(2,:), 4);
        
        xMatches = features1(1:2, xRandIdx);
        yMatches = features2(1:2, yRandIdx);
        
        try
           [trans,uv,xy,uv_dev,xy_dev] = cp2tform(xMatches', yMatches', 'projective')
           otherPointsX = matches(1,:);
           otherPointsY = matches(2,:);
           
           otherPointsX(xRandIdx) = []; 
           otherPointsY (yRandIdx) = [];
           
           [newPointsX, newPointsY] = tformfwd(trans, features1(1, otherPointsX), features1(2, otherPointsX)); 
           
           
        catch   
           
        
    end
end