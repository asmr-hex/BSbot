function [scores] = scoreFeatures( histograms, labels, info, varargin)
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
%           info - F x 1 cell array of descriptions of each feature
%           [plotON] - optional argument to plot feature frequency histograms
%                    for visual validation. Must be boolean.
%           [par] - Optional argument to run script in parallel using
%                matlab pool.
% output:   scores - F x 2 matrix, where the first column corresponds
%                to the differential bandwidth and the second column
%                corresponds to the differential amplitude.

    % Check number of arguments
    %By default we do not plot histograms
    plotON = 0;
    %By default we do not run in parallel
    par = 0;
    if nargin >= 4
        if length(varargin) == 1
            if varargin{1} == 1 || varargin{1} == 0
                switch varargin{1}
                    case 1;
                        fprintf('Set to plot histograms...\n');
                        plotON = 1;
                    case 0;
                        plotON = 0;
                end
            else
                fprintf('4th arg must be either true or false...\n');
            end
        elseif length(varargin) == 2
            if varargin{1} == 1 || varargin{1} == 0
                switch varargin{1}
                    case 1;
                        fprintf('Set to plot histograms...\n');
                        plotON = 1;
                    case 0;
                        plotON = 0;
                end
            else
                fprintf('4th arg must be either true or false...\n');
            end
            if varargin{2} == 1 || varargin{2} == 0
                switch varargin{2}
                    case 1;
                        fprintf('Executing in parallel...\n');
                        par = 1;
                    case 0;
                        par = 0;
                end
            else
                fprintf('5th arg must be either true or false...\n');
            end
        else
            fprintf('There are only 2 optional arguments! \n');
        end
    end
    
    %Get number of features
    F = size(histograms, 1);
    %initialize output scores
    scores = cell(F,1);
    
    %Begin matlabpool if requested
    if par
        matlabpool open;
        
        parfor k = 1:F
            scores{k} = getDistances(histograms, labels, info, k, plotON);
        end
        matlabpool close;
    else
        for k = 1:F
            scores{k} = getDistances(histograms, labels, info, k, plotON);
        end
    end
    
    %Convert scores cell to matrix
    scores = cell2mat(scores);
    
end

function [distances] = getDistances(h, l, info, k, plotON)
    %Partition histograms by positive or negative label
    positive = h(k, find(l == 1));
    negative = h(k, find(l ==-1));
    
    %sort partitioned training data
    positive = sort(positive, 'descend');
    negative = sort(negative, 'descend');
    
    %============ Differential Frequency Metric =======================
    %Get Hamming Distance of binarized training examples
    bPositive = double(positive > 0);
    bNegative = double(negative > 0);
    hDist = pdist2(bPositive, bNegative, 'hamming');
    %Return distance multiplied by the sign of the larger label
    if sum(positive > 0) < sum(negative > 0)
        hDist = hDist * -1;
    end
    
    %Differential frequency is the sum of the hamming distance
    df = sum(hDist);
    
    %============ Differential Amplitude Metric =======================
    %Take the Tanimoto  Distance 
    bDist = sum(abs( positive - negative )) ./ sum(max([positive; negative], [], 1));
    %Return distance multiplied by the sign of the larger label
    if sum(positive) < sum(negative)
        bDist = bDist * -1;
    end
    
    %Differential amplitude is the Tanimoto  distance
    da = bDist;

    %Report distances
    distances = [ df da ];
    
    distances(isnan(distances)) = 0;
    
    
    %Plot Histograms (Optional)
    if plotON
        maxY = max([positive, negative]);
        posColor = [0, 154, 159]./255;
        negColor = [192, 83, 69 ]./255;

        figure(1)
        clf;
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
        title(['Feature: ' info{k}], 'fontsize',18);
        pause(0.5);
    end
    
end