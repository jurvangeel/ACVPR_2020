function [Notes, NoteLoc] = NoteDetection(IM, Bars)
%Blad0 = rgb2gray(imcomplement(IM)); %Colors
Blad0 = imcomplement(IM); %Geitje
Notes = zeros(size(IM));

%morphology analitics;
 Blad1 = imclose(Blad0, strel('diamond', 10));  %specify, close open notes
 
 Vertical = imerode(Blad1, strel('line', 15, 90));   %search for vertical lines and delete
 Blad2 = (Blad1 - Vertical)>0.5;
 Blad2 = imclose(Blad2, strel('diamond', 10));       %close open notes
 
 Horizontal = imerode(Blad1, strel('line', 20, 0)); %search for horizontal lines and delete
 Horizontal = imdilate(Horizontal,strel('diamond', 7));
 Blad3= (Blad2 - Horizontal)>0.5;
 
 Blad4 = imclose(Blad3, strel('diamond', 10));  %close 
 Blad4 = imerode(Blad4, strel('diamond', 3));   %search for only circles
 
 
 regioMax = imregionalmax(Blad4);                   %retreive local maximums
 NoteLoc = regionprops(regioMax,'centroid');        %and find their centers
 
 imshow(IM); hold on;
 delete = [];
for x = 1: numel(NoteLoc) %for all notes
    staff_Length = frequency(Bars(:,2));
    if max(Bars(:,1))+ 3*staff_Length > NoteLoc(x).Centroid(2) && ...
                                    NoteLoc(x).Centroid(2 ) > min(Bars(:,1))- 3*staff_Length %check if the note is within the stafflines
        plot(NoteLoc(x).Centroid(1),NoteLoc(x).Centroid(2),'ro');
        Notes(round(NoteLoc(x).Centroid(2),0), round(NoteLoc(x).Centroid(1),0)) = 1;
    else
        delete = [delete, x]; %delete the ones not close to staff lines
    end
end  
    NoteLoc(delete) = [];
 NoteLoc = SortNote(NoteLoc);
 Notes = imcomplement(im2double(Notes)); 

 

end

% scan = im2bw(normalize(imcomplement(Blad1)),1);
% figure();
% imshow(scan)
% scan1 = scan;
% se_line = strel('square', 3);
% for I = 1:2
% scan1 = imdilate(scan1, se_line);
% end
% se_line = strel('square', 5);
% for I = 1:3
% scan1 = imerode(scan1, se_line);
% end
% for I = 1:3
% scan1 = imdilate(scan1, se_line);
% end
% figure();
% scan = scan-scan1
% imshow(scan);
% 

% 
% scan2 = scan
% 
% se_line = strel('line', 2, 90);
% scan2 = imdilate(scan2, se_line);
% 
% figure();
% imshow(scan2)
% 
% end

%  imshow(IMGanalysis)
%  
%  
%  Notes = [row,colomn];
%  a = unique(Notes(:,1));
%  freq = histc(Notes(:,1),a);
%  Model = fitgmdist(Notes,sum(Bars(:,3)));
%  figure();
%  imshow(max);
%  
%  1+1


