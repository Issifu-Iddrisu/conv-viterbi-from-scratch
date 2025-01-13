clear;clc
% Rate 2/3 code

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
    received  = puncturing_rate23(received);
    decodedbits = viterbi_decoder_soft(received,trellis,10,'soft');
    error_sample(j) = sum(message ~= decodedbits); 
    end

    errors(i) = sum(error_sample)/(N*messageLength);
end

semilogy(10*log10(Eb_No),errors,'r-*')
grid on
hold on

ylabel('BER')
xlabel('E_b/N_0 (dB)')



function output = puncturing_rate23(x)
    output  = x;
    for i  = 1:(length(x)/4)
        output((4*i)-1) = 0;
    end
end
