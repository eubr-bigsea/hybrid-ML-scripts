clear all
close all hidden
clc
warning("off")

%% Input data parameters: path to folder containing 
%% the analytical data and to folder containing 
%% the operational data.
query = "R1";
ssize = "250";
configuration_to_predict = 10;

preTextPosition = 70000;
pveTextPosition = 2*preTextPosition/3;
%errorCoef = 40;

%for R1:
opr_configurations = [20 40 48 60 72 80 90 100 108 120];
sim_configurations = [20 40 48 60 72 80 90 100 108 120];

full_configurations = [20 40 48 60 72 80 90 100 108 120];
full_scaled = [1 1 1 1 1 1 1 1 1 1];
%----------------------------------------------------------------------------------------------

conf_linear = "-s 3 -t 0 -q -h 0 ";

query_analytical_data = ["full/" query "/" ssize "/estimatedResTimes.csv"];
query_operational_data_20 = ["oper/" query "/" ssize "/dataOper_20.csv"];
query_operational_data_40 = ["oper/" query "/" ssize "/dataOper_40.csv"];
query_operational_data_48 = ["oper/" query "/" ssize "/dataOper_48.csv"];
query_operational_data_60 = ["oper/" query "/" ssize "/dataOper_60.csv"];
query_operational_data_72 = ["oper/" query "/" ssize "/dataOper_72.csv"];
query_operational_data_80 = ["oper/" query "/" ssize "/dataOper_80.csv"];
query_operational_data_90 = ["oper/" query "/" ssize "/dataOper_90.csv"];
query_operational_data_100 = ["oper/" query "/" ssize "/dataOper_100.csv"];
query_operational_data_108 = ["oper/" query "/" ssize "/dataOper_108.csv"];
query_operational_data_120 = ["oper/" query "/" ssize "/dataOper_120.csv"];

base_dir = "../source_data/";

analytical_data = read_data([base_dir query_analytical_data]);
sim_results = analytical_data(:, 1);
sim_results = sim_results(:)';

operational_data_20 = read_data([base_dir query_operational_data_20]);
operational_data_40 = read_data([base_dir query_operational_data_40]);
operational_data_48 = read_data([base_dir query_operational_data_48]);
operational_data_60 = read_data([base_dir query_operational_data_60]);
operational_data_72 = read_data([base_dir query_operational_data_72]);
operational_data_80 = read_data([base_dir query_operational_data_80]);
operational_data_90 = read_data([base_dir query_operational_data_90]);
operational_data_100 = read_data([base_dir query_operational_data_100]);
operational_data_108 = read_data([base_dir query_operational_data_108]);
operational_data_120 = read_data([base_dir query_operational_data_120]);

[operational_data_20_cleaned, ~] = clear_outliers (operational_data_20);
[operational_data_40_cleaned, ~] = clear_outliers (operational_data_40);
[operational_data_48_cleaned, ~] = clear_outliers (operational_data_48);
[operational_data_60_cleaned, ~] = clear_outliers (operational_data_60);
[operational_data_72_cleaned, ~] = clear_outliers (operational_data_72);
[operational_data_80_cleaned, ~] = clear_outliers (operational_data_80);
[operational_data_90_cleaned, ~] = clear_outliers (operational_data_90);
[operational_data_100_cleaned, ~] = clear_outliers (operational_data_100);
[operational_data_108_cleaned, ~] = clear_outliers (operational_data_108);
[operational_data_120_cleaned, ~] = clear_outliers (operational_data_120);

% EHSAN: recomputing avg_time_query_vector at runtime to be sure of the old values
avg_time_query_vector = [(mean(operational_data_20_cleaned))(1) (mean(operational_data_40_cleaned))(1) (mean(operational_data_48_cleaned))(1) (mean(operational_data_60_cleaned))(1) (mean(operational_data_72_cleaned))(1) (mean(operational_data_80_cleaned))(1) (mean(operational_data_90_cleaned))(1) (mean(operational_data_100_cleaned))(1) (mean(operational_data_108_cleaned))(1) (mean(operational_data_120_cleaned))(1)];

%% Splitting parameters
train_frac = 0.6;
test_frac = 0.2

%% Ranges to be used to the identification
%% of the optimal "C" and "epsilon" parameter of the SVR
%% when using epsilon-SVR ( the SVR type used by Eugenio.
%% we could investigate if it makes sense to try nu-SVR too ).
C_range = linspace (0.1, 5, 20);
E_range = linspace (0.1, 5, 20);

for itrThr = 30 : 30
  ml_out(1) = itrThr;
  for stopThr = 19 : 19
    ml_out(2) = stopThr; 

    ml_outPath = ["../plots/", query, "/", ssize, "/linear/missing_", num2str(opr_configurations(configuration_to_predict)), "/MLExtrapolate/48/ml_out_", num2str(itrThr), "_", num2str(stopThr), ".csv"];
    
    header(1) = 1;
    header(2) = 1;
    header(3) = 1;
    header(4) = 1;
    header(5) = 1;
    header(6) = 1;
    header(7) = 1;
    header(8) = 1;
    dlmwrite(ml_outPath, header);

    for seed = 101 : 150
           ml_out(3) = seed;
          rand ("seed", "reset");
          rand ("seed", seed);

          ml_current_KB = [];
 
          % EHSAN: inversing the X values while SHUFFLING IS BEING APPLIED **********************
          permutation = randperm (size (operational_data_20_cleaned, 1));
          operational_data_20_cleaned_inverted = operational_data_20_cleaned(permutation, :);
          operational_data_20_cleaned_inverted(:, 2) = 1 ./ operational_data_20_cleaned_inverted(:, 2);

          permutation = randperm (size (operational_data_40_cleaned, 1));
          operational_data_40_cleaned_inverted = operational_data_40_cleaned(permutation, :);
          operational_data_40_cleaned_inverted(:, 2) = 1 ./ operational_data_40_cleaned_inverted(:, 2);
          
          permutation = randperm (size (operational_data_48_cleaned, 1));
          operational_data_48_cleaned_inverted = operational_data_48_cleaned(permutation, :);
          operational_data_48_cleaned_inverted(:, 2) = 1 ./ operational_data_48_cleaned_inverted(:, 2);

          permutation = randperm (size (operational_data_60_cleaned, 1));
          operational_data_60_cleaned_inverted = operational_data_60_cleaned(permutation, :);
          operational_data_60_cleaned_inverted(:, 2) = 1 ./ operational_data_60_cleaned_inverted(:, 2);

          permutation = randperm (size (operational_data_72_cleaned, 1));
          operational_data_72_cleaned_inverted = operational_data_72_cleaned(permutation, :);
          operational_data_72_cleaned_inverted(:, 2) = 1 ./ operational_data_72_cleaned_inverted(:, 2);
          
          permutation = randperm (size (operational_data_80_cleaned, 1));
          operational_data_80_cleaned_inverted = operational_data_80_cleaned(permutation, :);
          operational_data_80_cleaned_inverted(:, 2) = 1 ./ operational_data_80_cleaned_inverted(:, 2);
          
          permutation = randperm (size (operational_data_90_cleaned, 1));
          operational_data_90_cleaned_inverted = operational_data_90_cleaned(permutation, :);
          operational_data_90_cleaned_inverted(:, 2) = 1 ./ operational_data_90_cleaned_inverted(:, 2);
          
          permutation = randperm (size (operational_data_100_cleaned, 1));
          operational_data_100_cleaned_inverted = operational_data_100_cleaned(permutation, :);
          operational_data_100_cleaned_inverted(:, 2) = 1 ./ operational_data_100_cleaned_inverted(:, 2);
          
          permutation = randperm (size (operational_data_108_cleaned, 1));
          operational_data_108_cleaned_inverted = operational_data_108_cleaned(permutation, :);
          operational_data_108_cleaned_inverted(:, 2) = 1 ./ operational_data_108_cleaned_inverted(:, 2);
          
          permutation = randperm (size (operational_data_120_cleaned, 1));
          operational_data_120_cleaned_inverted = operational_data_120_cleaned(permutation, :);
          operational_data_120_cleaned_inverted(:, 2) = 1 ./ operational_data_120_cleaned_inverted(:, 2);
          
          no_of_iterations = min([length(operational_data_20_cleaned_inverted) length(operational_data_40_cleaned_inverted) length(operational_data_48_cleaned_inverted) length(operational_data_60_cleaned_inverted) length(operational_data_72_cleaned_inverted) length(operational_data_80_cleaned_inverted) length(operational_data_90_cleaned_inverted) length(operational_data_100_cleaned_inverted) length(operational_data_108_cleaned_inverted) length(operational_data_120_cleaned_inverted)]);
          loop = 0;
          count = 0;
          for ii = 1: no_of_iterations
            innerCount = 0;
            if ( configuration_to_predict == 10 )
              current_chunk = [operational_data_60_cleaned_inverted(ii, :) ; operational_data_72_cleaned_inverted(ii, :) ; operational_data_80_cleaned_inverted(ii, :) ; operational_data_90_cleaned_inverted(ii, :) ; operational_data_100_cleaned_inverted(ii, :) ; operational_data_108_cleaned_inverted(ii, :) ; operational_data_120_cleaned_inverted(ii, :) ;];
            endif

            % =============================== first: Pure ML Approach =============================================
            % ======================================================================================================            

            [ml_current_KB] = updateKB_merge(ml_current_KB, current_chunk);
               
            ml_theBestTrErrors = 1000;
            do
                ml_permutation = randperm (size(ml_current_KB, 1));
                ml_current_KB_shuffled_NotScaled = ml_current_KB(ml_permutation, :);

                %% =============== SCALING ================
                [ml_current_KB_shuffled, ml_mu, ml_sigma] = zscore(ml_current_KB_shuffled_NotScaled);
                ml_mu_y = ml_mu(1);
                ml_mu_X = ml_mu(2);
                ml_sigma_y = ml_sigma(1);
                ml_sigma_X = ml_sigma(2);
                
                ml_avg_time_query_vector_scaled = (avg_time_query_vector - ml_mu_y) / ml_sigma_y;
                ml_opr_configurations_scaled = ((1 ./ opr_configurations) - ml_mu_X) / ml_sigma_X;
                ml_full_configurations_scaled = ((1 ./ full_configurations) - ml_mu_X) / ml_sigma_X;

                ml_y = ml_current_KB_shuffled(:, 1);
                ml_X = ml_current_KB_shuffled(:, 2);
                [ml_ytr, ml_ytst, ml_ycv] = split_sample (ml_y, train_frac, test_frac);
                [ml_Xtr, ml_Xtst, ml_Xcv] = split_sample (ml_X, train_frac, test_frac);
     
                %% =========== retraining Linear kernel model =========
                [ml_C, ml_eps] = modelSelection (ml_ytr, ml_Xtr, ml_ycv, ml_Xcv, conf_linear, C_range, E_range);
                ml_options = [conf_linear, " -p ", num2str(ml_eps), " -c ", num2str(ml_C)];
                ml_model = svmtrain (ml_ytr, ml_Xtr, ml_options);
      
                [ml_predictions_linear{ii+1}, ~, ~] = svmpredict (full_scaled.', ml_full_configurations_scaled.', ml_model);
                ml_availableErrors = computeRE_20_40_48(ml_predictions_linear{ii+1}, ml_sigma_y, ml_mu_y, avg_time_query_vector, configuration_to_predict);
                ml_missingErrors = computeVE_20_40_48(ml_predictions_linear{ii+1}, ml_sigma_y, ml_mu_y, avg_time_query_vector, configuration_to_predict);
               
                [ml_cvPred, ~, ~] = svmpredict (ml_ycv, ml_Xcv, ml_model);
                ml_cvIterationErrors = 0;
                for jj = 1: length(ml_Xcv)
                  ml_cvIterationErrors += 100*abs((ml_cvPred(jj)*ml_sigma_y+ml_mu_y) - (ml_ycv(jj)*ml_sigma_y+ml_mu_y))/(ml_ycv(jj)*ml_sigma_y+ml_mu_y);
                endfor
                ml_cvErrors = ml_cvIterationErrors/length(ml_Xcv);

                [ml_trPred, ~, ~] = svmpredict (ml_ytr, ml_Xtr, ml_model);
                ml_trIterationErrors = 0;
                for jj = 1: length(ml_Xtr)
                   ml_trIterationErrors += 100*abs((ml_trPred(jj)*ml_sigma_y+ml_mu_y) - (ml_ytr(jj)*ml_sigma_y+ml_mu_y))/(ml_ytr(jj)*ml_sigma_y+ml_mu_y);
                endfor
                ml_trErrors = ml_trIterationErrors/length(ml_Xtr);
               
                [ml_tstPred, ~, ~] = svmpredict (ml_ytst, ml_Xtst, ml_model);
                ml_tstIterationErrors = 0;
                for jj = 1: length(ml_Xtst)
                   ml_tstIterationErrors += 100*abs((ml_tstPred(jj)*ml_sigma_y+ml_mu_y) - (ml_ytst(jj)*ml_sigma_y+ml_mu_y))/(ml_ytst(jj)*ml_sigma_y+ml_mu_y);
                endfor
                ml_tstErrors = ml_tstIterationErrors/length(ml_Xtst);
               
               if (ml_trErrors < ml_theBestTrErrors) 
                  ml_theBestModel = ml_model;
                  ml_theBestCvErrors = ml_cvErrors;
                  ml_theBestTrErrors = ml_trErrors;
                  ml_theBestTstErrors = ml_tstErrors;
                  ml_theBestAvailableErrors = ml_availableErrors
                  ml_theBestMissingErrors = ml_missingErrors
               endif
               
               innerCount += 1;
               if (innerCount > 10)
                  ml_cvErrors = ml_theBestCvErrors;
                  ml_trErrors = ml_theBestTrErrors;
                  ml_tstErrors = ml_theBestTstErrors;
                  ml_availableErrors = ml_theBestAvailableErrors;
                  ml_missingErrors = ml_theBestMissingErrors;
                  loop = 1;
                  break;
               endif
   
            until (ml_trErrors < itrThr && ml_tstErrors < itrThr) 
            count += innerCount;
            
            if (ml_trErrors < stopThr && ml_tstErrors < stopThr)  
              stop = 1;
              break;
            else
              stop = 0;
            endif
          endfor
%{            
            % =============================== second: ML Approach based on AM data =================================
            % ======================================================================================================            
            [current_KB] = updateKB_merge(current_KB, current_chunk);
            
            theBestTrErrors = 1000;
            do
                permutation = randperm (size(current_KB, 1));
                current_KB_shuffled_NotScaled = current_KB(permutation, :);

                %% =============== SCALING ================
                [current_KB_shuffled, mu, sigma] = zscore(current_KB_shuffled_NotScaled);
                mu_y = mu(1);
                mu_X = mu(2);
                sigma_y = sigma(1);
                sigma_X = sigma(2);
                
                avg_time_query_vector_scaled = (avg_time_query_vector - mu_y) / sigma_y;
                opr_configurations_scaled = ((1 ./ opr_configurations) - mu_X) / sigma_X;
                full_configurations_scaled = ((1 ./ full_configurations) - mu_X) / sigma_X;

                y = current_KB_shuffled(:, 1);
                X = current_KB_shuffled(:, 2);
                [ytr, ytst, ycv] = split_sample (y, train_frac, test_frac);
                [Xtr, Xtst, Xcv] = split_sample (X, train_frac, test_frac);

                %% =========== retraining Linear kernel model =========
                [C, eps] = modelSelection (ytr, Xtr, ycv, Xcv, conf_linear, C_range, E_range);
                options = [conf_linear, " -p ", num2str(eps), " -c ", num2str(C)];
                model = svmtrain (ytr, Xtr, options);
                
               [predictions_linear{ii+1}, ~, ~] = svmpredict (full_scaled.', full_configurations_scaled.', model);
               availableErrors = computeRE(predictions_linear{ii+1}, sigma_y, mu_y, avg_time_query_vector, configuration_to_predict);
               missingErrors = computeVE(predictions_linear{ii+1}, sigma_y, mu_y, avg_time_query_vector, configuration_to_predict);
               
               [cvPred, ~, ~] = svmpredict (ycv, Xcv, model);
               cvIterationErrors = 0;
               for jj = 1: length(Xcv)
                  cvIterationErrors += 100*abs((cvPred(jj)*sigma_y+mu_y) - (ycv(jj)*sigma_y+mu_y))/(ycv(jj)*sigma_y+mu_y);
               endfor
               cvErrors = cvIterationErrors/length(Xcv);

               [trPred, ~, ~] = svmpredict (ytr, Xtr, model);
               trIterationErrors = 0;
               for jj = 1: length(Xtr)
                  trIterationErrors += 100*abs((trPred(jj)*sigma_y+mu_y) - (ytr(jj)*sigma_y+mu_y))/(ytr(jj)*sigma_y+mu_y);
               endfor
               trErrors = trIterationErrors/length(Xtr);
               
               [tstPred, ~, ~] = svmpredict (ytst, Xtst, model);
               tstIterationErrors = 0;
               for jj = 1: length(Xtst)
                  tstIterationErrors += 100*abs((tstPred(jj)*sigma_y+mu_y) - (ytst(jj)*sigma_y+mu_y))/(ytst(jj)*sigma_y+mu_y);
               endfor
               tstErrors = tstIterationErrors/length(Xtst);

               
               if (trErrors < theBestTrErrors) 
                  theBestModel = model;
                  theBestCvErrors = cvErrors;
                  theBestTrErrors = trErrors;
                  theBestTstErrors = tstErrors;
                  theBestAvailableErrors = availableErrors
                  theBestMissingErrors = missingErrors
               endif
               
               innerCount += 1;
               if (innerCount > 10)
                  cvErrors = theBestCvErrors;
                  trErrors = theBestTrErrors;
                  tstErrors = theBestTstErrors;
                  availableErrors = theBestAvailableErrors;
                  missingErrors = theBestMissingErrors;
                  loop = 1;
                  break;
               endif
   
            until (trErrors < itrThr && tstErrors < itrThr) 
            count += innerCount;
            
            if (trErrors < stopThr && tstErrors < stopThr)  
              stop = 1;
              break;
            else
              stop = 0;
            endif
           endfor

          out(4) = missingErrors;
          out(5) = ii;
          out(6) = count;
          out(7) = trErrors;
          out(8) = cvErrors;
          out(9) = tstErrors;
          out(10) = loop;
          dlmwrite(outPath, out, "-append");
%}          
          ml_out(4) = ml_missingErrors;
          ml_out(5) = ii;
          ml_out(6) = count;
          ml_out(7) = ml_trErrors;
          ml_out(8) = ml_cvErrors;
          ml_out(9) = ml_tstErrors;
          ml_out(10) = loop;
          dlmwrite(ml_outPath, ml_out, "-append");
          
    endfor
  endfor    
endfor