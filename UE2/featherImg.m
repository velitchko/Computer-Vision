function featheredImg = featherImg(image)
    [height, width, ~] = size(image);
    tmp = zeros(height, width);
    tmp(1,:) = 1;
    tmp(:,1) = 1;
    tmp(height, :) = 1;
    tmp(:, width) = 1;
    
    featheredImg = bwdist(tmp);
    featheredImg = ~tmp - featheredImg;
end