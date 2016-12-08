function [re] = computeRE (pred, sigma, mu, operational_vector, conf_to_predict)

       re = 100 * ( abs(pred(3) * sigma + mu - operational_vector(3))/operational_vector(3) +
                    abs(pred(4) * sigma + mu - operational_vector(4))/operational_vector(4) +
                    abs(pred(5) * sigma + mu - operational_vector(5))/operational_vector(5) +
                    abs(pred(6) * sigma + mu - operational_vector(6))/operational_vector(6) +
                    abs(pred(7) * sigma + mu - operational_vector(7))/operational_vector(7) +
                    abs(pred(8) * sigma + mu - operational_vector(8))/operational_vector(8) +
                    abs(pred(9) * sigma + mu - operational_vector(9))/operational_vector(9) +
                    abs(pred(10) * sigma + mu - operational_vector(10))/operational_vector(10) +
                    abs(pred(11) * sigma + mu - operational_vector(11))/operational_vector(11) +
                    abs(pred(12) * sigma + mu - operational_vector(12))/operational_vector(12) ) / 10;

endfunction