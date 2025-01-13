function decodedSeq = traceback_path(tracebackMem, index, tracebackDepth)
    decodedSeq = zeros(1, tracebackDepth);
    state = tracebackMem(1, end); % Start traceback from the initial state
    
    for i = tracebackDepth:-1:1
        decodedSeq(i) = state - 1; % Convert to 0-based indexing
        state = tracebackMem(state, i);
    end
end

