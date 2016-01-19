function trans = interestPointMatching(I1, I2, N, T) 
     % Part B.1
    [features1, desc1] = vl_sift(I1);
    [features2, desc2] = vl_sift(I2);
    
    %Part B.2
    matches = vl_ubcmatch(desc1, desc2);
    match_plot(I1,I2, features1(1:2, matches(1,:))', features2(1:2, matches(2,:))');

    %Part B.3
    bestHomographyMatches = 0;
    inlinePoints = [];
    inlinePointsI2 = [];
    
    for i = 1:N
        %Part B.3.a
        xRandIdx = randsample(1:size(matches,2), 4);
        
        xMatches = features1(1:2, matches(1,xRandIdx));
        yMatches = features2(1:2, matches(2,xRandIdx));
        
        try
            %Part B.3.b
           [trans, uv, xy, uv_dev, xy_dev] = cp2tform(xMatches', yMatches', 'projective');
           otherPointsX = matches(1,:);
           otherPointsI2 = matches(2,:);
           
           otherPointsX(xRandIdx) = []; 
           otherPointsI2(xRandIdx) = [];
           
           %Part B.3.c
           newPoints = squeeze(tformfwd(trans, features1(1, otherPointsX), features1(2, otherPointsX))); 
           
           euclidDistances = sqrt(sum([(newPoints(:,1) - features2(1, otherPointsI2)').^2, (newPoints(:,2) - features2(2, otherPointsI2)').^2],2));
           
           %Part B.3.d
           inliners = sum(euclidDistances < T);
           
           
           if inliners > bestHomographyMatches 
               bestHomographyMatches = inliners;
               inlinePoints = [matches(1,xRandIdx) , otherPointsX(euclidDistances < T)];
               inlinePointsI2 = [matches(2, xRandIdx), otherPointsI2(euclidDistances < T)];
           end
        catch    
        end
    end
    
    %Part B.4
    match_plot(I1,I2, features1(1:2,inlinePoints)', features2(1:2,inlinePointsI2)');
    
    
    xMatches = features1(1:2, inlinePoints);
    yMatches = features2(1:2, inlinePointsI2);
        
    [trans, uv, xy, uv_dev, xy_dev] = cp2tform(xMatches', yMatches', 'projective');
    
    otherPointsX = setdiff(matches(1,:), inlinePoints, 'stable');
    otherPointsI2 = setdiff(matches(2,:), inlinePoints, 'stable');
           
    newPoints = squeeze(tformfwd(trans, features1(1, otherPointsX), features1(2, otherPointsX))); 
    
    width = size(I2,2);
    height = size(I2,1); 
    
    xData = [min(yMatches(1,:)), max(yMatches(1,:))];
    yData = [min(yMatches(2,:)), max(yMatches(2,:))];
    
    xyScale =  [xData(2) - xData(1), yData(2) - yData(1)] ./ [size(I2,1), size(I2,2)]; %[max(xMatches(1,:)) - min(xMatches(1,:)), max(xMatches(2,:)) - min(xMatches(2,:))];
    
    %Part B.5
    I = imtransform(I1, trans, 'XData', xData,'YData', yData, 'XYScale', size(I1)./size(I2) );
    figure;
    imshow(I)
    figure;
    
    x = floor(xData(1) );
    y = floor(yData(1) );
    
    overlay = zeros(2000,2000);
    overlay(max(1,y): max(1,y) - 1 + size(I,1), max(1,x): max(1,x) - 1 + size(I,2)) = I;
    overlay(abs(min(1,y)):abs(min(1,y)) + size(I2,1) - 1 , abs(min(1,x)): abs(min(1,x)) + size(I2,2) -1) = abs(overlay(abs(min(1,y)):abs(min(1,y)) + size(I2,1) - 1 , abs(min(1,x)): abs(min(1,x)) + size(I2,2) -1) - I2 );
    imshow(overlay);
end