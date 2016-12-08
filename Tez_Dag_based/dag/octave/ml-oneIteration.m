clear all
close all hidden
clc
warning("off")

query = "R1";
ssize = "250";
configuration_to_predict = 10;


preTextPosition = 240000;
pveTextPosition = 2*preTextPosition/3;
%errorCoef = 40;

%for R1:
opr_configurations = [20 40 48 60 72 80 90 100 108 120];
sim_configurations = [20 40 48 60 72 80 90 100 108 120];

full_configurations = [20 40 48 60 72 80 90 100 108 120];
full_scaled = [1 1 1 1 1 1 1 1 1 1];
%----------------------------------------------------------------------------------------------

conf_linear = "-s 3 -t 0 -q -h 0 ";

query_analytical_data = ["analyt/" query "/" ssize "/dataAM.csv"];
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

oper_weight_value = 10;
analyt_weight_value = 1;

C_range = linspace (0.1, 5, 20);
E_range = linspace (0.1, 5, 20);

% Useless, just is put to prevent error on wieght variables
analytical_sample = initKB (analytical_data);
weight=ones(size(analytical_sample,1),1) * analyt_weight_value;
rand ("seed", 17);

%% ================================== Start of Sole Iteration ======================================
current_weight = weight

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


  if ( configuration_to_predict == 10 )
    current_KB = [operational_data_20_cleaned; operational_data_40_cleaned; operational_data_48_cleaned; operational_data_60_cleaned; operational_data_72_cleaned; operational_data_80_cleaned; operational_data_90_cleaned; operational_data_100_cleaned; operational_data_108_cleaned];
  endif
      
      permutation = randperm (size(current_KB, 1));

      current_KB_shuffled_NotScaled = current_KB(permutation, :);
      %current_weight_shuffled = current_weight(permutation);

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
      %[Wtr, Wtst, Wcv] = split_sample (current_weight_shuffled, train_frac, test_frac);
     

      %% =========== retraining Linear kernel model =========
      ii = 0;
      printf("Re-training (%d) the SVR from on operational model (linear kernel).", ii);
      % Wtr is useless, but it should have a value anyway!
      Wtr = 0;
      [C, eps] = modelSelection (Wtr, ytr, Xtr, ycv, Xcv, conf_linear, C_range, E_range);
      options = [conf_linear, " -p ", num2str(eps), " -c ", num2str(C)];
      model_linear = svmtrain (ytr, Xtr, options);
      
     [predictions_linear{ii+1}, ~, ~] = svmpredict (full_scaled.', full_configurations_scaled.', model_linear);

     plot(1 ./ (Xtr*sigma_X+mu_X), ytr*sigma_y+mu_y, 'ok');
     

     PRE = computeRE(predictions_linear{ii+1}, sigma_y, mu_y, avg_time_query_vector, configuration_to_predict);
     availableErrors(ii+1) = PRE;
     preText = ["PRE: % " num2str(PRE)];
     text(5, preTextPosition, preText);
     
     PVE = computeVE(predictions_linear{ii+1}, sigma_y, mu_y, avg_time_query_vector, configuration_to_predict);
     missingErrors(ii+1) = PVE;
     
     pveText = ["PVE:  % " num2str(PVE)];
     text(5, pveTextPosition, pveText);
     hold on;
     plot(1 ./ (Xtst*sigma_X+mu_X), ytst*sigma_y+mu_y, '*m');
     hold on;
     plot(1 ./ (Xcv*sigma_X+mu_X), ycv*sigma_y+mu_y, '^g');
     hold on;
     plot(sim_configurations, sim_results, 'c');
     hold on;
     
     plot_predictions(query, ssize, "linear", num2str(opr_configurations(configuration_to_predict)), num2str(ii), predictions_linear{ii+1}*sigma_y+mu_y, avg_time_query_vector, 0);
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



errorFilePath = ["../plots/", query, "/", ssize, "/linear/missing_", num2str(opr_configurations(configuration_to_predict)), "/mlErrors.csv"];

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
