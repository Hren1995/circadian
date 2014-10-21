function aux = sort_by(idx)
idx = idx(:);
aux = sortrows([idx [1:numel(idx)]']);
aux = aux(:,2);
end