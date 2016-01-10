function interestPointMatching(I1, I2, N, T) 
    [features1, desc1] = vl_sift(I1);
    [features2, desc2] = vl_sift(I2);
    
    matches = vl_ubcmatch(desc1, desc2);
    
    match_plot(I1,I2, features1(1:2, matches(1,:))', features2(1:2, matches(2,:))');
    bestHomography = [];
    bestHomographyMatches = 0;
    
    for i = 1:N
        xRandIdx = randsample(1:size(matches,2), 4);
        yRandIdx = randsample(1:size(matches,2), 4);
        
        xMatches = features1(1:2, matches(1,xRandIdx));
        yMatches = features2(1:2, matches(2,yRandIdx));
        
        try
           [trans,uv,xy,uv_dev,xy_dev] = cp2tform(xMatches', yMatches', 'projective')
           otherPointsX = matches(1,:);
           otherPointsY = matches(2,:);
           
           otherPointsX(xRandIdx) = []; 
           otherPointsY (yRandIdx) = [];
           
           newPoints = squeeze(tformfwd(trans, features1(1, otherPointsX), features1(2, otherPointsX))); 
           
           euclidDistances = sqrt(sum([(newPoints(:,1) - features1(1, otherPointsX)') .^2 , (newPoints(:,2) - features1(2, otherPointsX)') .^2],2));
           
           inliners = sum(euclidDistances < T);
           
           if inliners > bestHomographyMatches 
               bestHomographyMatches = inliners;
           end
        catch   
           
        
    end
end