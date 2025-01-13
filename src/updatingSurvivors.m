function [pathWeights, survivors] = updatingSurvivors(BranchWeights, pathWeights, survivors)
    numStates = size(BranchWeights, 1);
    tbDepth = size(survivors, 2);
    pathWeights = inf(numStates, 1);
    survivors = zeros(numStates, tbDepth);

    for nextStateIdx = 1:numStates
        for currentStateIdx = 1:numStates
            newPathMetric = pathWeights(currentStateIdx) + BranchWeights(nextStateIdx, currentStateIdx);
            if newPathMetric < pathWeights(nextStateIdx)
                pathWeights(nextStateIdx) = newPathMetric;
                survivors(nextStateIdx, :) = survivors(currentStateIdx, :);
                survivors(nextStateIdx, end) = nextStateIdx;
            end
        end
    end
end
