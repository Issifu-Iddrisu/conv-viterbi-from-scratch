function output = hamming_distance(symbol1, symbol2)
    output = sum(symbol1 ~= symbol2);
end