% kmeans
% input
%  - I: RGB image (3 channel)
%  - numClusters: number of clusters kmeans should use
%  - useXY: uses the spatial information too
%  - thres: tells function when to stop the iteration [0, 1]
% output:
%  - Iout: output image
function Iout = segmentationKMeans(I,numClusters, useXY, thres)

    assert(thres>=0 && thres<=1);
    
    % dimension of data
    dim=3;
    if useXY
        dim=5;
    end
    
    
    originalSize=size(I);
        

    % init old distortion measure for first time usage
    distortionMeasureOld=Inf;

    % just to be sure that each color channel has the limits [0, 1]
    I=im2double(I);
    
    % put image into 1d data vector
    data=imgToRGBVector(I);
    lenData=size(data,1);
              
    % indicator matrix: 0 or 1. [dataPoint centroid]
    indicatorMatrix=zeros([lenData numClusters]);
    
    
    % algorithm as in PDF:
    % 1. initialize center values
    centroids=rand([numClusters dim]);
    
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
            sumOfData=sum(repmat(indicatorMatrix(:,i),[1 3]).*data);
            numAssignedData=sum(indicatorMatrix(:,i));        

            % new cluster centroid
            centroids(i,:)=sumOfData/numAssignedData;
        end

        % calc distortion measure, check for convergence
        distortionMeasure=0;
        for i=1:numClusters
            v=data-repmat(centroids(i,:),[lenData 1]);
            distortionMeasure=sum(indicatorMatrix(:,i).*dot(v,v,2));        
        end

        ratio=distortionMeasure/distortionMeasureOld;
        if ratio>thres
            break;
        end

        distortionMeasureOld=distortionMeasure;

    end
    
    
    
    % assign centroid value to each pixel
    for i=1:numClusters
        idx=find(indicatorMatrix(:,i)==1);
        data(idx,:)=repmat(centroids(i,:),[length(idx) 1]);
    end
    Iout=reshape(data,originalSize);
    
end

% convert 
function v=imgToRGBVector(I)    
    v=reshape(I,[],3);
end

% TODO
% function v=imgToRGBXYVector
%     v=[];
% end