% findMaximaInScaleSpace
% input
%  - alpha0: starting alpha value.
%  - k: Increase of alpha value per level
%  - scale_space: Images across various scales 
% output:
%  - Iout: output image accross the different levels

function [yVec, xVec, scaleVec]=findMaximaInScaleSpace(scale_space, alpha0, k) 
    dim = size(scale_space);
    
    xVec = [];
    yVec = [];
    scaleVec = [];
    
    for level = 2: (dim(3) - 1)
        for x = 2: (dim(1) - 1)
            for y = 2: (dim(2) - 1)
                scale = (alpha0 * (k ^ level)) * (2 ^ 0.5);
                if sum(sum(sum(scale_space(x-1 : x+1,y-1 : y+1,level-1 : level + 1) >= scale_space(x,y,level)))) <= 1
                    xVec = [xVec; x];
                    yVec = [yVec; y];
                    scaleVec = [scaleVec; scale];
                end
            end
        end
    end
end
    