clc
clear all;
close all;

IMG1 = importdata('Bladmuziek/colors.jpg');
%IMG = importdata('Bladmuziek/im1s.jpg');

IMG = imresize(IMG1, 1.2);

IMG = rgb2gray(IMG);
IMG = im2double(IMG);

[Bars, BarLoc, staff_space] = BarDetection(IMG); 
test = rescale_staff_space(staff_space, IMG); 
[Bars2, BarLoc2, staff_space2] = BarDetection(test); %verify the new  staff space  

IMG =  BarReduct(IMG, BarLoc); 


[Notes, NoteLoc] = NoteDetection(IMG, BarLoc); %morphology operations should be based on staffheight/space
NoteData = PitchDetection(NoteLoc,BarLoc); %NoteData contains NoteLocs + pitches & Keys

%plotScore(IMG, Bars,Notes,BarLoc);
figure();
NoteFragments = NoteSegmemtation(IMG, NoteLoc, BarLoc);
