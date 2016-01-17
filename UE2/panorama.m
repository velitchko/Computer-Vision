%% returns a panorama image 
%% can take a variable number of input images
function panoramaOut = panorama(varargin)
    
    %% initiate variables
    imgCount = nargin;
    colorImgs = cell(imgCount);
    grayImgs = cell(imgCount);
    featherImgs = cell(imgCount);
    imgHomography = cell(imgCount);
    %% doesnt work for input sizes multiple of 2
    refImg = ceil(imgCount/2);

    %% load color & grayscale images
    for i = 1 : imgCount 
        img = imread(varargin{i});
        colorImgs{i} = im2double(img);
        grayImgs{i} = im2single(rgb2gray(img));
    end
    
    %% compute image homographies
    for i = 1 : imgCount-1
        %% need to do this otherwise panorama
        %% folds up onto itsself on the left side
        %% from the left side
        if i < refImg
            imgHomography{i} = getHomography(grayImgs{i}, grayImgs{i+1});
        %% from the right side
        else
            imgHomography{i} = fliptform(getHomography(grayImgs{i}, grayImgs{i+1}));
        end
    end
    
    if refImg > 2
        for i = refImg-2 : 1
            imgHomography{i} = maketform('composite', imgHomography{i}, imgHomography{i+1});
            imgHomography{refImg + i} = maketform('composite', imgHomography{refImg + i - 1}, imgHomography{refImg + i});
        end
    end
    
    %% we need the size of an image to get the final panorama size
    %% take refImg as reference image
    [height,width,~] = size(colorImgs{refImg});
    minX = 1;
    minY = 1;
    maxX = width;
    maxY = height;
    for i = 1 : imgCount
        %% no need to do this for the reference image
        if i ~= refImg
            [height,width,~] = size(colorImgs{i});
            %% left side
            if i < refImg
                homography = imgHomography{i};
            %% right side
            else
                homography = imgHomography{i-1};
            end

            outbounds = findbounds(homography, [1 1; width height]);

            if outbounds(1,1) < minX
                minX = outbounds(1,1);
            end
            if outbounds(2,1) > maxX
                maxX = outbounds(2,1);
            end
            if outbounds(1,2) < minY
                minY = outbounds(1,2);
            end
            if outbounds(2,2) > maxY
                maxY = outbounds(2,2);
            end   
        end
    end
    
    %% transform images by their homography 
    %% we will add the transformed images to the output panorama
    %% for the final result
    for i = 1 : imgCount
        img = colorImgs{i};
        featheredImg = featherImg(img);
        if i == refImg
            colorImgs{i} = imtransform(img, maketform('projective', eye(3)), 'XData', [minX maxX], 'YData', [minY maxY], 'XYScale', [1 1]);
            featherImgs{i} = imtransform(featheredImg, maketform('projective', eye(3)), 'XData', [minX maxX], 'YData', [minY maxY], 'XYScale', [1 1]);
            continue;
        end
        %% left side
        if i < refImg 
            homography = imgHomography{i};
        %% right side
        else
            homography = imgHomography{i-1};
        end
        %% perfrom the transform
        colorImgs{i} = imtransform(img, homography, 'XData', [minX maxX], 'YData', [minY maxY], 'XYScale', [1 1]);
        featherImgs{i} = imtransform(featheredImg, homography, 'XData', [minX maxX], 'YData', [minY maxY], 'XYScale', [1 1]);
    end
    
    %% output panorama
    [height, width,~] = size(colorImgs{1});
    panoramaOut = double(zeros(height, width, 3));
    blended = zeros(height, width);
    %% add images to output panorama
    for i = 1 : imgCount
        panoramaOut(:,:,1) = panoramaOut(:,:,1) + double(colorImgs{i}(:,:,1)).*double(featherImgs{i});
        panoramaOut(:,:,2) = panoramaOut(:,:,2) + double(colorImgs{i}(:,:,2)).*double(featherImgs{i});
        panoramaOut(:,:,3) = panoramaOut(:,:,3) + double(colorImgs{i}(:,:,3)).*double(featherImgs{i});
        blended = blended + featherImgs{i};
         %% blend @ last image 
        if i == imgCount
            panoramaOut(:,:,1) = panoramaOut(:,:,1)./blended;
            panoramaOut(:,:,2) = panoramaOut(:,:,2)./blended;
            panoramaOut(:,:,3) = panoramaOut(:,:,3)./blended;
        end
    end
   
   
end



