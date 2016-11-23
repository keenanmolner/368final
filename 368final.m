% EE368
% Final Project
clc
close all
clear all

%% let's figure out how the hell to create a periodic grating
xSize = 500; %501px
ySize = 500; %501px
baseBandPeriod = 10; %px, please make this an even number.
baseBandAngle = 0;% degrees theta from horizontal
revealMask = makeLinearRevealMask(xSize, ySize, baseBandPeriod, baseBandAngle);
imshow(revealMask, []);

%% make a linear base band to then offset with a height function
baseBand = makeLinearRevealMask(xSize, ySize, baseBandPeriod, baseBandAngle);
offsetBands = zeros(size(baseBand));
h = 10;
scale = 1000;
a = 1/scale;
for xi = 1:xSize
    for yi = 1:ySize
        x0 = xi - xSize/2;
        y0 = yi - ySize/2;
        if(x0^2 + y0^2 <= h/a)
            yp =  round(y0 + a*(x0^2 + y0^2) - h + ySize/2);
            if(yp > 0)
                offsetBands(yp, xi) = baseBand(yi, xi);
            end
        else
            offsetBands(yi, xi) = baseBand(yi, xi);
        end
        
    end
end

%imshow(and(offsetBands, revealMask))

%% make an animation
figure;
for frame = 1:2*baseBandPeriod
    maskShifted = imtranslate(revealMask,[0, frame]);
    imshow(and(maskShifted, offsetBands));
    animation(frame) = getframe(gcf);
end
%%
% play the movie

figure
movie(animation,5)
