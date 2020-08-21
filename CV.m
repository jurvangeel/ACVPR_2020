clc
clear all;
close all;

IMG = importdata('Bladmuziek/colors.jpg');

IMG = rgb2gray(IMG);
IMG = im2double(IMG);
[Bars, BarLoc] = BarDetection(IMG); 
IMG =  BarReduct(IMG, BarLoc); %should also retuRn staffspace height...?


[Notes, NoteLoc] = NoteDetection(IMG, BarLoc); %morphology operations should be based on staffheight/space
NoteData = PitchDetection(NoteLoc,BarLoc); %NoteData contains NoteLocs + pitches

%plotScore(IMG, Bars,Notes,BarLoc);
figure();
NoteFragments = NoteSegmemtation(IMG, NoteLoc, BarLoc);
