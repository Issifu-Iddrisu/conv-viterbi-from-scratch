% Rate 5/4 code
clear;clc
%AWGN Channel + Soft decision
trellis = generator_to_trellis([5 7], 3);
N = 100; 
error_sample = zeros(1,N);
%samples
snr_dp = 0:1:7;
Eb_No = db2pow(snr_dp);
sigma2 = 0.5*(1./Eb_No);
errors = zeros(1,length(sigma2));
error_bound = zeros(1,length(sigma2));
uncoded_ber = zeros(1,length(sigma2));
messageLength = 10000;
for i = 1:length(sigma2)
    for j =1:N
    message = randi([0 1],1,messageLength);
    
    message_encoded = convolutional_encoder(message,trellis);
    message_encodedLength = length(message_encoded);
    modulated_message_encoded = 2*message_encoded - 1;
    
    received = modulated_message_encoded + sqrt(sigma2(i))*randn(1,message_encodedLength);
    received  = puncturing_rate56_1(received);
    decodedbits = viterbi_decoder_soft(received,trellis,10,'soft');
    error_sample(j) = sum(message ~= decodedbits); 
    end

    errors(i) = sum(error_sample)/(N*messageLength);
end

semilogy(10*log10(Eb_No),errors,'b->')
grid on
hold on
ylabel('BER')
xlabel('E_b/N_0 (dB)')
% legend('Rate:2/3 - Soft decision Viterbi','Rate:3/4 - Soft decision Viterbi','Rate:5/6 - Soft decision Viterbi')

legend('Rate:2/3 - Soft decision Viterbi','Rate:3/4 - Soft decision Viterbi','Rate:5/6 - Soft decision Viterbi')

function output = puncturing_rate56_1(x)
    output  = x;
    for i  = 1:(length(x)/10)
        output((10*i)-7) = 0;
        output((10*i)-5) = 0;
        output((10*i)-2) = 0;
        output((10*i)) = 0;
    end
end



function output = puncturing_rate56_2(x)
    output  = x;
    for i  = 1:(length(x)/10)
        output((10*i)-7) = 0;
        output((10*i)-4) = 0;
        output((10*i)-3) = 0;
        output((10*i)) = 0;
    end
end

function output = puncturing_rate56_3(x)
    output  = x;
    for i  = 1:(length(x)/10)
        output((10*i)-6) = 0;
        output((10*i)-4) = 0;
        output((10*i)-2) = 0;
        output((10*i-1)) = 0;
    end
end
