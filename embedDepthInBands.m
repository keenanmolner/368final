function shiftedBands = embedDepthInBands(revealMask, depthImage, maxTranslate)
[h w c] = size(revealMask);
shiftedBands = revealMask;
for xS = 1:w
    for yS = 1:h
        % find intensity of starDepth image
        pixel_intensity = depthImage(yS,xS);
        % calculate new y position
        pixel_translate = floor(pixel_intensity*maxTranslate);
        pixel_ynew = yS + pixel_translate;
        if (pixel_ynew < h)
            shiftedBands(pixel_ynew, xS, :) = revealMask(yS,xS, :);
        end
    end
end

end