function [slices, doclen] = slice_token(doc, slicelen)
% slice tokenize document into slice of slicelen tokens

% length of document and slice intervals
doclen = length(doc);
if doclen <= slicelen
    idx = 1;
else
    idx = 1:slicelen:doclen;
end
% slice document
n = numel(idx);
slices = cell(numel(n));
for i = 1:n
    if i == max(n)
        slice = doc(idx(i):end);
    else
        slice = doc(idx(i):(idx(i+1)-1));
    end
    slices{i} = slice;
end