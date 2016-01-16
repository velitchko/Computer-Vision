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
        image = imread(varargin{i});
        colorImgs{i} = im2double(image);
        grayImgs{i} = im2single(rgb2gray(image));
    end
    %% compute image homographies
    for i = 1 : imgCount
        if i+1 <= imgCount
            %% from the left side
            if(i < refImg)
                %% sift features for first n second img
                imgHomography{i} = getHomography(grayImgs{i}, grayImgs{i+1});
            %% from the right side
            else
                imgHomography{i} = fliptform(getHomography(grayImgs{i}, grayImgs{i+1}));
            end
        end
    end
    
    if refImg > 2
        for i = refImg-2 : 1
            imgHomography{i} = maketform('composite', imgHomography{i}, imgHomography{i+1});
            imgHomography{refImg + i} = maketform('composite', imgHomography{refImg + i - 1}, imgHomography{refImg + i});
        end
    end
    
    %% we need the size of an image
    [height,width, ~] = size(colorImgs{refImg});
    minX = 1;
    minY = 1;
    maxX = width;
    maxY = height;
    for i = 1 : imgCount
        if(i == refImg)
            continue;
        end
        [height,width,~] = size(colorImgs{i});
        
        if i > refImg
            homography = imgHomography{i-1};
        else
            homography = imgHomography{i};
        end
        
        bounds = findbounds(homography, [1 1; width height]);
        
        if bounds(1,1) < minX
            minX = bounds(1,1);
        end
        if bounds(2,1) > maxX
            maxX = bounds(2,1);
        end
        if bounds(1,2) < minY
            minY = bounds(1,2);
        end
        if bounds(2,2) > maxY
            maxY = bounds(2,2);
        end   
    end
    for i = 1 : imgCount
        img = colorImgs{i};
        featheredImg = featherImg(img);
        if i == refImg
            colorImgs{i} = imtransform(image, maketform('projective', eye(3)), 'XData', [minX maxX], 'YData', [minY maxY], 'XYScale', [1 1]);
            featherImgs{i} = imtransform(featheredImg, maketform('projective', eye(3)), 'XData', [minX maxX], 'YData', [minY maxY], 'XYScale', [1 1]);
            continue;
        end
        
        if i > refImg 
            homography = imgHomography{i-1};
        else
            homography = imgHomography{i};
        end
        
        colorImgs{i} = imtransform(image, homography, 'XData', [minX maxX], 'YData', [minY maxY], 'XYScale', [1 1]);
        featherImgs{i} = imtransform(featheredImg, homography, 'XData', [minX maxX], 'YData', [minY maxY], 'XYScale', [1 1]);
    end
    
    [height, width, ~] = size(colorImgs{1});
    panoramaOut = double(zeros(height, width, 3));
    blended = zeros(height, width);
    %% add images to output panorama
    for i = 1 : imgCount
        panoramaOut(:,:,1) = panoramaOut(:,:,1) + double(colorImgs{i}(:,:,1)).*double(featherImgs{i});
        panoramaOut(:,:,2) = panoramaOut(:,:,2) + double(colorImgs{i}(:,:,2)).*double(featherImgs{i});
        panoramaOut(:,:,3) = panoramaOut(:,:,3) + double(colorImgs{i}(:,:,3)).*double(featherImgs{i});
        blended = blended + featherImgs{i};
    end
    
    panoramaOut(:,:,1) = panoramaOut(:,:,1)./blended;
    panoramaOut(:,:,2) = panoramaOut(:,:,2)./blended;
    panoramaOut(:,:,3) = panoramaOut(:,:,3)./blended;
end



