% EE368
% Final Project
clc
close all
clear all

%% let's just figure out how the hell to create a periodic grating
% maybe even make the grating at an angle?
xSize = 500; %501px
ySize = 500; %501px
baseBandPeriod = 10; %px, please make this an even number.
baseBandAngle = 15;% degrees theta from horizontal
revealMask = makeLinearRevealMask(xSize, ySize, baseBandPeriod, baseBandAngle);
imshow(revealMask, []);

