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
h = 10; % how much vertical offset.  n periods for n multiple of base band period
scale = 1000; %arbitrary scale parameter for radius, idk how it translates.
a = 1/scale;
for xi = 1:xSize
    for yi = 1:ySize
        x0 = xi - xSize/2; %x wrt the center of image
        y0 = yi - ySize/2; %y wrt the center of image
        if(x0^2 + y0^2 <= h/a) %if it's in the circle
            yp =  round(y0 + a*(x0^2 + y0^2) - h + ySize/2); %new y offset
            if(yp > 0) %keep it in bounds
                offsetBands(yp, xi) = baseBand(yi, xi);
            end
        else % not in circle, copy the original.
            offsetBands(yi, xi) = baseBand(yi, xi);
        end     
    end
end

%% make an animation
figure;
for frame = 1:baseBandPeriod
    maskShifted = imtranslate(revealMask,[0, frame]);
    imshow(and(maskShifted, offsetBands));
    animation(frame) = getframe(gcf);
end
% play the movie
movie(animation,5)

%% lets play with some letters, or at least some binary height/depth images
clc
close all
clear all

bwImage = im2double(imread('star.png'));
bwImage = im2bw(bwImage);
figure
imPerim = bwmorph(bwImage,'remove');
imshow(imPerim)
figure
imSkelFG = bwmorph(bwImage,'skel',Inf);
imshow(imSkelFG)
figure
imSkelBG = bwmorph(~bwImage,'skel',Inf);
imshow(imSkelBG)

