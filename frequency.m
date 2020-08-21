%% Frequency function
function output = frequency(input)
%Returns the heighest frequency of an occuring element in a vector

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