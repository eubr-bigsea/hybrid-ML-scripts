function [ve] = computeVE (pred, sigma, mu, operational_vector, conf_to_predict)

       ve = 100 * ( abs(pred(3) * sigma + mu - operational_vector(3))/operational_vector(3) +
                    abs(pred(4) * sigma + mu - operational_vector(4))/operational_vector(4) +
                    abs(pred(5) * sigma + mu - operational_vector(5))/operational_vector(5) +
                    abs(pred(8) * sigma + mu - operational_vector(8))/operational_vector(8) +
                    abs(pred(9) * sigma + mu - operational_vector(9))/operational_vector(9) +
                    abs(pred(10) * sigma + mu - operational_vector(10))/operational_vector(10) ) / 6
endfunction