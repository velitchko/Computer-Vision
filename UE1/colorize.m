% Colorize the 3 channel images %
function [colored] = colorize(b, g, r)

aligned_r = align(r, g);
aligned_b = align(b, g);
% Concatenate color channels %
colored = cat(3,aligned_r, g, aligned_b);
end


% Align using NCC %
% Matlab function corr2 computes the same thing as the NCC %
function[out] = align(img_1, img_2)
max = 0;
res = 0;
for x = -15:15
    for y = -15:15
        tmp = circshift(img_1, [x y]);
        ncc = corr2(img_2, tmp);
        if ncc > max 
            max = ncc;
            res = [x y];
        end
    end
end
out = circshift(img_1, res);
end


