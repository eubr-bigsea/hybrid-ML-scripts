function [ve] = computeVE (pred, sigma, mu, operational_vector, conf_to_predict)

       ve = 100 * abs(pred(1) * sigma + mu - operational_vector(1))/operational_vector(1);

endfunction