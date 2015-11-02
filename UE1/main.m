% Main.m - main entry for the first exercise. %
function main()
    close all;

	% Part 1 Colorizing Images %    
    disp('Part1 - begin');
	Part1();
    drawnow;


	% Part 2 Image Segmentation by K-means Clustering %
    disp('Part2 - begin');
	Part2();
    drawnow;


	% Part 3 Scale-Invariant Blob Detection %
    disp('Part3 - begin');
	Part3();
    drawnow;

end




% Part 1 Colorizing Images %
function Part1()	
	% Image set 00125v %
	red = imread('00125v_R.jpg');
	green = imread('00125v_G.jpg');
	blue = imread('00125v_B.jpg');
	colored = colorize(blue, green, red);
	% Plot %
	figure('Name','00125v');
	subplot(2,2,1); imshow(red); title('Red channel')
	subplot(2,2,2); imshow(green); title('Green channel');
	subplot(2,2,3); imshow(blue); title('Blue channel');
	subplot(2,2,4); imshow(colored); title('Reconstructed');

	% Image set 00149v %
	red = imread('00149v_R.jpg');
	green = imread('00149v_G.jpg');
	blue = imread('00149v_B.jpg');
	colored = colorize(blue, green, red);
	% Plot %
	figure('Name','00149v');
	subplot(2,2,1); imshow(red); title('Red channel')
	subplot(2,2,2); imshow(green); title('Green channel');
	subplot(2,2,3); imshow(blue); title('Blue channel');
	subplot(2,2,4); imshow(colored); title('Reconstructed');

	% Image set 00153v %
	red = imread('00153v_R.jpg');
	green = imread('00153v_G.jpg');
	blue = imread('00153v_B.jpg');
	colored = colorize(blue, green, red);
	% Plot %
	figure('Name','00153v');
	subplot(2,2,1); imshow(red); title('Red channel')
	subplot(2,2,2); imshow(green); title('Green channel');
	subplot(2,2,3); imshow(blue); title('Blue channel');
	subplot(2,2,4); imshow(colored); title('Reconstructed');

	% Image set 00351v %
	red = imread('00351v_R.jpg');
	green = imread('00351v_G.jpg');
	blue = imread('00351v_B.jpg');
	colored = colorize(blue, green, red);
	% Plot %
	figure('Name','00351v');
	subplot(2,2,1); imshow(red); title('Red channel')
	subplot(2,2,2); imshow(green); title('Green channel');
	subplot(2,2,3); imshow(blue); title('Blue channel');
	subplot(2,2,4); imshow(colored); title('Reconstructed');

	% Image set 00398v %
	red = imread('00398v_R.jpg');
	green = imread('00398v_G.jpg');
	blue = imread('00398v_B.jpg');
	colored = colorize(blue, green, red);
	% Plot %
	figure('Name','00398v');
	subplot(2,2,1); imshow(red); title('Red channel')
	subplot(2,2,2); imshow(green); title('Green channel');
	subplot(2,2,3); imshow(blue); title('Blue channel');
	subplot(2,2,4); imshow(colored); title('Reconstructed');

	% Image  set 01112v %
	red = imread('01112v_R.jpg');
	green = imread('01112v_G.jpg');
	blue = imread('01112v_B.jpg');
	colored = colorize(blue, green, red);
	% Plot %
	figure('Name','01112v');
	subplot(2,2,1); imshow(red); title('Red channel')
	subplot(2,2,2); imshow(green); title('Green channel');
	subplot(2,2,3); imshow(blue); title('Blue channel');
	subplot(2,2,4); imshow(colored); title('Reconstructed');
end


% Part 2 k-Means %
function Part2()
	
    % test images for this task
    I={imread('simple.png'), imread('future.jpg'), imread('mm.jpg')};
    
    % part a: show images with 3d and 5d data vectors
    disp('All images, fixed k=5, 3d and 5d ');
    k=5;    
    thres=0.9;
    maxIter=1000;
    for i=1:length(I)
        disp('kmeans for next image ...');
        disp('images where kmeans does not converge take a while (stopped after 1000 iterations) ...');
        
        useXY=false;
        Iout3d=segmentationKMeans(I{i}, k, useXY, thres, maxIter);
        
        useXY=true;
        Iout5d=segmentationKMeans(I{i}, k, useXY, thres, maxIter);
        
        figure;
        imshow(Iout3d);
        title('k=5, RGB');
        
        figure;
        imshow(Iout5d);
        title('k=5, RGB and XY');  
        
        drawnow;
    end
    
    
    % part b: show different values for k on I{3} (mm.jpg)
    for k=[3 5 11 43]
        disp('kmeans for next k value ...');
        
        useXY=false;
        Iout3d=segmentationKMeans(I{3}, k, useXY, thres, maxIter);
        
        useXY=true;
        Iout5d=segmentationKMeans(I{3}, k, useXY, thres, maxIter);
        
        figure;
        imshow(Iout3d);
        title(strcat('k=',num2str(k),', RGB'));
        
        figure;
        imshow(Iout5d);
        title(strcat('k=',num2str(k),', RGB and XY'));
        
        drawnow;
    end
    
end


% Part 3 scale invariant blob detection %
function Part3()
    alpha0 = 2.0;
    k = 1.25;
    img = imread('butterfly.jpg');
    

    %Part a:
    scale_space = createScaleSpace(alpha0, k, 10, img);
    
    % Part b:
    [yVec,xVec, scaleVec] = findMaximaInScaleSpace(scale_space, alpha0, k);
    
    show_all_circles(img, xVec, yVec, scaleVec);
    
end
