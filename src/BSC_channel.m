clc
%BSC Channel
trellis = generator_to_trellis([6 3], 3);

probs = [0.2 0.1 0.01 0.001 0.0001];
% probs = [0.0100    0.0325    0.0550     0.1000]
errors = zeros(1,length(probs));

union_bound = zeros(1,length(probs));

messageLength = 10000;
N = 100;
for i = 1:length(probs)
    for j = 1:N
    message = randi([0 1],1,messageLength );
    message_encoded = convolutional_encoder(message,trellis);


    errors_loc2 = find(rand(1,length(message_encoded))<probs(i));
    received2 = message_encoded;
    received2(errors_loc2) = ~received2(errors_loc2);
    received2 = viterbi_decoder(received2,trellis,1000,'hard');
    error_rate2 = sum(message ~= received2);    
    error_sample(j) =error_rate2;
    end
    errors(i) = sum(error_sample)/(N*messageLength);
    
    temp_value = sqrt(4*probs(i)*(1-probs(i)));
    union_bound(i) =((temp_value^5)/((1-(2*temp_value))^2));
end

% loglog(probs,errors/messageLength,'r-x')
% hold on
loglog(probs,errors,'g-+')
grid on
hold on
% loglog(probs,union_bound,'r-x')
xlabel('crossover probability(p)')
ylabel('Bit error rate (BER)')
