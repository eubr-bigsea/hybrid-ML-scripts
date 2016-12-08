function plot_predictions(query, sszie, model, missing_configuration, iteration, predictions, expected,added_sample)
%% save plots

x = [20 40 48 60 72 80 90 100 108 120];
full_x = x; 

if (added_sample==0)
  filepath = ["../plots/" query "/" sszie "/" model "/missing_" missing_configuration "/PredictionExpectedValues_" iteration ".jpg"]
  h1 = plot(full_x, predictions,'r', x, expected, 'g');
  title([query "/" sszie "/" model "/missing " missing_configuration "/Prediction and Expected Values " iteration]);
  legend ("Train Set", "Test Set", "CV Set", "Simulation Values", "Prediction Curve","Expected Values");
else
  filepath = ["../plots/" query "/" sszie "/" model "/missing_" missing_configuration "/PredictionExpectedAddedValues_" iteration ".jpg"]
  h1 = plot(full_x, predictions, 'r', x, expected, 'g', added_sample(:,2), added_sample(:,1), '+b');
  title([query "/" sszie "/" model "/missing " missing_configuration "/Prediction Expected and Added Values " iteration]);
  legend ("Train Set", "Test Set", "CV Set", "Simulation Values", "Prediction Curve","Expected Values","Added Values");
endif

h1=figure(1);
xlabel ("Configuration of Cores");
ylabel ("Response Time");
set(gca, 'XTick', x); % Change x-axis ticks
opt = ["-djpg"];
print(filepath, opt);

%%Uncomment here if you want to produce the csv files
%csvwrite(filepath, [predictions expected.']);
endfunction