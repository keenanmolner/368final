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

bwImage = im2double(imread('suits.png'));
bwImage = im2bw(bwImage);

% create distance map of skeleton 
bgDist = bwdist(bwImage);
fgDist = bwdist(~bwImage);
fgMax = max(fgDist(:));
bgMax = max(bgDist(:));
elev = zeros(size(fgDist));
for xi = 1:size(fgDist, 2)
    for yi = 1:size(fgDist, 1)
        if(bwImage(yi,xi) > 0)
            newFGval = (fgDist(yi, xi) / fgMax)/2 + 0.5;
            elev(yi,xi) = newFGval;
        else 
            newBGval = (bgDist(yi, xi) / bgMax)/2;
            elev(yi,xi) = newBGval;
        end
    end
end
imshow(elev)

%% create offset band image (starBand) to translate by starDepth intensity
[h,w] = size(elev);
bandSpacing = 4;
bandAngle = 30;
revealMask = makeLinearRevealMask(w, h, bandSpacing, bandAngle);
elevBandOrig = makeColorMask(w,h,bandSpacing,bandAngle);
elevBandShifted = elevBandOrig;
max_translate = bandSpacing;

% multiply each pixel of starBand up by the relative brightness level on
% elev
for xS = 1:w
    for yS = 1:h
        % find intensity of starDepth image
        pixel_intensity = elev(yS,xS);
        % calculate new y position
        pixel_translate = floor(pixel_intensity*max_translate);
        pixel_ynew = yS + pixel_translate;
        if (pixel_ynew < h)
            elevBandShifted(pixel_ynew, xS, :) = elevBandOrig(yS,xS, :);
        end
    end
end

subplot(1, 2, 1)
imshow(elevBandShifted, []);
subplot(1, 2, 2)
imshow(revealMask, []);

%% animation test 2

figure();
clear animation
for frame = 1:bandSpacing
    maskShifted = imtranslate(revealMask,[0, frame]);
    maskCombine = maskShifted.*elevBandShifted;
    imshow(maskCombine);
    animation(frame) = getframe(gcf);
end

movie(animation,10)

%% lets try it all with a grayscale image?

clc
close all
clear all

bwImage = im2double(imread('depth1.jpg'));
bwImage = rgb2gray(bwImage);
elev = bwImage;

[h,w] = size(bwImage);
bandSpacing = 4;
bandAngle = 0;
revealMask = makeLinearRevealMask(w, h, bandSpacing, bandAngle);
elevBandOrig = makeLinearRevealMask(w,h,bandSpacing,bandAngle);
%elevBandOrig = makeColorMask(w,h,bandSpacing,bandAngle);
elevBandShifted = elevBandOrig;
max_translate = bandSpacing;

% multiply each pixel of starBand up by the relative brightness level on
% elev
for xS = 1:w
    for yS = 1:h
        % find intensity of starDepth image
        pixel_intensity = elev(yS,xS);
        % calculate new y position
        pixel_translate = floor(pixel_intensity*max_translate);
        pixel_ynew = yS + pixel_translate;
        if (pixel_ynew < h)
            elevBandShifted(pixel_ynew, xS, :) = elevBandOrig(yS,xS, :);
        end
    end
end

subplot(1, 2, 1)
imshow(elevBandShifted, []);
subplot(1, 2, 2)
imshow(revealMask, []);

%% animation test 3

figure();
clear animation
for frame = 1:bandSpacing
    maskShifted = imtranslate(revealMask,[0, frame]);
    maskCombine = maskShifted.*elevBandShifted;
    imshow(maskCombine);
    animation(frame) = getframe(gcf);
end
for frame = 1:bandSpacing
    maskShifted = imtranslate(revealMask,[0, frame]);
    maskCombine = maskShifted.*elevBandShifted;
    imshow(maskCombine);
    animation(frame) = getframe(gcf);
end

movie(animation,10)

%%
