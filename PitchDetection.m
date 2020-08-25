function NoteData = PitchDetection(NoteLoc, BarLoc)
%Detects the pitch based on staffspace and referencelines for G and Bass
%keys. Every half staff_space a new pitch occurs. The pitches are being
%saved in a new data structure that also contains the note locations and
%the system

%% Keep in mind:
%{
1)Assumes perfect y location. Still need to account for what happens if
note.y is slightly higher located than ref_line

2) Does not consider flats or sharps!
%}


%% Init data structure that contains note locations, system, and pitch.
%(NoteLoc contains locs and systems).
NoteData = NoteLoc;
pitches = num2cell(zeros(length(NoteData),1));
key = num2cell(zeros(length(NoteData),1));
[NoteData(:).Pitches] = pitches{:};             %Add new column
[NoteData(:).Key] = key{:};

staff_space =  frequency(BarLoc(:,2));

%% Define Pitches
G_pitches = {'C5','B4','A4','G4','F4','E4','D4','C4','B3','A3','G3','F3','E3','D3','C3','B2','A2','G2','F2','E2','D2','C2','B1','A1','G1'};
bass_pitches = {'E3','D3','C3','B2','A2','G2','F2','E2','D2','C2','B1','A1','G1','F1','E1','D1','C1','B0','A0','G0','F0','E0','D0','C0'};


%% Find reference lines, check whether we have both G and bass keys or not
%Get the first lines
ref_line = find(BarLoc(:,3)==1); %The top line of every staff block, so either F4 (G-Key) or A2 (Bass Key)

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
midBars = BarLoc(find(BarLoc(:,3) == 1)+2,1); %middle of each staffline block

for i=1:length(NoteLoc)
    sys = NoteLoc(i).Class;  %check in which system it is, returns currently 1,2,3 for 'colours'
    
    if two_sys == 0
        pitches{i}=( NoteLoc(i).Centroid_2 - BarLoc(ref_line(sys)))/diff;
        pitches{i}= G_pitches(round(pitches{i})+1);
        key{i} = 'G-Key';
    else
        %if we do have G and Bass key check in which one we are in.
        %if the distance from note.y is smaller to the middle bar of
        %the G key than to the middle bar of the bass key, then we are in
        %the G key
        if abs(NoteLoc(i).Centroid_2 - midBars((sys*2)-1)) < abs(NoteLoc(i).Centroid_2 - midBars(sys*2))
            
            % multiply sys by 2 and go one back to go to the ref_line of the G key which are all odd ref lines.
            % -4*diff moves the ref_line from F4 to C5. 
            pitches{i}=(NoteLoc(i).Centroid_2 - BarLoc(ref_line((sys*2)-1))+4*diff)/diff;  
            if (pitches{i} <= length(G_pitches)) && (pitches{i} >= 0) %avoid out of bounds error
                pitches{i}= G_pitches{round(pitches{i})+1}; %add pitch into our data structure
                key{i} = 'G-Key';
            else
                pitches{i} = 0; %set it back to 0
            end
            
        else % we must be in the bass key
            pitches{i}=(NoteLoc(i).Centroid_2 - BarLoc(ref_line(sys*2))+4*diff)/diff; %multiply sys by 2 to go to the ref_line of the bass key which are all even ref_lines
            if pitches{i} <= length(bass_pitches) && (pitches{i} >= 0)
                pitches{i}= bass_pitches{round(pitches{i})+1};
                key{i} = 'F-Key';
            else
                pitches{i} = 0;
            end
        end
    end
    %Add data to our note structure element
    [NoteData(i).Pitches]=pitches{i};
    [NoteData(i).Key]=key{i};
end
return
end

