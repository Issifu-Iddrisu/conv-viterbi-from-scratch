function quantized_array = quantize_array_2bit(x)
    quantized_array = zeros(size(x));  % Initialize an array to store quantized values
    
    for i = 1:length(x)
        val = x(i);
        if val < -0.75
            quantized_array(i) = -1;
        elseif val < 0
            quantized_array(i) = -0.5;
        elseif val < 0.5
            quantized_array(i) = 0.5;
        else
            quantized_array(i) = 1;
        end
    end
end

