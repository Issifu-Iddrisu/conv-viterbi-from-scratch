clear;clc
%AWGN Channel + Soft decision
%With 2 bit and 3 bit Quantization
trellis = generator_to_trellis([5 7], 3);
N = 100; 
error_sample = zeros(1,N);
%samples
snr_dp = 0:1:5;
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
    % received = quantize_array_2bit(received);
    received = quantize_array_3bit(received);
    decodedbits = viterbi_decoder_soft(received,trellis,10,'soft');
    error_sample(j) = sum(message ~= decodedbits); 
    end

    errors(i) = sum(error_sample)/(N*messageLength);
    temp_v = exp(-Eb_No(i)/2);
    error_bound(i) = 0.5*(temp_v.^5); % /(1-2*temp_v)^2)
    uncoded_ber(i) = qfunc(sqrt(2*Eb_No(i)));
end
semilogy(10*log10(Eb_No),errors,'g-o')
grid on
hold on
% semilogy(10*log10(Eb_No),error_bound,'m->')
% semilogy(10*log10(Eb_No),uncoded_ber,'b-+')
% ylabel('BER')
% xlabel('E_b/N_0 (dB)')
% 
% legend('Soft decision - Viterbi','Union Bound-Soft','Uncoded BPSK')
% ylabel('BER')
% xlabel('E_b/N_0 (dB)')
