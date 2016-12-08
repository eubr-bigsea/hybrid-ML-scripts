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

estimatedResTimesFile  = ["full/" query "/" ssize "/estimatedResTimes.csv"];
threeUserRTimesFile = ["full/" query "/" ssize "/JMTRTimes_3users.csv"];
fourUserRTimesFile = ["full/" query "/" ssize "/JMTRTimes_4users.csv"];
fiveUserRTimesFile = ["full/" query "/" ssize "/JMTRTimes_5users.csv"];

base_dir = "../source_data/";

estimatedResTimesData = read_data([base_dir estimatedResTimesFile]);
threeUserRTimesData = read_data([base_dir threeUserRTimesFile]);
fourUserRTimesData = read_data([base_dir fourUserRTimesFile]);
fiveUserRTimesData = read_data([base_dir fiveUserRTimesFile]);

x1 = estimatedResTimesData;
x3 = threeUserRTimesData;
x4 = fourUserRTimesData;
x5 = fiveUserRTimesData;

h = plot(conf, x1, 'c', conf , x3, 'r', conf, x4, 'g', conf, x5, 'b');
legend ("estimated 1 User RTimes", "3 Users RTimes", "4 Users RTimes", "5 Users RTimes");
xlabel ("nCores");
ylabel ("Response Time");
opt = ["-djpg"];
filepath  = ["../source_data/full/" query "/" ssize "/plot.jpg"];
print(filepath, opt);




