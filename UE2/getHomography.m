%% returns the homography between two images
%% assumes that image2 is right of image1
function homography = getHomography(image1, image2)
        %% # of loops
        N = 1000;
        %% threshold
        thresh = 5;
        [frames1, desc1] = vl_sift(image1);
        [frames2, desc2] = vl_sift(image2);
        %% matches
        panoMatches = vl_ubcmatch(desc1,desc2);
        %% sift point positions
        pointsImg1 = frames1(1:2, panoMatches(1,:))';
        pointsImg2 = frames2(1:2, panoMatches(2,:))';
        inliers = [];
        for i = 1 : N
            %% permutate the matches 
            perm = randperm(size(panoMatches,2));
            %% get 4 random points from panoMatches
            idx = perm(1:4);
            %% remaining SIFT points
            remainingSIFT = perm(5:end);
            curr = [];
            %% compute homography throws exception if 
            %% points are collinear (like in description)
            try
                %% compare transformed points between both images
                homography = cp2tform(pointsImg1(idx,:), pointsImg2(idx,:), 'projective');
                %% evaluate homography by comparing control points
                controlPointsImg1 = pointsImg1(remainingSIFT,:);
                controlPointsImg2 = pointsImg2(remainingSIFT,:);
                %% transform img1
                [x1, y1] = tformfwd(homography, controlPointsImg1(:,1), controlPointsImg1(:,2));
                transformed = [x1, y1];
                %% if distance less than threshold
                %% point is an inlier
                for j = 1 : 1 : size(controlPointsImg1,1)
                    dist = norm(transformed(j,:) - controlPointsImg2(j,:));
                    if dist < thresh
                        curr =[curr, remainingSIFT(j)];
                    end
                end
                %% if current array has more inliers than 
                %% inliers array update it
                if size(curr,2) > max(size(inliers,2),3)
                    inliers = curr;
                end
                
            catch exception
               %% exception caught
               warning('4 randomly chosen points are collinear, cannot compute homography.');
            end
        end
    %% return final homography between img1 and img2
    homography = cp2tform(pointsImg1(inliers,:),pointsImg2(inliers,:),'projective');
end
