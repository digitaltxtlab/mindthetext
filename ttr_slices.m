function [ttrbar, ttrsd] = ttr_slices(slices)
% type token ratio for sliced document

% remove end slice if it is shorter than other slices
if (numel(slices{end}) ~= numel(slices{1}))
    slices = slices(1:(numel(slices)-1));
end
% calculate ttr for each slice
ttrs = zeros(size(slices));
for i = 1:numel(slices)
    slice = slices{i};
    ttrs(i) = numel(unique(slice))/numel(slice);
end
% estimate ttr for document
ttrbar = mean(ttrs);
ttrsd = std(ttrs);
