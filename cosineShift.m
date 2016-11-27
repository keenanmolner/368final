function shiftedImage = cosineShift( origImage, period, amplitude)
[h w c] = size(origImage);
shiftedImage = zeros([h w c]);
xRange = 1:w;
yOffset = amplitude.*sin(2*pi*xRange/period);
for xi = 1:w
    for yi = 1:h
        ynew = floor(yi + yOffset(xi));
        if(and(ynew < h, ynew > 0))
            shiftedImage(ynew, xi, :) = origImage(yi, xi, :);         
        end
    end
end

end