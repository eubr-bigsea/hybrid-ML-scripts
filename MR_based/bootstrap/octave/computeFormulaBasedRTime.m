% This piece of code estimates response time for sngle-user scenario 
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

query_operational_data_20 = ["full/" query "/" ssize "/20.csv"];
query_operational_data_40 = ["full/" query "/" ssize "/40.csv"];
query_operational_data_48 = ["full/" query "/" ssize "/48.csv"];
query_operational_data_60 = ["full/" query "/" ssize "/60.csv"];
query_operational_data_72 = ["full/" query "/" ssize "/72.csv"];
query_operational_data_80 = ["full/" query "/" ssize "/80.csv"];
query_operational_data_90 = ["full/" query "/" ssize "/90.csv"];
query_operational_data_100 = ["full/" query "/" ssize "/100.csv"];
query_operational_data_108 = ["full/" query "/" ssize "/108.csv"];
query_operational_data_120 = ["full/" query "/" ssize "/120.csv"];

base_dir = "../source_data/";

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

x = operational_data_20;
avgResTime(1) = computeAvgResTime(x);

x = operational_data_40;
avgResTime(2) = computeAvgResTime(x);

x = operational_data_48;
avgResTime(3) = computeAvgResTime(x);

x = operational_data_60;
avgResTime(4) = computeAvgResTime(x);

x = operational_data_72;
avgResTime(5) = computeAvgResTime(x);

x = operational_data_80;
avgResTime(6) = computeAvgResTime(x);

x = operational_data_90;
avgResTime(7) = computeAvgResTime(x);

x = operational_data_100;
avgResTime(8) = computeAvgResTime(x);

x = operational_data_108;
avgResTime(9) = computeAvgResTime(x);

x = operational_data_120;
avgResTime(10) = computeAvgResTime(x);

plot(conf, avgResTime, 'c');

data = [conf; avgResTime];
data = rot90(rot90(rot90(data)));
path = [base_dir, "full/", query, "/", ssize, "/estimatedResTimes.csv"];
dlmwrite(path, data);




