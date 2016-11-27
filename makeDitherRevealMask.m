function ditherMask = makeDitherRevealMask( xSize, ySize, baseBandPeriod, baseBandAngle )
% makeDitherMask builds a periodic line grating used to dither with.
%   Takes in an xdim and ydim for output mask
%   Baseband period should be an even number
%   Baseband angle is the rotation in degrees with respect to horizontal

    if(mod(baseBandPeriod, 2))
        error('BaseBandPeriod must be an even number');
    end

ditherMask = zeros(ySize, xSize);
ditherMask = imrotate(ditherMask, baseBandAngle, 'nearest');
intensityStep = 1/(baseBandPeriod/2);

for xi = 1:size(ditherMask,2)
    for yi = 1:size(ditherMask,1)
        if(mod(yi,baseBandPeriod) < round(baseBandPeriod/2))
            ditherMask(yi,xi) = (mod(yi,baseBandPeriod)+1)*intensityStep; %increaseing intensity
        else
            ditherMask(yi,xi) = (baseBandPeriod - mod(yi,baseBandPeriod))*intensityStep; %decreassing intensity
        end
    end
end

ditherMask = imrotate(ditherMask, baseBandAngle, 'nearest');
xMid = floor(size(ditherMask,2)/2);
yMid = floor(size(ditherMask,1)/2);
xQuarter = xSize/2;
yQuarter = ySize/2;

ditherMask = ditherMask(yMid - yQuarter+1 : yMid + yQuarter, xMid - xQuarter +1: xMid + xQuarter);

end

