clc;
clear;
close all;

% Load the CSV file (clock signal)
data1 = readmatrix("100Hz_clock.csv");
time0 = data1(:,1);
fet_in = data1(:,2);

% Load the CSV file (Tx signal)
data = readmatrix("Tx_in.csv");
time1 = data(:,1);
Tx_in = data(:,2);

% Load the CSV file (noisy AM signal)
data = readmatrix("3.18.0.csv");  
time = data(:,1);  % Time in seconds
received_signal = data(:,2);  % Received signal (AM + interference)
interference_signal = data(:,3); % Interference signal

% LMS Filter Setup
L = 1; % Filter order
mu = 0.0000001; % Step size

% Generate LMS filter
lmsFilter = dsp.LMSFilter('Length', L, 'StepSize', mu);

% Apply LMS filter
[filter_out, err] = lmsFilter(interference_signal, received_signal);

% Compute Auto-correlation and Cross-correlation
Rax = xcorr(interference_signal, interference_signal, 'biased'); % Auto-correlation of reference
pxx = xcorr(interference_signal, received_signal, 'biased');     % Cross-correlation between reference and noisy

% Define Filter Parameters
midPoint = length(interference_signal); % Midpoint for symmetric correlations

% Extract necessary sections for the filter
RaxMatrix = toeplitz(Rax(midPoint:midPoint+L-1));
pxxVector = pxx(midPoint:midPoint+L-1);

% Compute Wiener Filter Coefficients
wienerCoefficients = RaxMatrix\pxxVector; % Solve for Wiener filter coefficients

% Apply Wiener Filter to Estimate Noise
filteredSignal = filter(wienerCoefficients, 1, interference_signal);

% Recover Desired Signal (Error Signal)
ew = received_signal - filteredSignal;

% Plot Results
figure;
subplot(4,1,1); 
plot(time0, fet_in*1e-3); 
title('FET (HT) Input');
xlabel('Time (s)');
ylabel('(V)');
xlim([0 0.04])

subplot(4,1,2); 
plot(time, interference_signal); 
title('Interference Signal (Noise)');
xlabel('Time (s)');
ylabel('(mV)');
xlim([0 0.04])

subplot(4,1,3); 
plot(time, received_signal); 
title('Noisy signal (Rx. Antenna output)');  
xlabel('Time (s)');
ylabel('(mV)');
xlim([0 0.04])

subplot(4,1,4);  
plot(time, ew);
title('Filtered signal (AM signal)');
xlabel('Time (s)');
ylabel('(mV)');
xlim([0 0.04])
