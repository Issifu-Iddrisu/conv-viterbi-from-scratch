function [trellis] = generator_to_trellis(generator, K)
% generator: Generator polynomial
% K: constraint length of the encoder

numberOfStates = 2^(K-1);
numberOfOutputBits = size(generator,2);
numberOfInputBits = 2; % Posible input bits


generatorBinary = zeros(numberOfOutputBits,K);

for j = 1: numberOfOutputBits
    generatorBinary(j,:) = dec2bin(generator(j),K) -'0';
end

nextStates = zeros(numberOfStates,numberOfInputBits);
for state = 0:(numberOfStates-1)
        currentState = dec2bin(state, K-1) - '0';
        for inputSymbol = 0:(numberOfInputBits - 1)
            inputSymbolBinary = dec2bin(inputSymbol, log2(numberOfInputBits)) - '0';
            % nextState = [currentState(2:end) inputSymbolBinary ];
            nextState = [inputSymbolBinary currentState(1:end-1) ];
            nextStates(state + 1, inputSymbol + 1) = bin2dec(num2str(nextState));


            
            output = zeros(1, numberOfOutputBits);
            for bit_i = 1:numberOfOutputBits
                output(bit_i) = mod(sum([inputSymbolBinary currentState].* generatorBinary(bit_i, :)), 2);
            end
         
            outputcode(state + 1, inputSymbol + 1) = bi2de(output, 'left-msb');
        end
end

 trellis.numberOfStates = numberOfStates;
 trellis.numberOfOutputs = numberOfOutputBits;
 trellis.numberOfInputBits = numberOfInputBits;
 trellis.outputcode = outputcode;
 trellis.nextStates = nextStates;


end