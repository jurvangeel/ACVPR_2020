function IMG = BarReduct(IMG, BarLoc)

%[staff_height, staff_space, height_space] = staff_height_space(imcomplement(IMG));
IMG = imcomplement(IMG);

%%staff_height
a = IMG(:);
rel_length = rle(a,IMG);

staff_heights = [];
staff_spaces = [];
for k=1:2:length(rel_length)-1
    if (rel_length(k+1)==1)
        staff_heights = [staff_heights,rel_length(k)];
    else
        staff_spaces = [staff_spaces,rel_length(k)];
    end
end

staff_space =  frequency(BarLoc(:,2));
staff_height = frequency(staff_heights);

%% Next, find the most common staff_height + space by finding the most common sum of 2 consecutive vertical runs (either black run followed by white run or the
%This will be more robust when dealing with noise if you want to find the
%sum of staff space and height

height_and_space = [];
%check whether space or height array has smaller size
small_array_length = min(length(staff_heights),length(staff_spaces));

for u=1:small_array_length
    height_and_space = [height_and_space, (staff_heights(u)+staff_spaces(u))];
end

height_space = frequency(height_and_space);

%threshhold T
T = min(2*staff_height,height_space);



SE_line = strel('line', T+2, 90);%otherwise it wasn't strong enough yet....
IMG = imerode(IMG, SE_line);
IMG = imcomplement(IMG);    
end

function output = rle(in_vector, in_matrix)

%INPUT: vectorized (binary) musical image and original matrix
%OUTPUT: vertical rle lengths

%init empty output array
output = [];
counter = 1;

for i=1:length(in_vector)-1 % -1 because we are also looking at the next element in the vector
    % val for checking if we are at the last row element of a column
    % if the mod of i and the row length of the origonal matrix is 0, we know that we have reached
    % the end of the column of the origonal matrix
    val = mod(i,size(in_matrix,1));
    
    % if the current element of the vector image equals the next
    % element and we are not at the end of the matrix column, add +1 to
    % the counter
    if (in_vector(i)==in_vector(i+1) && (val~=0))
        counter = counter+1;
    else
        %else insert the counter and the value of that element into our
        %output array
        output = [output,counter,in_vector(i),];
        counter = 1;
    end
end

%Include last element of the vector
output = [output,counter,in_vector(end)];

return
end

%% Frequency function
function output = frequency(input)
%Returns the heighest frequency of a occuring element in a vector

a = unique(input);
freq = histc(input,a);

%find highest frequency and return the unique element
max_frequ = max(freq);

%find indexes
idx = find(freq==max_frequ);

%If the heighest frequency occurs for 2 numbers at the same time, take the
%smaller one (?) Should not be a problem when applying to the real sheet
%music
idx = min(idx);
output = a(idx);
end