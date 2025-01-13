function [output] = convolutional_encoder(message,trellis )

     numberOfStates = trellis.numberOfStates;
     nextStates = trellis.nextStates;
     numberOfOutputBits = trellis.numberOfOutputs;
     numberOfInputBits  = trellis.numberOfInputBits;
     outputcode = trellis.outputcode;
     nextStates = trellis.nextStates;
    
    coded_message = zeros(1, length(message)*numberOfOutputBits);
    
    currentState = 1;

    for i= 1:length(message)
        inputSymbol = message(i);
        
        nextState  = nextStates(currentState,inputSymbol+1);
        coded_message(numberOfOutputBits*(i-1)+1:numberOfOutputBits*i)= dec2bin(outputcode(currentState, inputSymbol+1),numberOfOutputBits)-'0';

       currentState  = nextState + 1;
    end

    output = coded_message;
end