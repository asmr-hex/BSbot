function [scores] = scoreFeatures( histograms, labels, varargin)
% scoreFeatures: takes in histograms corresponding to different
%                classification features and scores each feature
%                based on differential bandwidth and amplitude of
%                the positive and negative label histograms.
%                *Note* the number of positive and negative examples
%                must be equal!
% input:    histograms - F x N matrix, where F is the number of features
%                the user wishes to evaluate and N is the total
%                number of training datapoints.
%           labels - F x N matrix which gives the positive or negative
%                labels for each training example.
%           plotON - optional argument to plot feature frequency histograms
%                    for visual validation. Must be boolean.
%           [par] - Optional argument to run script in parallel using
%                matlab pool.
% output:   scores - F x 2 matrix, where the first column corresponds
%                to the differential bandwidth and the second column
%                corresponds to the differential amplitude.

    % Check number of arguments
    if nargin >= 3
        if length(varargin == 1)
            if isboolean(varargin{1})
                switch varargin{1}
                    case true;
                        fprintf('Set to plot histograms...\n');
                        plotON = true;
                    case false;
                        plotON = false;
                end
            else
                fprintf('3rd arg must be either true or false...\n');
            end
        elseif length(varargin) == 2)
            if isboolean(varargin{2})
                switch varargin{2}
                    case true;
                        fprintf('Executing in parallel...\n');
                        par = true;
                    case false;
                        par = false;
                end
            else
                fprintf('4th arg must be either true or false...\n');
            end
        else
            fprintf('There are only 2 optional arguments! \n');
        end
    else
        %By default we do not plot histograms
        plotON = false;
        %By default we do not run in parallel
        par = false;
    end
    
    %Get number of features
    F = size(histograms, 1);
    %initialize output scores
    scores = cell(F);
    
    %Begin matlabpool if requested
    if par
        matlabpool open;
        
        parfor k = 1:F
            scores{k} = getDistances(histograms, labels, k, plotON);
        end
        matlabpool close;
    else
        for k = 1:F
            scores{k} = getDistances(histograms, labels, k, plotON);
        end
    end

end

function [distances] = getDistances(h, l, k, plotON)
    %Partition histograms by positive or negative label
    positive = h(k, find(l(k,:) == 1));
    negative = h(k, find(l(k,:) ==-1));
    
    %sort partitioned training data
    positive = sort(positive, 'descend');
    negative = sort(negative, 'descend');
    
    %============ Differential Frequency Metric =======================
    %Get Hamming Distance of binarized training examples
    bPositive = double(positive > 0);
    bNegative = double(negative > 0);
    hDist = pdist2(bPositive, bNegative, 'hamming');
    
    %Differential frequency is the sum of the hamming distance
    df = sum(hDist);
    
    %============ Differential Amplitude Metric =======================
    % Take the Battachyra Distance 
    bDist = -log2(sum(sqrt( positive .* negative )));
    
    %Differential amplitude is the Battachyra distance
    da = bDist;

    %Report distances
    distances = [ df da ];
    
    
    %Plot Histograms (Optional)
    if plotON
        maxY = max([positive, negative]);
        posColor = [0, 154, 159]./255;
        negColor = [192, 83, 69 ]./255;

        figure(1)
        pp = [positive, nan(1, length(negative)+1)];
        nn = [nan(1, length(positive) + 1), negative];
        bar(pp, 'FaceColor', posColor, 'EdgeColor', posColor); hold on;
        bar(nn, 'FaceColor', negColor, 'EdgeColor', negColor);
        plot((length(positive) + 1) .* ones(2,1), [0 maxY+10], 'Color',...
            [138,137, 137]./255, 'LineWidth', 2, 'LineStyle', '--');
        ylim([0 maxY+1]);
        set(gca, 'XTickLabel', {});
        xlabel('Positive vs. Negative Documents', 'FontSize', 18);
        ylabel('Features per Document', 'FontSize', 18);
    end
    
end