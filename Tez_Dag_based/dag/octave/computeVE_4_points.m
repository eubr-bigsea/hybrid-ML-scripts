function [ve] = computeVE (pred, sigma, mu, operational_vector, conf_to_predict)

       ve = 100 * ( abs(pred(2) * sigma + mu - operational_vector(2))/operational_vector(2) +
                    abs(pred(3) * sigma + mu - operational_vector(3))/operational_vector(3) +
                    abs(pred(5) * sigma + mu - operational_vector(5))/operational_vector(5) +
                    abs(pred(6) * sigma + mu - operational_vector(6))/operational_vector(6) +
                    abs(pred(7) * sigma + mu - operational_vector(7))/operational_vector(7) +
                    abs(pred(9) * sigma + mu - operational_vector(9))/operational_vector(9) +
                    abs(pred(10) * sigma + mu - operational_vector(10))/operational_vector(10) +
                    abs(pred(11) * sigma + mu - operational_vector(11))/operational_vector(11) ) / 8
endfunction