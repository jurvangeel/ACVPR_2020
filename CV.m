clc
clear all;
close all;

Original = importdata('Bladmuziek/avond.jpg');
%IMG = importdata('Bladmuziek/im1s.jpg');

IMG = imresize(Original, 1);

IMG = rgb2gray(IMG);
IMG = im2double(IMG);

[BarsTemp, BarLocTemp, staff_space] = BarDetection(IMG); 
workingIMG = rescale_staff_space(staff_space, IMG); 
[Bars, BarLoc, staff_space2] = BarDetection(workingIMG); %verify the new  staff space  

workingIMG =  BarReduct(workingIMG, BarLoc); 


[Notes, NoteLoc] = NoteDetection(workingIMG, BarLoc); %morphology operations should be based on staffheight/space
NoteData = PitchDetection(NoteLoc,BarLoc); %NoteData contains NoteLocs + pitches & Keys

%plotScore(IMG, Bars,Notes,BarLoc);
figure();
NoteFragments = NoteSegmemtation(workingIMG, NoteLoc, BarLoc);
