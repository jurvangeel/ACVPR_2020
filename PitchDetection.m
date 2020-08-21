function NoteData = PitchDetection(NoteLoc, BarLoc)
%Detects the pitch based on staffspace and referencelines for G and Bass
%keys. Every half staff_space a new pitch occurs. The pitches are being
%saved in a new data structure that also contains the note locations and
%the system

% Here's how I take care of the base key:
% If there are no bass staffline blocks, the distance between the
% first bars should be relatively even. If there are bass systems however,
% then every 2nd first bar should be closer to the previous first bar than
% to the next one. Using the std of the reference lines, I can decide wether there are 2
% systems, using the mean of the reference lines i can decided which one I
% am currently in.
%% TO DO:
%{ 
1) @Jur, Check wether NoteLoc(i).Centroid_1 is note.y or NoteLoc(i).Centroid_2 is

2) Sth goes wrong with the way I save values in tone(i). Currently it
returns only 0's, but it should return values from G_pitches and
bass_pitches. Also, i would have expected some kind of error if symbols are
out of the range of possible values in the arrays, e.g. we detect a bofus
symbol and tone(i) would have an index of let's say 33, there should be an out of bounds error or sth 

3)Assumes perfect y location. Still need to account for what happens if
note.y is slightly higher located than ref_line

4)Currently only works up to F4 / A2. Should include higher notes too (C5/F3). 
need to adjust ref_line for that (e.g. multiply ref_line with staff_space/2 or sth, yada yada)
%}


%% Init data structure that contains note locations, system, and pitch.
%(NoteLoc contains locs and systems).
NoteData = NoteLoc; 
pitches = num2cell(zeros(length(NoteData),1));
[NoteData(:).Pitches] = pitches{:};             %Add new column 

tone = zeros(length(NoteData),1);

staff_space =  frequency(BarLoc(:,2));

%% Define Pitches
%For Convenience I start at F4, but you can also include higher notes if
%you adjust the reference line
G_pitches = {'F4','E4','D4','C4','B3','A3','G3','F3','E3','D3','C3','B2','A2','G2','F2','E2','D2','C2','B1','A1','G1'};
bass_pitches = {'A2','G2','F2','E2','D2','C2','B1','A1','G1','F1','E1','D1','C1','B0','A0','G0','F0','E0','D0','C0','B0'};


%% Find reference lines, check whether we have both G and bass keys or not
%Get the first lines
ref_line = find(BarLoc(:,3)==1);  

%Check if we have both G and bass keys or not
%If std of BarLoc(ref_line(:),2) is bigger than e.g. staff_space, we
%know we have 2 different systems
%Might needs tuning (use a different value than staff_space)-> Test this
%with other music sheets to confirm
if std(BarLoc(ref_line(2:end),2)) > staff_space %skip first element since it's an outlier
    two_sys = 1;
else
    two_sys = 0;
end

%% Find the pitch and add it to structure
%Pitch = ((note.y - reference line ) /staffspace/2) + 1 
diff = staff_space/2; %Can give this perhaps a better name

for i=1:length(NoteLoc)
    sys = NoteLoc(i).Class;  %check in which system it is, returns currently 1,2,3
    
    if two_sys == 0
        tone(i)=( NoteLoc(i).Centroid_1 - BarLoc(ref_line(sys)))/diff; 
        tone(i)= G_pitches(round(tone(i))+1);
    else %if we do have G and Bass key:
        sys_dist = mean(BarLoc(ref_line(:),2)); %get the mean of the distances to the next system
        
        %if normal, use normal pitches
        if  BarLoc(ref_line(:),2) > sys_dist %key = G
            tone(i)=(NoteLoc(i).Centroid_1 - BarLoc(ref_line((sys*2)-1)))/diff; %multiply sys by 2 and go one back to go to the ref_line of the G key
            tone(i)= G_pitches(round(tone(i))+1);
            
            %if bass, use bass pitches
        elseif BarLoc(ref_line(:),2) < sys_dist %key = bass
            tone(i)=(NoteLoc(i).Centroid_1 - BarLoc(ref_line(sys*2)))/diff; %multiply sys by 2 to go to the ref_line of the G key
            tone(i)= bass_pitches(round(tone(i))+1);
        end
    end
    %Add tone to the pitch column of our note structure element
    NoteData.Pitches(i)=tone(i); %FIX ME (?)
end

return
end

