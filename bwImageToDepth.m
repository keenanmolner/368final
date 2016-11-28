function depthImage = bwImageToDepth(bwImage)
bgDist = bwdist(bwImage);
fgDist = bwdist(~bwImage);
fgMax = max(fgDist(:));
bgMax = max(bgDist(:));
depthImage = zeros(size(fgDist));
for xi = 1:size(fgDist, 2)
    for yi = 1:size(fgDist, 1)
        if(bwImage(yi,xi) > 0)
            newFGval = (fgDist(yi, xi) / fgMax)/2 + 0.5;
            depthImage(yi,xi) = newFGval;
        else 
            newBGval = (bgDist(yi, xi) / bgMax)/2;
            depthImage(yi,xi) = newBGval;
        end
    end
end

end