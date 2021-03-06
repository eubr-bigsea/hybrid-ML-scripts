% This piece of code averages the error for each combination of (itrThr, stopThr) to 
% find optimum conbination of them 

clear all
close all hidden
clc
warning("off")

query = "R1";
ssize = "250";

conf = [20 40 48 60 72 80 90 100 108 120];
configuration_to_predict = 10;
base_dir = "../source_data/";

avgPath = ["../plots/", query, "/", ssize, "/linear/missing_", num2str(conf(configuration_to_predict)), "/MLOptimumFinding/avg_ml.csv"];

for itrThr = 25 : 40
  avg(1) = itrThr;
  for stopThr = 15 : 30
    avg(2) = stopThr;
    ml_outPath = ["../plots/", query, "/", ssize, "/linear/missing_", num2str(conf(configuration_to_predict)), "/MLOptimumFinding/ml_out_", num2str(itrThr), "_", num2str(stopThr), ".csv"];
    ml_outData = read_data([ml_outPath]);
    ml_avgOutData = mean(ml_outData);
    
    avg(3) = ml_avgOutData(4);
    avg(4) = ml_avgOutData(5);
    avg(5) = ml_avgOutData(6);

    dlmwrite(avgPath, avg, "-append");
  endfor
endfor




