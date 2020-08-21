%% RLE function
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

