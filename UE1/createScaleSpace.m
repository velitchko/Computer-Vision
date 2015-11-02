% createScaleSpace
% input
%  - alpha0: starting alpha value.
%  - k: increase alpha by k in every step.
%  - levels: Number of different levels.
%  - I: BW image (2 channel)
% output:
%  - Iout: output image accross the different levels

function Iout=createScaleSpace(alpha0, k, levels, I) 
    dim = size(I);
    Iout = zeros(dim(1), dim(2), levels);
    currentAlpha = alpha0;
    
    for level = 1:levels
        filter = fspecial('log', floor(6 * currentAlpha + 1), currentAlpha);
        filter = filter * (currentAlpha^2);
        Iout(:,:,level) = abs(imfilter(I,filter, 'same', 'replicate'));
        
        currentAlpha = currentAlpha * k;
    end
end
    