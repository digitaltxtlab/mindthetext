function [entbar, entsd] = entropy_slices(slices)
% word level entropy for sliced document

% remove end slice if it is shorter than other slices
if (numel(slices{end}) ~= numel(slices{1}))
    slices = slices(1:(numel(slices)-1));
end
% calculate word level entropy for each slice
entropys = zeros(size(slices));
for i = 1:numel(slices)
    slice = slices{i};
    entropys(i) = ComputeEntropyWord(slice);
end
% estimate word level entropy for document
entbar = mean(entropys);
entsd = std(entropys);