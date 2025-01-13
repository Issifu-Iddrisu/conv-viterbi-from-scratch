function output = viterbi_decoder_soft(receivedData,trellis,tracebackDepth,decisionType)


    numberOfStates = length(trellis.nextStates); 
    numberOfInputBits = trellis.numberOfInputBits;
    numberOfOutputBits = trellis.numberOfOutputs;
    outputSymbols = trellis.outputcode;
    nextStates = trellis.nextStates;
    
    messageLength = length(receivedData)/numberOfOutputBits;
    decodedMessage = [];
    pathWeights = -inf(numberOfStates,1);
    pathWeights(1) = 0; 
    survivors = zeros(numberOfStates,tracebackDepth);
    NextpathWeights = zeros(numberOfStates,1);


    for i = 1: messageLength
        receivedSymbol = receivedData(numberOfOutputBits*(i-1)+1:numberOfOutputBits*i);


        pos = mod(i,tracebackDepth);
        if pos == 0
            pos = tracebackDepth;
        end
        for currentState = 1:numberOfStates
            previous_states =[];
            out_puts = [];
            for previousState = 1:numberOfStates
                for inputBit = 1:numberOfInputBits
                    nextState  = nextStates(previousState,inputBit) + 1;
                     if currentState == nextState
                           previous_states = [previous_states previousState];
                           out_puts = [out_puts outputSymbols(previousState, inputBit)];
                     end
                end
            end

            next_metrics = [];
            for j = 1:length(previous_states)
                outputSymbol = dec2bin(out_puts(j),numberOfOutputBits)-'0';
                if strcmp(decisionType,'soft')
                    pos_neg = 2 * outputSymbol - 1;
                    next_metric =  pathWeights(previous_states(j)) + correlation_metric(receivedSymbol, pos_neg);
                    next_metrics = [next_metrics next_metric];
                end
            end
            [min_metric,ind] = max(next_metrics);
            NextpathWeights(currentState) = min_metric;
            survivors(currentState,pos) = previous_states(ind);         
        end 
        pathWeights = NextpathWeights;
        % pathWeights

 
        if pos == tracebackDepth
            bits = [];
            [~, final_state] = max(pathWeights);
            for d = tracebackDepth:-1:1
                prev_state = survivors(final_state,d);
                temp_ = nextStates(prev_state,:)+1; 
                bit = find(temp_ == final_state)-1;
                bits = [bit bits];

                final_state = prev_state;
            end 

            decodedMessage = [decodedMessage bits];


        end 
    end
    

    output = decodedMessage;
end