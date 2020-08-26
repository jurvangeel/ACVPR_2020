function scaled_IMG = rescale_staff_space(staff_space, IMG)
% Scales IMG such that it has the desired staff_space. 

des_staff_space = 13; %Set desired staff_space here
[height, width] = size(IMG);
new_height = height/staff_space*des_staff_space;
scale =  new_height / height;

scaled_IMG = imresize(IMG,scale);

return
end