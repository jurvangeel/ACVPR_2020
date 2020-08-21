function NoteFragments = NoteSegmemtation(Score,NoteLoc, BarLoc)

midBars = BarLoc(find(BarLoc(:,3) == 1)+2,1) %middle of each staffline block, NOT used
staff_space =  frequency(BarLoc(:,2));

%Make 128x64 JPGs of the notes
NoteFragments = zeros(length(NoteLoc),1,1);
for i = 1:length(NoteLoc)
temp =    (Score(max(1,round(NoteLoc(i).Centroid_2,0)-63)   :min(size(Score,1),round(NoteLoc(i).Centroid_2,0)+64),...
                 max(1,round(NoteLoc(i).Centroid_1,0)-31)   :min(size(Score,2),round(NoteLoc(i).Centroid_1,0)+32)));
FileName = sprintf('burn%d.jpg',i);
imwrite(temp,FileName);
NoteFragments(i,1:size(temp,1),1:size(temp,2)) = temp;
%imshow(squeeze(NoteFragments(i,:,:)));

end
    
end