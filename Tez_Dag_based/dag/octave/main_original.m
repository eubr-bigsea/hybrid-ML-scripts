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

rand ("seed", 17);

preTextPosition = 70000;
pveTextPosition = 2*preTextPosition/3;
%errorCoef = 40;

%for R1:
opr_configurations = [20 40 48 60 72 80 90 100 108 120];
sim_configurations = [20 40 48 60 72 80 90 100 108 120];

full_configurations = [20 40 48 60 72 80 90 100 108 120];
full_scaled = [1 1 1 1 1 1 1 1 1 1];

% EHSAN: The following lines are never used because both the average vectoe and the simulation results are read and computed runtime
%{
%R1-250 done
%avg_time_query_vector = [79316.55 63576.45 49026.8 42215.55];
%sim_results=[408410 177969 186850 126612 211238 328983 80826 81659 72372 63691];

%R1-500 done
%avg_time_query_vector = [378127.4 143139.95 132383.45 91809.2];
%sim_results=[867192.9825 524759.3583 411940.9283  231545.8937 232130.7506 157504.1876];

%R1-750 done
%avg_time_query_vector = [ 389562.6 268821.25 203531.45 199234.9];
%sim_results=[1272051.282 730740.7407 551797.7528  401522.6337 308471.3376 276532.9513];

%R3-250 done
%avg_time_query_vector = [275684.25 197388.3 168209.25 143650.1];
%sim_results=[809672.1311 475436.8932 364531.8352  293030.303  268551.532  240626.5664];

%R3-500 done
%avg_time_query_vector = [1031505.95 526760.35 401827.9 303843.2];
%sim_results=[1042631.579 1042631.579 730740.7407  670272.1088 524759.3583 401522.6337];

%R3-750 done
%avg_time_query_vector = [1027329.7 791314.85 635991.05 661214.75];
%sim_results=[2931176.471 1528461.538 1042631.579  867192.9825 783650.7937 759230.7692];

%R5-250 done
%avg_time_query_vector = [25924.65 25830.7 25316.1 26072.3];
%sim_results=[1.7977E+308 1.7977E+308 1.7977E+308  1.7977E+308 1.7977E+308 1.7977E+308];

%R5-500 done
%avg_time_query_vector = [23685.9 23558.8 24619.65 25265.75];
%sim_results=[1.7977E+308 1.7977E+308 1.7977E+308  1.7977E+308 1.7977E+308 0];

%R5-750 done
%avg_time_query_vector = [24392.45 23894.75 24887.85 24882.75];
%sim_results=[1.7977E+308 1.7977E+308 1.7977E+308  0   1.7977E+308 1.7977E+308];
%}
%----------------------------------------------------------------------------------------------

conf_linear = "-s 3 -t 0 -q -h 0 ";
conf_nonlinear = "-s 3 -t 1 -d 4 -q -h 0 ";

%% 60 = 1 ; 80 = 2; 100 = 3; 120 = 4
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

% EHSAN: the following lines are brought to the top!
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

%% Initializing the Knowledge Base sampling the analytical data
analytical_sample = initKB (analytical_data);

permutation = randperm (size (analytical_sample, 1));

analytical_shuffled_NotScaled = analytical_sample(permutation, :);

%% Added by EHSAN
%% =============== SCALING ================
[analytical_shuffled, mu, sigma] = zscore(analytical_shuffled_NotScaled);
mu_y = mu(1);
mu_X = mu(2);
sigma_y = sigma(1);
sigma_X = sigma(2);

avg_time_query_vector_scaled = (avg_time_query_vector - mu_y) / sigma_y;
opr_configurations_scaled = ((1 ./ opr_configurations) - mu_X) / sigma_X;
full_configurations_scaled = ((1 ./ full_configurations) - mu_X) / sigma_X;

%% Separating prediction variables from target variable in the analytical dataset get first column in y and second in X. 
y = analytical_shuffled(:, 1);
X = analytical_shuffled(:, 2);

%% Splitting the analytical datasets
% EHSAN: CV is also catched
[ytr, ytst, ycv] = split_sample (y, train_frac, test_frac);
[Xtr, Xtst, Xcv] = split_sample (X, train_frac, test_frac);


%% ======================================== NOW SELECTING THE MODEL, TRAINING IT, AND PREDICTING OUTPUTS =======================


%% ========== Linear kernel model =========
printf("Training the SVR from on analytical model (linear kernel).")
[C, eps] = modelSelection (ytr, Xtr, ycv, Xcv, conf_linear, C_range, E_range);
options = [conf_linear, " -p ", num2str(eps), " -c ", num2str(C)];
model_linear = svmtrain (ytr, Xtr, options);

% EHSAN: added to capture a big picture view of the entire feature space
[predictions_linear{1}, ~, ~] = svmpredict (full_scaled.', full_configurations_scaled.', model_linear);

PRE = computeRE(predictions_linear{1}, sigma_y, mu_y, avg_time_query_vector, configuration_to_predict);
availableErrors(1) = PRE;
preText = ["initial PRE: % " num2str(PRE)];

PVE = computeVE(predictions_linear{1}, sigma_y, mu_y, avg_time_query_vector, configuration_to_predict);
missingErrors(1) = PVE;

plot(1 ./ (Xtr*sigma_X+mu_X), ytr*sigma_y+mu_y, 'ok');
hold on;
plot(1 ./ (Xtst*sigma_X+mu_X), ytst*sigma_y+mu_y, '*m');
text(5, preTextPosition, preText);
hold on;
plot(1 ./ (Xcv*sigma_X+mu_X), ycv*sigma_y+mu_y, '^g');
hold on;
plot(sim_configurations, sim_results, 'c');
hold on;
plot_predictions(query, ssize, "linear", num2str(opr_configurations(configuration_to_predict)), "analyt", predictions_linear{1}*sigma_y+mu_y, avg_time_query_vector,0)
hold off;

 [cvPred, ~, ~] = svmpredict (ycv, Xcv, model_linear);
 cvIterationErrors = 0;
 for jj = 1: length(Xcv)
    cvIterationErrors += 100*abs((cvPred(jj)*sigma_y+mu_y) - (ycv(jj)*sigma_y+mu_y))/(ycv(jj)*sigma_y+mu_y);
 endfor
 cvErrors(1) = cvIterationErrors/length(Xcv);
  %printf("cvErrors === %f", cvErrors(1));
 
 [trPred, ~, ~] = svmpredict (ytr, Xtr, model_linear);
 trIterationErrors = 0;
 for jj = 1: length(Xtr)
    trIterationErrors += 100*abs((trPred(jj)*sigma_y+mu_y) - (ytr(jj)*sigma_y+mu_y))/(ytr(jj)*sigma_y+mu_y);
 endfor
 trErrors(1) = trIterationErrors/length(Xtr);
 
 [tstPred, ~, ~] = svmpredict (ytst, Xtst, model_linear);
 tstIterationErrors = 0;
 for jj = 1: length(Xtst)
    tstIterationErrors += 100*abs((tstPred(jj)*sigma_y+mu_y) - (ytst(jj)*sigma_y+mu_y))/(ytst(jj)*sigma_y+mu_y);
 endfor
 tstErrors(1) = tstIterationErrors/length(Xtst);
  
 stop(1) = 0;
%% ================================== End of First Iteration ======================================

%% ================================== Start of Subsequent Iterations ======================================

% EHSAN: edited
current_KB = analytical_sample; 

% EHSAN: inversing the X values
operational_data_20_cleaned(:, 2) = 1 ./ operational_data_20_cleaned(:, 2);
operational_data_40_cleaned(:, 2) = 1 ./ operational_data_40_cleaned(:, 2);
operational_data_48_cleaned(:, 2) = 1 ./ operational_data_48_cleaned(:, 2);
operational_data_60_cleaned(:, 2) = 1 ./ operational_data_60_cleaned(:, 2);
operational_data_72_cleaned(:, 2) = 1 ./ operational_data_72_cleaned(:, 2);
operational_data_80_cleaned(:, 2) = 1 ./ operational_data_80_cleaned(:, 2);
operational_data_90_cleaned(:, 2) = 1 ./ operational_data_90_cleaned(:, 2);
operational_data_100_cleaned(:, 2) = 1 ./ operational_data_100_cleaned(:, 2);
operational_data_108_cleaned(:, 2) = 1 ./ operational_data_108_cleaned(:, 2);
operational_data_120_cleaned(:, 2) = 1 ./ operational_data_120_cleaned(:, 2);

% EHSAN: shuffling is not applied to the operational samples
no_of_iterations = min([length(operational_data_20_cleaned) length(operational_data_40_cleaned) length(operational_data_48_cleaned) length(operational_data_60_cleaned) length(operational_data_72_cleaned) length(operational_data_80_cleaned) length(operational_data_90_cleaned) length(operational_data_100_cleaned) length(operational_data_108_cleaned) length(operational_data_120_cleaned)]);
count = 0;

for ii = 1: no_of_iterations

  if ( configuration_to_predict == 10 )
    current_chunk = [operational_data_20_cleaned(ii, :) ; operational_data_40_cleaned(ii, :) ; operational_data_48_cleaned(ii, :) ; operational_data_60_cleaned(ii, :) ; operational_data_72_cleaned(ii, :) ; operational_data_80_cleaned(ii, :) ; operational_data_90_cleaned(ii, :) ; operational_data_100_cleaned(ii, :) ; operational_data_108_cleaned(ii, :) ;];
  endif

  [current_KB] = updateKB_merge(current_KB, current_chunk); 
  
  
  do
      permutation = randperm (size(current_KB, 1));

      current_KB_shuffled_NotScaled = current_KB(permutation, :);

      %% Added by EHSAN
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
     
      printf("Re-training (%d) the SVR from on operational model (linear kernel).", ii);
      [C, eps] = modelSelection (ytr, Xtr, ycv, Xcv, conf_linear, C_range, E_range);
      options = [conf_linear, " -p ", num2str(eps), " -c ", num2str(C)];
      model_linear = svmtrain (ytr, Xtr, options);
      
     [predictions_linear{ii+1}, ~, ~] = svmpredict (full_scaled.', full_configurations_scaled.', model_linear);

     plot(1 ./ (Xtr*sigma_X+mu_X), ytr*sigma_y+mu_y, 'ok');
     text(5, preTextPosition, preText);

     PRE = computeRE(predictions_linear{ii+1}, sigma_y, mu_y, avg_time_query_vector, configuration_to_predict);
     availableErrors(ii+1) = PRE;
     
     PVE = computeVE(predictions_linear{ii+1}, sigma_y, mu_y, avg_time_query_vector, configuration_to_predict);
     missingErrors(ii+1) = PVE;
     
     pveText = ["current PVE:  % " num2str(PVE)];
     text(5, pveTextPosition, pveText);
     hold on;
     plot(1 ./ (Xtst*sigma_X+mu_X), ytst*sigma_y+mu_y, '*m');
     hold on;
     plot(1 ./ (Xcv*sigma_X+mu_X), ycv*sigma_y+mu_y, '^g');
     hold on;
     plot(sim_configurations, sim_results, 'c');
     hold on;
     
     current_chunk_inverted(:, 1) = current_chunk(:, 1);
     current_chunk_inverted(:, 2) = 1 ./ current_chunk(:, 2);
     plot_predictions(query, ssize, "linear", num2str(opr_configurations(configuration_to_predict)), num2str(ii), predictions_linear{ii+1}*sigma_y+mu_y, avg_time_query_vector, current_chunk_inverted);
     hold off;
     
     [cvPred, ~, ~] = svmpredict (ycv, Xcv, model_linear);
     cvIterationErrors = 0;
     for jj = 1: length(Xcv)
        cvIterationErrors += 100*abs((cvPred(jj)*sigma_y+mu_y) - (ycv(jj)*sigma_y+mu_y))/(ycv(jj)*sigma_y+mu_y);
     endfor
     cvErrors(ii+1) = cvIterationErrors/length(Xcv);
     printf("cvErrors === %f", cvErrors(ii+1));

     [trPred, ~, ~] = svmpredict (ytr, Xtr, model_linear);
     trIterationErrors = 0;
     for jj = 1: length(Xtr)
        trIterationErrors += 100*abs((trPred(jj)*sigma_y+mu_y) - (ytr(jj)*sigma_y+mu_y))/(ytr(jj)*sigma_y+mu_y);
     endfor
     trErrors(ii+1) = trIterationErrors/length(Xtr);
     printf("trErrors === %f", trErrors(ii+1));
     
     [tstPred, ~, ~] = svmpredict (ytst, Xtst, model_linear);
     tstIterationErrors = 0;
     for jj = 1: length(Xtst)
        tstIterationErrors += 100*abs((tstPred(jj)*sigma_y+mu_y) - (ytst(jj)*sigma_y+mu_y))/(ytst(jj)*sigma_y+mu_y);
     endfor
     tstErrors(ii+1) = tstIterationErrors/length(Xtst);

     count += 1;
%  until (100*abs(trErrors(ii+1) - cvErrors(ii+1)) / trErrors(ii+1) < 40 && trErrors(ii+1) < 30) 
  until (trErrors(ii+1) < 40 && tstErrors(ii+1) < 40) 
  
%  if (100*abs(trErrors(ii+1) - cvErrors(ii+1)) / trErrors(ii+1) < 20 && trErrors(ii+1) < 25) 
  if (trErrors(ii+1) < 27 && tstErrors(ii+1) < 27)  
    stop(ii+1) = 1;
  else
    stop(ii+1) = 0;
  endif
 
endfor


errorFilePath = ["../plots/", query, "/", ssize, "/linear/missing_", num2str(opr_configurations(configuration_to_predict)), "/errors.csv"];
%errorConf = ["cv < ", num2str(errorCoef)];
%dlmwrite(errorFilePath, errorConf, "-append");

trErrorsText = ["TR"];
dlmwrite(errorFilePath, trErrorsText, "-append");
dlmwrite(errorFilePath, trErrors, "-append");

cvErrorsText = ["CV"];
dlmwrite(errorFilePath, cvErrorsText, "-append");
dlmwrite(errorFilePath, cvErrors, "-append");

tstErrorsText = ["TST"];
dlmwrite(errorFilePath, tstErrorsText, "-append");
dlmwrite(errorFilePath, tstErrors, "-append");

availableErrorsText = ["AV"];
dlmwrite(errorFilePath, availableErrorsText, "-append");
dlmwrite(errorFilePath, availableErrors, "-append");

missingErrorsText = ["MS"];
dlmwrite(errorFilePath, missingErrorsText, "-append");
dlmwrite(errorFilePath, missingErrors, "-append");

stopText = ["STOP"];
dlmwrite(errorFilePath, stopText, "-append");
dlmwrite(errorFilePath, stop, "-append");

dlmwrite(errorFilePath, count, "-append");