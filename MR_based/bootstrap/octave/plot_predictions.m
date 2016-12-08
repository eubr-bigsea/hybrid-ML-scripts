function plot_predictions(query, sszie, model, missing_configuration, iteration, predictions, expected,added_sample)
%% save plots

x = [20 40 48 60 72 80 90 100 108 120];
full_x = x; 

if (added_sample==0)
  filepath = ["../plots/" query "/" sszie "/" model "/missing_" missing_configuration "/PredictionExpectedValues_" iteration ".eps"]
  h1 = plot(full_x, predictions,'-dr', x, expected, ':g');
  %title([query "/" sszie "/" model "/missing " missing_configuration "/Prediction and Expected Values " iteration]);
  legend ("train set", "test set", "CV set", "analytical values", "predicted values","mean values of real data");
else
  filepath = ["../plots/" query "/" sszie "/" model "/missing_" missing_configuration "/PredictionExpectedAddedValues_" iteration ".eps"]
  h1 = plot(full_x, predictions, '-dr', x, expected, ':g', added_sample(:,2), added_sample(:,1), '+b');
  %title([query "/" sszie "/" model "/missing " missing_configuration "/Prediction Expected and Added Values " iteration]);
  legend ("train set", "test set", "CV set", "analytical values", "predicted values","mean values of real data", "last added real data");
endif

h1=figure(1);
xlabel ("Number of Cores");
ylabel ("Response Time (ms)");
set(gca, 'XTick', x); % Change x-axis ticks
opt = ["-depsc"];
print(filepath, opt);

%%Uncomment here if you want to produce the csv files
%csvwrite(filepath, [predictions expected.']);
endfunction