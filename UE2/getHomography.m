function homography = getHomography(image1, image2)
        %% # of loops
        N = 1000;
        %% threshold
        thresh = 5;
        [f1, d1] = vl_sift(image1);
        [f2, d2] = vl_sift(image2);
        %% matches
        matches = vl_ubcmatch(d1,d2);
        %% sift point positions
        pos1 = f1(1:2, matches(1,:))';
        pos2 = f2(1:2, matches(2,:))';
        inliers = [];
        for k = 1 : 1 : N
            perm = randperm(size(matches,2));
            idx = perm(1:4);
            ctrl = perm(5:end);
            curr = [];
            %% compute homography throws exception if 
            %% points are collinear (like in description)
            try
                %% compare transformed points between both images
                homograph = cp2tform(pos1(idx,:), pos2(idx,:), 'projective');
                %% evaluate homography
                ctrl1 = pos1(ctrl,:);
                ctrl2 = pos2(ctrl,:);
                [x1, y1] = tformfwd(homograph, ctrl1(:,1), ctrl1(:,2));
                transformed = [x1, y1];
                %% if distance less than threshold
                %% point is an inlier
                for j = 1 : 1 : size(ctrl1,1)
                    dist = norm(transformed(j,:) - ctrl2(j,:));
                    if dist < thresh
                        curr =[curr, ctrl(j)];
                    end
                end
                
                if size(curr,2) > max(size(inliers,2),3)
                    inliers = curr;
                end
                
            catch err
               %% exception caught
            end
        end
    
    homography = cp2tform(pos1(inliers,:),pos2(inliers,:),'projective');
end
