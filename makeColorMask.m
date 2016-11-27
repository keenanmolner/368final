function revealMask = makeColorMask( xSize, ySize, baseBandPeriod, baseBandAngle )
% makeRevealMask builds a periodic line grating
%   Takes in an xdim and ydim for output mask
%   Baseband period should be an even number
%   Baseband angle is the rotation in degrees with respect to horizontal

    if(mod(baseBandPeriod, 2))
        error('BaseBandPeriod must be an even number');
    end
    

colors = rand([baseBandPeriod 3]);
    

revealMask = zeros(ySize, xSize, 3);
revealMask = imrotate(revealMask, baseBandAngle, 'nearest');

for xi = 1:size(revealMask,2)
    for yi = 1:size(revealMask,1)
        colorIndex = mod(yi, baseBandPeriod) + 1;
        color = colors(colorIndex, :);
        revealMask(yi,xi,:) = color;
    end
end

revealMask = imrotate(revealMask, baseBandAngle, 'nearest');
xMid = floor(size(revealMask,2)/2);
yMid = floor(size(revealMask,1)/2);
xQuarter = xSize/2;
yQuarter = ySize/2;

revealMask = revealMask(yMid - yQuarter+1 : yMid + yQuarter, xMid - xQuarter +1: xMid + xQuarter, :);

end

