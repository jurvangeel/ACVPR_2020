function IMGanalysis = plotScore(IMG, Bars,Notes,BarLoc)

midBars = BarLoc(find(BarLoc(:,3) == 1)+2,1)
 staff_space =  frequency(BarLoc(:,2));
 Blad3 = IMG;
 Blad3(midBars,:)=0;
 lows = midBars - staff_space*5
 highs= midBars + staff_space*5
 Blad3(lows,:) =0;
 Blad3(highs,:)=0;
 
 

IMGanalysis = cat(3,Bars,Notes,Blad3);
figure();
imshow(imcomplement(IMGanalysis));

end