function [re] = computeRE (pred, sigma, mu, operational_vector, conf_to_predict)

       re = 100 * ( abs(pred(1) * sigma + mu - operational_vector(1))/operational_vector(1) +
                    abs(pred(4) * sigma + mu - operational_vector(4))/operational_vector(4) +
                    abs(pred(8) * sigma + mu - operational_vector(8))/operational_vector(8) +
                    abs(pred(12) * sigma + mu - operational_vector(12))/operational_vector(12) ) / 4;

endfunction