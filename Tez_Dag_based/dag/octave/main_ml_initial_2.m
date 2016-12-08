% This piece of code is dedicated to pure ML performance prediction for different conbinations of 
% our two thresholds, i.e. itrThr and stopThr.
%
% While itrThr is used to check the condition for proceeding to the next iteration, 
% stopThr is used to check the condition of stopping the whole process of reselecting new models.
%
% To find the optimum combination of the two thesholds, I change the itrThr in the range of (25..41)
% while the stopThr is changed in the range of (10..30). For each combination the seed value 
% is changed between (1..100) to remove the probable bias to a special seed value.

clear all
close all hidden
clc
warning("off")


query = "Q1";
ssize = "30";
configuration_to_predict = 12;

%for R1:
opr_configurations =    [2 3 4 5 6 8 9 10 12 15 16 20];
full_configurations =   [2 3 4 5 6 8 9 10 12 15 16 20];
simple_configurations = [2 3 4 5 6 8 9 10 12 15 16 20];
full_scaled = [1 1 1 1 1 1 1 1 1 1 1 1];
%----------------------------------------------------------------------------------------------
% Options to be used for Linear SVR
conf_linear = "-s 3 -t 0 -q -h 0 ";


% Path to the files containing the operational data:
query_operational_data_2 = ["oper/" query "/" ssize "/2.csv"];
query_operational_data_3 = ["oper/" query "/" ssize "/3.csv"];
query_operational_data_4_1 = ["oper/" query "/" ssize "/4_1.csv"];
query_operational_data_4_2 = ["oper/" query "/" ssize "/4_2.csv"];
query_operational_data_5 = ["oper/" query "/" ssize "/5.csv"];
query_operational_data_6_1 = ["oper/" query "/" ssize "/6_1.csv"];
query_operational_data_6_2 = ["oper/" query "/" ssize "/6_2.csv"];
query_operational_data_8_1 = ["oper/" query "/" ssize "/8_1.csv"];
query_operational_data_8_2 = ["oper/" query "/" ssize "/8_2.csv"];
query_operational_data_9 = ["oper/" query "/" ssize "/9.csv"];
query_operational_data_10 = ["oper/" query "/" ssize "/10.csv"];
query_operational_data_12_1 = ["oper/" query "/" ssize "/12_1.csv"];
query_operational_data_12_2 = ["oper/" query "/" ssize "/12_2.csv"];
query_operational_data_15 = ["oper/" query "/" ssize "/15.csv"];
query_operational_data_16 = ["oper/" query "/" ssize "/16.csv"];
query_operational_data_20 = ["oper/" query "/" ssize "/20.csv"];

% Base directory of analytical and operational data
base_dir = "../source_data/";


operational_data_2 = read_data([base_dir query_operational_data_2]);
operational_data_3 = read_data([base_dir query_operational_data_3]);
operational_data_4_1 = read_data([base_dir query_operational_data_4_1]);
operational_data_4_2 = read_data([base_dir query_operational_data_4_2]);
operational_data_5 = read_data([base_dir query_operational_data_5]);
operational_data_6_1 = read_data([base_dir query_operational_data_6_1]);
operational_data_6_2 = read_data([base_dir query_operational_data_6_2]);
operational_data_8_1 = read_data([base_dir query_operational_data_8_1]);
operational_data_8_2 = read_data([base_dir query_operational_data_8_2]);
operational_data_9 = read_data([base_dir query_operational_data_9]);
operational_data_10 = read_data([base_dir query_operational_data_10]);
operational_data_12_1 = read_data([base_dir query_operational_data_12_1]);
operational_data_12_2 = read_data([base_dir query_operational_data_12_2]);
operational_data_15 = read_data([base_dir query_operational_data_15]);
operational_data_16 = read_data([base_dir query_operational_data_16]);
operational_data_20 = read_data([base_dir query_operational_data_20]);

[operational_data_2_cleaned, ~] = clear_outliers (operational_data_2);
[operational_data_3_cleaned, ~] = clear_outliers (operational_data_3);
[operational_data_4_1_cleaned, ~] = clear_outliers (operational_data_4_1);
[operational_data_4_2_cleaned, ~] = clear_outliers (operational_data_4_2);
[operational_data_5_cleaned, ~] = clear_outliers (operational_data_5);
[operational_data_6_1_cleaned, ~] = clear_outliers (operational_data_6_1);
[operational_data_6_2_cleaned, ~] = clear_outliers (operational_data_6_2);
[operational_data_8_1_cleaned, ~] = clear_outliers (operational_data_8_1);
[operational_data_8_2_cleaned, ~] = clear_outliers (operational_data_8_2);
[operational_data_9_cleaned, ~] = clear_outliers (operational_data_9);
[operational_data_10_cleaned, ~] = clear_outliers (operational_data_10);
[operational_data_12_1_cleaned, ~] = clear_outliers (operational_data_12_1);
[operational_data_12_2_cleaned, ~] = clear_outliers (operational_data_12_2);
[operational_data_15_cleaned, ~] = clear_outliers (operational_data_15);
[operational_data_16_cleaned, ~] = clear_outliers (operational_data_16);
[operational_data_20_cleaned, ~] = clear_outliers (operational_data_20);

% EHSAN: recomputing avg_time_query_vector at runtime to be sure of the old values
avg_time_query_vector = [(mean(operational_data_2_cleaned))(1) (mean(operational_data_3_cleaned))(1) ((mean(operational_data_4_1_cleaned))(1)+(mean(operational_data_4_2_cleaned))(1))/2 (mean(operational_data_5_cleaned))(1) ((mean(operational_data_6_1_cleaned))(1)+(mean(operational_data_6_2_cleaned))(1))/2  ((mean(operational_data_8_1_cleaned))(1)+(mean(operational_data_8_2_cleaned))(1))/2  (mean(operational_data_9_cleaned))(1) (mean(operational_data_10_cleaned))(1)  ((mean(operational_data_12_1_cleaned))(1)+(mean(operational_data_12_2_cleaned))(1))/2  (mean(operational_data_15_cleaned))(1) (mean(operational_data_16_cleaned))(1) (mean(operational_data_20_cleaned))(1)];
%avg_time_query_vector = [(mean(operational_data_2_cleaned))(1) (mean(operational_data_3_cleaned))(1) (mean(operational_data_4_1_cleaned))(1) (mean(operational_data_4_2_cleaned))(1) (mean(operational_data_5_cleaned))(1) (mean(operational_data_6_1_cleaned))(1) (mean(operational_data_6_2_cleaned))(1)  (mean(operational_data_8_1_cleaned))(1) (mean(operational_data_8_2_cleaned))(1)  (mean(operational_data_9_cleaned))(1) (mean(operational_data_10_cleaned))(1)  (mean(operational_data_12_1_cleaned))(1) (mean(operational_data_12_2_cleaned))(1)  (mean(operational_data_15_cleaned))(1) (mean(operational_data_16_cleaned))(1) (mean(operational_data_20_cleaned))(1)];

% Splitting parameters
train_frac = 0.6;
test_frac = 0.2

% Ranges to be used for the identification of the optimal "C" and "epsilon" parameters for the SVR
C_range = linspace (0.1, 5, 20);
E_range = linspace (0.1, 5, 20);

% Changing itrThr in its range...
for itrThr = 26:26
  out(1) = itrThr;
  ml_out(1) = itrThr;
  % Changing stopThr in its range...
  for stopThr = 15:15
    out(2) = stopThr; 
    ml_out(2) = stopThr; 
    
    % Path to the output file for each combination of (itrThr, stopThr)
    ml_outPath = ["../plots/", query, "/", ssize, "/linear/missing_", num2str(opr_configurations(configuration_to_predict)), "/MLExtrapolate/2/ml_out_", num2str(itrThr), "_", num2str(stopThr), ".csv"];
    
    % Insert something into the first row of the output file, because the file need 
    % to be read later and read_data function ignores the first row of input file
    header(1) = 1;
    header(2) = 1;
    header(3) = 1;
    header(4) = 1;
    header(5) = 1;
    header(6) = 1;
    header(7) = 1;
    header(8) = 1;
    dlmwrite(ml_outPath, header);

    % Changing seed in its range...
    for seed = 1 : 50
          out(3) = seed;
          ml_out(3) = seed;
          rand ("seed", "reset");
          rand ("seed", seed);
          
          % At first, the Knowledge Base is empty
          ml_current_KB = [];
 
          % For each operational data, shuffling is applied 
          % and the number of cores is inverted, because we want 
          % an ML model to be linear based on 1/nCores.
          
          % EHSAN: inversing the X values while SHUFFLING IS BEING APPLIED **********************
          permutation = randperm (size (operational_data_2_cleaned, 1));
          operational_data_2_cleaned_inverted = operational_data_2_cleaned(permutation, :);
          operational_data_2_cleaned_inverted(:, 2) = 1 ./ operational_data_2_cleaned_inverted(:, 2);

          permutation = randperm (size (operational_data_3_cleaned, 1));
          operational_data_3_cleaned_inverted = operational_data_3_cleaned(permutation, :);
          operational_data_3_cleaned_inverted(:, 2) = 1 ./ operational_data_3_cleaned_inverted(:, 2);
          
          permutation = randperm (size (operational_data_4_1_cleaned, 1));
          operational_data_4_1_cleaned_inverted = operational_data_4_1_cleaned(permutation, :);
          operational_data_4_1_cleaned_inverted(:, 2) = 1 ./ operational_data_4_1_cleaned_inverted(:, 2);

          permutation = randperm (size (operational_data_4_2_cleaned, 1));
          operational_data_4_2_cleaned_inverted = operational_data_4_2_cleaned(permutation, :);
          operational_data_4_2_cleaned_inverted(:, 2) = 1 ./ operational_data_4_2_cleaned_inverted(:, 2);
          
          permutation = randperm (size (operational_data_5_cleaned, 1));
          operational_data_5_cleaned_inverted = operational_data_5_cleaned(permutation, :);
          operational_data_5_cleaned_inverted(:, 2) = 1 ./ operational_data_5_cleaned_inverted(:, 2);
          
          permutation = randperm (size (operational_data_6_1_cleaned, 1));
          operational_data_6_1_cleaned_inverted = operational_data_6_1_cleaned(permutation, :);
          operational_data_6_1_cleaned_inverted(:, 2) = 1 ./ operational_data_6_1_cleaned_inverted(:, 2);
          
          permutation = randperm (size (operational_data_6_2_cleaned, 1));
          operational_data_6_2_cleaned_inverted = operational_data_6_2_cleaned(permutation, :);
          operational_data_6_2_cleaned_inverted(:, 2) = 1 ./ operational_data_6_2_cleaned_inverted(:, 2);

          permutation = randperm (size (operational_data_8_1_cleaned, 1));
          operational_data_8_1_cleaned_inverted = operational_data_8_1_cleaned(permutation, :);
          operational_data_8_1_cleaned_inverted(:, 2) = 1 ./ operational_data_8_1_cleaned_inverted(:, 2);
          
          permutation = randperm (size (operational_data_8_2_cleaned, 1));
          operational_data_8_2_cleaned_inverted = operational_data_8_2_cleaned(permutation, :);
          operational_data_8_2_cleaned_inverted(:, 2) = 1 ./ operational_data_8_2_cleaned_inverted(:, 2);
          
          permutation = randperm (size (operational_data_9_cleaned, 1));
          operational_data_9_cleaned_inverted = operational_data_9_cleaned(permutation, :);
          operational_data_9_cleaned_inverted(:, 2) = 1 ./ operational_data_9_cleaned_inverted(:, 2);
          
          permutation = randperm (size (operational_data_10_cleaned, 1));
          operational_data_10_cleaned_inverted = operational_data_10_cleaned(permutation, :);
          operational_data_10_cleaned_inverted(:, 2) = 1 ./ operational_data_10_cleaned_inverted(:, 2);
          
          permutation = randperm (size (operational_data_12_1_cleaned, 1));
          operational_data_12_1_cleaned_inverted = operational_data_12_1_cleaned(permutation, :);
          operational_data_12_1_cleaned_inverted(:, 2) = 1 ./ operational_data_12_1_cleaned_inverted(:, 2);
          
          permutation = randperm (size (operational_data_12_2_cleaned, 1));
          operational_data_12_2_cleaned_inverted = operational_data_12_2_cleaned(permutation, :);
          operational_data_12_2_cleaned_inverted(:, 2) = 1 ./ operational_data_12_2_cleaned_inverted(:, 2);
          
          permutation = randperm (size (operational_data_15_cleaned, 1));
          operational_data_15_cleaned_inverted = operational_data_15_cleaned(permutation, :);
          operational_data_15_cleaned_inverted(:, 2) = 1 ./ operational_data_15_cleaned_inverted(:, 2);
          
          permutation = randperm (size (operational_data_16_cleaned, 1));
          operational_data_16_cleaned_inverted = operational_data_16_cleaned(permutation, :);
          operational_data_16_cleaned_inverted(:, 2) = 1 ./ operational_data_16_cleaned_inverted(:, 2);
          
          permutation = randperm (size (operational_data_20_cleaned, 1));
          operational_data_20_cleaned_inverted = operational_data_20_cleaned(permutation, :);
          operational_data_20_cleaned_inverted(:, 2) = 1 ./ operational_data_20_cleaned_inverted(:, 2);
          
          no_of_iterations = min([length(operational_data_2_cleaned_inverted) length(operational_data_3_cleaned_inverted) length(operational_data_4_1_cleaned_inverted) length(operational_data_4_2_cleaned_inverted) length(operational_data_5_cleaned_inverted) length(operational_data_6_1_cleaned_inverted) length(operational_data_6_2_cleaned_inverted) length(operational_data_8_1_cleaned_inverted) length(operational_data_8_2_cleaned_inverted) length(operational_data_9_cleaned_inverted) length(operational_data_10_cleaned_inverted) length(operational_data_12_1_cleaned_inverted) length(operational_data_12_2_cleaned_inverted) length(operational_data_15_cleaned_inverted) length(operational_data_16_cleaned_inverted) length(operational_data_20_cleaned_inverted) ]);
          loop = 0;
          count = 0;
          for ii = 1: no_of_iterations
            innerCount = 0;
            %if ( configuration_to_predict == 12 )
              current_chunk = [operational_data_3_cleaned_inverted(ii, :) ; (operational_data_4_1_cleaned_inverted(ii, :) + operational_data_4_2_cleaned_inverted(ii, :))/2 ; operational_data_5_cleaned_inverted(ii, :) ; (operational_data_6_1_cleaned_inverted(ii, :) + operational_data_6_2_cleaned_inverted(ii, :))/2 ; (operational_data_8_1_cleaned_inverted(ii, :) + operational_data_8_2_cleaned_inverted(ii, :))/2 ; operational_data_9_cleaned_inverted(ii, :) ; operational_data_10_cleaned_inverted(ii, :) ; (operational_data_12_1_cleaned_inverted(ii, :) + operational_data_12_2_cleaned_inverted(ii, :))/2 ; operational_data_15_cleaned_inverted(ii, :) ; operational_data_16_cleaned_inverted(ii, :) ; operational_data_20_cleaned_inverted(ii, :) ; ];
            %endif
  
            % =============================== Pure ML Approach =============================================
            % ==============================================================================================            
            % New set of operational data is merged into the KB.
            [ml_current_KB] = updateKB_merge(ml_current_KB, current_chunk);
            
            % We want to keep tack of the best value of error we ever had during current iteration,
            % so we set its initial value to infinite.
            ml_theBestTrErrors = Inf;
            do
                
                % the KB is shuffled randomly.
                ml_permutation = randperm (size(ml_current_KB, 1));
                ml_current_KB_shuffled_NotScaled = ml_current_KB(ml_permutation, :);

                % the KB is scaled. ml_mu and ml_sigma are the average and standard deviation
                % of KB data before scaling.
                [ml_current_KB_shuffled, ml_mu, ml_sigma] = zscore(ml_current_KB_shuffled_NotScaled);
                % The avg and std of X and Y axes before scaling are kept separately to 
                % be used for restoring initial values.
                ml_mu_y = ml_mu(1);
                ml_mu_X = ml_mu(2);
                ml_sigma_y = ml_sigma(1);
                ml_sigma_X = ml_sigma(2);
                
                % The full configuration is transformed according to scaling.
                ml_full_configurations_scaled = ((1 ./ full_configurations) - ml_mu_X) / ml_sigma_X;

                % The scaled KB is divided into three disjoint sets called train set, test set,
                % and cross validation set, based on train_frac and test_frac variables.
                ml_y = ml_current_KB_shuffled(:, 1);
                ml_X = ml_current_KB_shuffled(:, 2);
                [ml_ytr, ml_ytst, ml_ycv] = split_sample (ml_y, train_frac, test_frac);
                [ml_Xtr, ml_Xtst, ml_Xcv] = split_sample (ml_X, train_frac, test_frac);
     
                % Different models are trained and the one which minimizes the MSE error on CV set is selected
                % and its corresponding C and eps values are returned.
                [ml_C, ml_eps] = modelSelection (ml_ytr, ml_Xtr, ml_ycv, ml_Xcv, conf_linear, C_range, E_range);
                ml_options = [conf_linear, " -p ", num2str(ml_eps), " -c ", num2str(ml_C)];
                % The selected model is retrained.
                ml_model = svmtrain (ml_ytr, ml_Xtr, ml_options);
                
                % The prediction of ml_model on scaled version of our full configuration is obtained
                [ml_predictions_linear{ii+1}, ~, ~] = svmpredict (full_scaled.', ml_full_configurations_scaled.', ml_model);
                % The prediction is used to compute MRE of available points using computeRE function
                ml_availableErrors = computeRE_2(ml_predictions_linear{ii+1}, ml_sigma_y, ml_mu_y, avg_time_query_vector, configuration_to_predict);
                % The prediction is used to compute MRE of missing points using computeVE function
                ml_missingErrors = computeVE_2(ml_predictions_linear{ii+1}, ml_sigma_y, ml_mu_y, avg_time_query_vector, configuration_to_predict);
               
                % The prediction of ml_model on scaled version of CV set is obtained and its corresponding MRE is computed
                [ml_cvPred, ~, ~] = svmpredict (ml_ycv, ml_Xcv, ml_model);
                ml_cvIterationErrors = 0;
                for jj = 1: length(ml_Xcv)
                  ml_cvIterationErrors += 100*abs((ml_cvPred(jj)*ml_sigma_y+ml_mu_y) - (ml_ycv(jj)*ml_sigma_y+ml_mu_y))/(ml_ycv(jj)*ml_sigma_y+ml_mu_y);
                endfor
                ml_cvErrors = ml_cvIterationErrors/length(ml_Xcv);

                % The prediction of ml_model on scaled version of train set is obtained and its corresponding MRE is computed
                [ml_trPred, ~, ~] = svmpredict (ml_ytr, ml_Xtr, ml_model);
                ml_trIterationErrors = 0;
                for jj = 1: length(ml_Xtr)
                   ml_trIterationErrors += 100*abs((ml_trPred(jj)*ml_sigma_y+ml_mu_y) - (ml_ytr(jj)*ml_sigma_y+ml_mu_y))/(ml_ytr(jj)*ml_sigma_y+ml_mu_y);
                endfor
                ml_trErrors = ml_trIterationErrors/length(ml_Xtr);

                % The prediction of ml_model on scaled version of test set is obtained and its corresponding MRE is computed
                [ml_tstPred, ~, ~] = svmpredict (ml_ytst, ml_Xtst, ml_model);
                ml_tstIterationErrors = 0;
                for jj = 1: length(ml_Xtst)
                   ml_tstIterationErrors += 100*abs((ml_tstPred(jj)*ml_sigma_y+ml_mu_y) - (ml_ytst(jj)*ml_sigma_y+ml_mu_y))/(ml_ytst(jj)*ml_sigma_y+ml_mu_y);
                endfor
                ml_tstErrors = ml_tstIterationErrors/length(ml_Xtst);
               
               % Save the current model if it is the best one during this iteration until now
               if (ml_trErrors < ml_theBestTrErrors) 
                  ml_theBestModel = ml_model;
                  ml_theBestCvErrors = ml_cvErrors;
                  ml_theBestTrErrors = ml_trErrors;
                  ml_theBestTstErrors = ml_tstErrors;
                  ml_theBestAvailableErrors = ml_availableErrors
                  ml_theBestMissingErrors = ml_missingErrors
               endif
               innerCount += 1;
               % Restore the best model of the current iteration if the number of inner loops reaches a max value say 10. 
               % Then exit this iteration.
               if (innerCount > 10)
                  ml_cvErrors = ml_theBestCvErrors;
                  ml_trErrors = ml_theBestTrErrors;
                  ml_tstErrors = ml_theBestTstErrors;
                  ml_availableErrors = ml_theBestAvailableErrors;
                  ml_missingErrors = ml_theBestMissingErrors;
                  loop = 1;
                  break;
               endif
            % Next iteration condition: to check whether we should proceed to the next iteration or not
            until (ml_trErrors < itrThr && ml_tstErrors < itrThr) 
            count += innerCount;
            % Stop condition: to check whether we should stop the whole iterative process or not
            if (ml_trErrors < stopThr && ml_tstErrors < stopThr)  
              stop = 1;
              break;
            else
              stop = 0;
            endif
          endfor
          % MRE of missing points       
          ml_out(4) = ml_missingErrors;
          % number of iterations
          ml_out(5) = ii;
          % number of actual loops
          ml_out(6) = count;
          % MRE of train set 
          ml_out(7) = ml_trErrors;
          % MRE of CV set 
          ml_out(8) = ml_cvErrors;
          % MRE of test set 
          ml_out(9) = ml_tstErrors;
          % Whether we break the loop of an iteration because we reach the max value or not
          ml_out(10) = loop;
          dlmwrite(ml_outPath, ml_out, "-append");
          
    endfor
  endfor    
endfor