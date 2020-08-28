function [Lines,Bars, Stafspace] = BarDetection(IM)
%Blad1 = imresize(IM,400/size(IM,2));
Blad1 = IM; %why? you are not using IM again for sth else


scan = im2bw(normalize(imcomplement(Blad1)),0);
se_line = strel('line', length(scan)*0.2, 0);
scan = imerode(scan, se_line);


Lines = islocalmax(sum(scan,2));
Lines2 = imresize(Lines, [size(Blad1,1) size(Blad1,2)], 'nearest');
%%use to plot during analysis
% total = [Blad1(:,1:size(Blad1,1)/3) ...
%          imcomplement(Lines2(:,size(Blad1,1)/3-50:size(Blad1,1)/3+50)) ...
%          Blad1(:,2*size(Blad1,1)/3:end)];
% imshow(total);

% Lines = imcomplement(Lines);
% return
%% use when bars do not neatly match on first attempt
Bars = find(Lines);                     % 1nd col: y value of a lines
Bars2 = [0; Bars];
Bars(:,2) = [Bars - Bars2(1:end-1)];    % 2nd col: Distance between lines

[GC,GR] = groupcounts(Bars(:,2)); 
[trash, I] = max(GC);
Distances = dist(GR');
Distances = Distances(I,:);
Used = Distances < GR(I) / 2;

Stafspace = (Used*(GC.*GR))/(Used*GC) % calc the mean staff space 

Bars(find(Bars(:,2)>floor(Stafspace*2)),3) = 1;         %3rd col: 1 indicates the start of a new "staffline block". 

% split = [find(Bars(:,3)); size(Bars,1)+1]; %indicate cols where staffspace is higher, last row is number of cols +1 %+2 could be replaced with StDev. of small values in Bars
% for i = size(split)-1:-1:1                      %start at size -1, go backwards
%      if (split(i+1) - split(i) < 5)             %if there are less lines than 5 in a "staffline blocks" %parameter  
%          Lines(Bars(split(i),1))= 0;            %erase a line at the start of a new block?
%      elseif (split(i+1) - split(i) > 5)         % %parameter
%          Local = Bars(split(i)+1:split(i+1)-1,2); %get the staffspace of the 2nd and last line of a staff line block
%          Local = abs(Local-mean(Local));           %subtract the mean from these values
%          for j = 6:split(i+1) - split(i)             %is for all the extra staflines (so line 6 till x)
%             if find(Local==max(Local))<(length(Local)/2)  %?
%                 Lines(Bars(split(i)+min(find(Local==max(Local)))-1,:))=0;
%             else
%                 Lines(Bars(split(i)+max(find(Local==max(Local))),:))=0;
%             end
%          end
%      end
% end

Lines = imresize(Lines, [size(Blad1,1) size(Blad1,2)], 'nearest');  %Create lines based on size of image 

% %use to plot dur
% total = [Blad1(:,1:size(Blad1,1)/3) ...
%          imcomplement(Lines(:,size(Blad1,1)/3-50:size(Blad1,1)/3+50)) ...
%          Blad1(:,2*size(Blad1,1)/3:end)];
% imshow(total);

Lines = imcomplement(Lines);
%Lines = imresize(Lines,size(IM));

%GMModel = fitgmdist(Bars(:,2),2)

return

end

% imshow(Blad1);

% %lines V1
% Filter = [1;-1;1]/3;
% FilterLines = imresize(Filter, [1 260], 'nearest');
% scan = conv2(Blad1,FilterLines);
% img =normalize(sum( double(Blad1) + .5*scan(end-size(Blad1,1)+1:end,end-size(Blad1,2)+1:end),2));
% img = islocalmax(img,1);
% img1 = imresize(img, [size(Blad1,1) size(Blad1,2)], 'nearest');
% 
% % figure();
% % imshow(img1);


% %notes V1
% Filter = [1 1 1 1;1 -8 -8 1;1 -8 -8 1;1 -8 -8 1;1 1 1 1];
% scan2 = conv2(Blad1,Filter);
% img2 =normalize( double(Blad1) + .5*scan2(end-size(Blad1,1)+1:end,end-size(Blad1,2)+1:end));
% se = strel('diamond',2);
% img2 = imdilate(img2,se);
% 
% % figure();
% img2 = normalize(img2-img1);
% img2 = img2>1;
% % imshow(img2);



%lines V2
% Grayscale = sum( Blad1, 1);
% pageMean = mean(Grayscale(75:175)) %hocus pocus, find a good way to not look at the sides
% SelectedColm = find(Grayscale(10:175)>pageMean);
% Selection = Blad1(:,SelectedColm);

