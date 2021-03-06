% findMaximaInScaleSpace
% input
%  - alpha0: starting alpha value.
%  - k: Increase of alpha value per level
%  - scale_space: Images across various scales 
% output:
%  - Iout: output image accross the different levels

function [xVec, yVec, scaleVec]=findMaximaInScaleSpace(scale_space, alpha0, k, levels, threshold)
    if nargin < 4
        threshold = 25
    end

    dim = size(scale_space);
    
    xVec = [];
    yVec = [];
    scaleVec = [];
    levelsAlpha = (alpha0 * (k ^ levels)) * (2 ^ 0.5);
    
    % Grenzfall : 1st and last scale space. I am stil not sure if we
    % actually need this.
    for x = 2: (dim(1) - 1)
        for y = 2: (dim(2) - 1)  
           if scale_space(x,y,1) < threshold
               continue;
           end
           if sum(sum(sum(scale_space(x-1 : x+1,y-1 : y+1,1 : 2) >= scale_space(x,y,1)))) <= 1
                    xVec = [xVec; x];
                    yVec = [yVec; y];
                    scaleVec = [scaleVec; alpha0 * (2 ^ 0.5)];
            end
            if sum(sum(sum(scale_space(x-1 : x+1,y-1 : y+1,levels-1 : levels) >= scale_space(x,y,levels)))) <= 1
                    xVec = [xVec; x];
                    yVec = [yVec; y];
                    scaleVec = [scaleVec; levelsAlpha ];
            end
        end
    end
            
    
    for level = 2: (dim(3) - 1)
        curScale = (alpha0 * (k ^ level)) * (2 ^ 0.5);
        for x = 2: (dim(1) - 1)
            for y = 2: (dim(2) - 1)
                if scale_space(x,y,level) < threshold
                    continue;
                end
                if sum(sum(sum(scale_space(x-1 : x+1,y-1 : y+1,level-1 : level + 1) >= scale_space(x,y,level)))) <= 1
                    xVec = [xVec; x];
                    yVec = [yVec; y];
                    scaleVec = [scaleVec; curScale];
                end
            end
        end
    end
end
    