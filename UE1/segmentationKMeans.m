% kmeans
% input
%  - I: RGB image (3 channel)
%  - numClusters: number of clusters kmeans should use
%  - useXY: uses the spatial information too
%  - thres: tells function when to stop the iteration [0, 1]
% output:
%  - Iout: output image
function Iout = segmentationKMeans(I,numClusters, useXY, thres)

    % threshold must be in range [0, 1]
    assert(thres>=0 && thres<=1);
    
    % dimension of data can be 3 (rgb) or 5 (rgbxy)
    dim=3;
    if useXY
        dim=5;
    end
    
    % the original size of the image, to restore data vector later on
    originalSize=size(I);
        
    % init old distortion measure for first time usage
    distortionMeasureOld=Inf;

    % just to be sure that each color channel has the limits [0, 1]
    I=im2double(I);
    
    % put image into 1d data vector
    if useXY
        data=imgToRGBXYVector(I);    
    else
        data=imgToRGBVector(I);    
    end
    lenData=size(data,1);
              
    % indicator matrix: 0 or 1. [dataPoint centroid]
    indicatorMatrix=zeros([lenData numClusters]);
    
    
    % algorithm as in PDF:
    % 1. initialize center values
    centroids=rand([numClusters dim]);
    
    % loop until convergence
    while(1)    
        % 2. assign data points to nearest cluster centroids
        % calc dist between data and centroids
        diffMat=zeros([lenData numClusters]);
        for i=1:numClusters
            v=data-repmat(centroids(i,:),[lenData 1]);
            diffMat(:,i)=dot(v,v,2);
        end

        % fill indicator matrix with data<->cluster relationship
        [~,clusterIdx]=min(diffMat,[],2);    
        for i=1:numClusters
            indicatorMatrix(:,i)=(clusterIdx==i);
        end

        % 3. new cluster centroids
        for i=1:numClusters
            % number of datapoints assigned to cluster i
            sumOfData=sum(repmat(indicatorMatrix(:,i),[1 dim]).*data);
            numAssignedData=sum(indicatorMatrix(:,i));        

            % new cluster centroid
            centroids(i,:)=sumOfData/numAssignedData;
        end

        % 4. calc distortion measure, check for convergence
        distortionMeasure=0;
        for i=1:numClusters
            v=data-repmat(centroids(i,:),[lenData 1]);
            distortionMeasure=sum(indicatorMatrix(:,i).*dot(v,v,2));        
        end

        % ratio of old and new distortion measure
        ratio=distortionMeasure/distortionMeasureOld;
        if ratio>thres
            break;
        end

        distortionMeasureOld=distortionMeasure;

    end        
    
    % assign centroid value to each data point
    for i=1:numClusters
        idx=find(indicatorMatrix(:,i)==1);
        data(idx,:)=repmat(centroids(i,:),[length(idx) 1]);
    end
    
    % throw xy data away to just put rgb data into final image
    if useXY
        data=data(:,1:3);
    end
    
    % reshape data vector to original image size
    Iout=reshape(data,originalSize);
    
end


% convert image to vector of rgb data points
function rgbVector=imgToRGBVector(I)    
    rgbVector=reshape(I,[],3);
end


% convert image to vector of rgbxy data points
function rgbxyVector=imgToRGBXYVector(I)
    % calc rgb data vector 
    rgbVector=imgToRGBVector(I);
    
    % create xy grid, normalize xy
    [x,y]=meshgrid(1:size(I,1),1:size(I,2));
    x=x'/size(I,1);
    y=y'/size(I,2);
    
    % reshape to 1d vectors
    x1d=reshape(x,[],1);
    y1d=reshape(y,[],1);
    
    % glue all data together
    rgbxyVector=cat(2,rgbVector,x1d,y1d);
end