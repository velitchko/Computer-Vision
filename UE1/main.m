% Main.m - main entry for the first exercise. %
function main()
    close all;

	% Part 1 Colorizing Images %
    disp('Part1 - begin');
	Part1();


	% Part 2 Image Segmentation by K-means Clustering %
    disp('Part2 - begin');
	Part2();


	% Part 3 Scale-Invariant Blob Detection %
    disp('Part3 - begin');
	Part3();

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
	warning('Part2 not yet implemented!!!');
end


% Part 3 scale invariant blob detection %
function Part3()
	warning('Part3 not yet implemented!!!');
end
