function revealMask = makeLinearRevealMask( xSize, ySize, baseBandPeriod, baseBandAngle )
% makeRevealMask builds a periodic line grating
%   Takes in an xdim and ydim for output mask
%   Baseband period should be an even number
%   Baseband angle is the rotation in degrees with respect to horizontal

    if(mod(baseBandPeriod, 2))
        error('BaseBandPeriod must be an even number');
    end

revealMask = zeros(xSize, ySize);
revealMask = imrotate(revealMask, baseBandAngle, 'nearest');

for xi = 1:size(revealMask,2)
    for yi = 1:size(revealMask,1)
        if(mod(yi,baseBandPeriod) >= round(baseBandPeriod/2))
            revealMask(yi,xi) = 1;
        else
            revealMask(yi,xi) = 0;
        end
    end
end

revealMask = imrotate(revealMask, baseBandAngle, 'nearest');
xMid = floor(size(revealMask,2)/2);
yMid = floor(size(revealMask,1)/2);
xQuarter = xSize/2;
yQuarter = ySize/2;

revealMask = revealMask(yMid - yQuarter+1 : yMid + yQuarter, xMid - xQuarter +1: xMid + xQuarter);

end

