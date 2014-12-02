function [histograms, labels, info] = reduceDictionary(histograms, labels, info)
%Using tf-idf method, reduce dictionary

%Get number of documents
D = length(labels);
%Get number of terms
T = size(histograms, 1);

%Get Term Frequencies and Inverse Document Frequencies
TF = sum(histograms, 2);
DF = sum((histograms > 0), 2);
IDF = log2(D./(1 + DF));
%Get TF-IDF
TF_IDF = TF .* IDF;

%Sort based off of highest tf-idf
[TF_IDF inds] = sort(TF_IDF, 'descend');
histograms = histograms(inds, :);
info = info(inds);

%Get range of tf-idf
rng = TF_IDF(1);
rm_rng = 0.25*rng;

%Remove terms which are below 25% range of tf-idf
inds = find(TF_IDF < rm_rng);
TF_IDF(inds) = [];
histograms(inds,:) = [];
info(inds) = [];

end