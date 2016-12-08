% This piece of code estimates response time for multi-user scenario 
% according to the formula used in computeAvgResTime.m function and 
% based on R queries.

% right now, the response time is only estimated for R1@250.

% inputs of this piece of code are '.csv' files in 'full' directory which are actually 
% the RUN tables gained from real experiments.

% output of this piece of code is 'estimatedResTimes.csv' file which contains the estimated response times for 
% different nCores, one per row.
clear all
close all hidden
clc
warning("off")

query = "R1";
ssize = "250";

conf = [20 40 48 60 72 80 90 100 108 120];
configuration_to_predict = 10;
base_dir = "../source_data/";

avgPath = ["../plots/", query, "/", ssize, "/linear/missing_", num2str(conf(configuration_to_predict)), "/avg.csv"];

for itrThr = 31 : 31
  avg(1) = itrThr;
  for stopThr = 21 : 21
    avg(2) = stopThr;
    ml_outPath = ["../plots/", query, "/", ssize, "/linear/missing_", num2str(conf(configuration_to_predict)), "/ml_out_", num2str(itrThr), "_", num2str(stopThr), ".csv"];
    outPath = ["../plots/", query, "/", ssize, "/linear/missing_", num2str(conf(configuration_to_predict)), "/out_", num2str(itrThr), "_", num2str(stopThr), ".csv"];
 
    ml_outData = read_data([ml_outPath]);
    outData = read_data([outPath]);
    
    ml_avgOutData = mean(ml_outData);
    avgOutData = mean(outData);
    
    avg(3) = ml_avgOutData(4);
    avg(4) = avgOutData(4);
    
    avg(5) = ml_avgOutData(5);
    avg(6) = avgOutData(5);
    avg(7) = avgOutData(6);

    dlmwrite(avgPath, avg, "-append");
  endfor
endfor




