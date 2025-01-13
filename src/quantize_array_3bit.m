function quantized_array = quantize_array_3bit(x)
    quantized_array = zeros(size(x));  % Initialize an array to store quantized values
    
    for i = 1:length(x)
        val = x(i);
        if val < -0.9
            quantized_array(i) = -1;
        elseif val < -0.6
            quantized_array(i) = -0.75;
        elseif val < -0.3
            quantized_array(i) = -0.45;
        elseif val < 0
            quantized_array(i) = -0.15;
        elseif val < 0.3
            quantized_array(i) = 0.15;
        elseif val < 0.6
            quantized_array(i) = 0.45;
        elseif val < 0.9
            quantized_array(i) = 0.75;
        else
            quantized_array(i) = 1;
        end
    end
end