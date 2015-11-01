% kmeans
% input
%  - I: RGB image (3 channel)
%  - numClusters: number of clusters kmeans should use
%  - useXY: uses the spatial information too
%  - thres: tells function when to stop the iteration [0, 1]
%  - maxIter: max. number of iterations, afterwards algorithm stops
%  - useMatlabKMeans: use kmeans of Matlab instead (for testing only!!!)
% output:
%  - Iout: output image
function Iout = segmentationKMeans(I,numClusters, useXY, thres, maxIter, useMatlabKMeans)

    % prepare input parameters ...

    % threshold must be in range [0, 1]
    assert(thres>=0 && thres<=1);
    
    % default: use own kmeans implementation
    if nargin<6
        useMatlabKMeans=false;
    end  
    
    % the original size of the image, to restore data vector later on
    originalSize=size(I);           

    % just to be sure that each color channel has the limits [0, 1]
    I=im2double(I);              
    
    % put image into 1d data vector
    if useXY
        data=imgToRGBXYVector(I);    
    else
        data=imgToRGBVector(I);    
    end
    
    
    % call kmeans core function: can be our implementation 
    % or for testing the Matlab implementation
    if useMatlabKMeans

        [idx,C]=kmeans(data, numClusters); % Matlab implementation
        
        for i=1:length(data)
            data(i,:)=C(idx(i),:);
        end
        
        warning('you are using kmeans of Matlab, not our kmeans!!');
                
    else
        data=kMeansMainLoop(data, numClusters, thres, maxIter); % our implementation
    end
    
    
    % throw xy data away to just put rgb data into final image
    if useXY
        data=data(:,1:3);
    end
    
    % reshape data vector to original image size
    Iout=reshape(data,originalSize);
    
end


% main loop for clustering the data
function [clusteredData] = kMeansMainLoop(data, numClusters, thres, maxIter)
          
    % init old distortion measure for first time usage
    distortionMeasureOld=Inf;
    
    % data length
    lenData=size(data,1);
    dim=size(data,2);
    
    % indicator matrix: 0 or 1. [dataPoint centroid]
    indicatorMatrix=zeros([lenData numClusters]);

    % algorithm as in PDF:
    % 1. initialize center values
    centroids=rand([numClusters dim]);
    dbgClusterSize=zeros([numClusters 1]);
    % loop until convergence
    ctr=0;
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
            if numAssignedData>0                                         
                centroids(i,:)=sumOfData/numAssignedData;            
            end
            
            if showDebugInfo()
                dbgClusterSize(i,ctr+1)=numAssignedData;
            end
                
        end

        % 4. calc distortion measure, check for convergence
        distortionMeasure=0;
        for i=1:numClusters
            v=data-repmat(centroids(i,:),[lenData 1]);
            distortionMeasure=sum(indicatorMatrix(:,i).*dot(v,v,2));        
        end

        % ratio of old and new distortion measure
        ratio=1;
        if distortionMeasureOld ~= 0
            ratio=distortionMeasure/distortionMeasureOld;
        end
        
        % stop if result is good enough
        if ratio>thres
            break;
        end

        distortionMeasureOld=distortionMeasure;

        ctr=ctr+1;
        if(ctr>maxIter)
            if showDebugInfo()
                warning('no convergence! iteration now stops.');
            end
            break;
        end
    end        

    % assign centroid value to each data point
    for i=1:numClusters
        idx=find(indicatorMatrix(:,i)==1);
        data(idx,:)=repmat(centroids(i,:),[length(idx) 1]);
    end
    
    clusteredData=data;
    
    % show debug info
    if showDebugInfo()
        figure;
        hold on        
        for i=1:numClusters
            plot(dbgClusterSize(i,:),'LineWidth',2);
        end
        title('debug info: change of cluster size');
        hold off;
        
    end   
    
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


% show debug information
function res=showDebugInfo()
    res=false;
end