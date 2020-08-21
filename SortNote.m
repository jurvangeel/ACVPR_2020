function [T4] = SortNote(NoteLoc)
T = struct2table(NoteLoc);
T2 = splitvars(T)
GMModel = fitgmdist(T2.Centroid_2,3)
Probs = [GMModel.mu';posterior(GMModel, T2.Centroid_2)];

Probs2 = sortrows(Probs',1)';
Probs2 = Probs2(2:end,:);

[~,T2.Class] = max(Probs2,[],2);
scatter(T2.Centroid_1,T2.Centroid_2,10,T2.Class);
T3 = sortrows(T2,[3 1])
T4 = table2struct(T3);
hope =0;
end