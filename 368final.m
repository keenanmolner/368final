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

bw = im2bw(im2double(imread('suits.png')));
elevShifted = bwImageToDepth(bw);
imshow(elevShifted)
%% create offset band image (starBand) to translate by starDepth intensity
[h,w] = size(elevShifted);
bandSpacing = 6;
bandAngle = 0;
%revealMask = makeLinearRevealMask(w, h, bandSpacing, bandAngle);
revealMask = makeColorMask(w, h, bandSpacing, bandAngle);
elevBandShifted = embedDepthInBands(revealMask, elevShifted, bandSpacing);

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

elev = im2double(imread('depth1.jpg'));
elev = rgb2gray(elev);
elev = elev;

[h,w] = size(elev);
bandSpacing = 12;
bandAngle = 0;
amp = 20;
period = w/4;
revealMask = cosineShift(makeLinearRevealMask(w,h,bandSpacing,bandAngle), period, amp);
%elevBandOrig = makeColorMask(w,h,bandSpacing,bandAngle);

elevBandShifted = embedDepthInBands(revealMask, elev, bandSpacing);

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

%% how bout we play with dithering?
clc
close all
clear all

elev = im2double(imread('depth3.jpg'));
elev = rgb2gray(elev);
[h w] = size(elev);
bandSpacing = 20;
bandAngle = 0;
ditherMask = makeDitherRevealMask(w, h, bandSpacing, bandAngle);

%% fuck dithering! Let's play with a webcam instead.
clc
close all
clear all

cam = webcam;

h = 720; % built in mac camera height
w = 1280;% built in mac camera width
bandSpacing = 12;
bandAngle = 0;
amp = 20;
period = w/4;
%revealMask = cosineShift(makeLinearRevealMask(w, h, bandSpacing, bandAngle), period, amp);
revealMask = cosineShift(makeColorMask(w, h, bandSpacing, bandAngle), period, amp);

elev = rgb2gray(im2double(snapshot(cam)));
elevBandShifted = embedDepthInBands(revealMask, elev, bandSpacing);

figure;
subplot(1, 2, 1)
imshow(elevBandShifted, []);
subplot(1, 2, 2)
imshow(revealMask, []);
clear cam

figure();
clear animation
for frame = 1:bandSpacing
    maskShifted = imtranslate(revealMask,[0, frame]);
    maskCombine = maskShifted.*elevBandShifted;
    imshow(maskCombine);
    animation(frame) = getframe(gcf);
end
movie(animation,10)
%% can we hide multiple images in the same bands?

clc
close all
clear all

elev1 = rgb2gray(im2double(imread('depth1.jpg'))); %720 x 540
elev2 = rgb2gray(im2double(imread('depth3.jpg'))); %500 x 375
elev1 = elev1(1:375, 1:500);
elev2 = elev2(1:375, 1:500);
[h,w] = size(elev1);

%image 1 embed
bandSpacing = 4;
bandAngle = 0;
amp = 10;
period = w/4;
revealMask1 = cosineShift(makeLinearRevealMask(w, h, bandSpacing, bandAngle), period, amp);
elevBandShifted1 = embedDepthInBands(revealMask1, elev1, bandSpacing);

%image 2 embed
bandSpacing = 6;
bandAngle = 30;
amp = 20;
period = w;
revealMask2 = cosineShift(makeLinearRevealMask(w, h, bandSpacing, bandAngle), period, amp);
elevBandShifted2 = embedDepthInBands(revealMask2, elev2, bandSpacing);

elevCombined = or(elevBandShifted1, elevBandShifted2);

subplot(1, 3, 1)
imshow(elevCombined, []);
title('combined elevations');
subplot(1, 3, 2)
imshow(revealMask1, []);
title('reveal mask 1');
subplot(1, 3, 3)
imshow(revealMask2, []);
title('reveal mask 2');
%%
figure();
clear animation
for frame = 1:bandSpacing
    maskShifted = imtranslate(revealMask1,[0, frame]);
    maskCombine = maskShifted.*elevCombined;
    imshow(maskCombine);
    animation(frame) = getframe(gcf);
end

for frame = 1:bandSpacing
    maskShifted = imtranslate(revealMask2,[0, frame]);
    maskCombine = maskShifted.*elevCombined;
    imshow(maskCombine);
    animation(frame+bandSpacing) = getframe(gcf);
end

movie(animation,10)
