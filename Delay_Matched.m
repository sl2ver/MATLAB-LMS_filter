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

%% === 시간 차이 계산 ===
% 두 신호의 상관계수를 계산하여 최대값을 찾음
[corr_vals, lags] = xcorr(received_signal, interference_signal);
[~, max_index] = max(abs(corr_vals)); % 최대 상관 지점 찾기
time_shift = lags(max_index); % 시간 이동 샘플

% 샘플링 간격 계산
dt = mean(diff(time)); % 시간 간격

% 실제 시간 이동 값
time_shift_sec = time_shift * dt;

% === 시간 보정 ===
% 시간 보정을 위해 interpolation 수행
time_corrected = time - time_shift_sec;

% 새로운 보간된 신호 생성
interference_signal_interp = interp1(time_corrected, interference_signal, time, 'linear', 'extrap');

% === LMS Filter Setup ===
L = 1; % Filter order
mu = 0.0000001; % Step size

% Generate LMS filter
lmsFilter = dsp.LMSFilter('Length', L, 'StepSize', mu);

% Apply LMS filter with synchronized signals
[filter_out, err] = lmsFilter(interference_signal_interp, received_signal);

% Compute Auto-correlation and Cross-correlation
Rax = xcorr(interference_signal_interp, interference_signal_interp, 'biased');
pxx = xcorr(interference_signal_interp, received_signal, 'biased');

% Define Filter Parameters
midPoint = length(interference_signal_interp);

% Extract necessary sections for the filter
RaxMatrix = toeplitz(Rax(midPoint:midPoint+L-1));
pxxVector = pxx(midPoint:midPoint+L-1);

% Compute Wiener Filter Coefficients
wienerCoefficients = RaxMatrix\pxxVector; % Solve for Wiener filter coefficients

% Apply Wiener Filter to Estimate Noise
filteredSignal = filter(wienerCoefficients, 1, interference_signal_interp);

% Recover Desired Signal (Error Signal)
ew = received_signal - filteredSignal;

% === Plot Results ===
figure;
subplot(4,1,1); 
plot(time0, fet_in*1e-3); 
title('FET (HT) Input');
xlabel('Time (s)');
ylabel('(V)');
xlim([0 0.04])

subplot(4,1,2); 
plot(time, interference_signal_interp); 
title('Interference Signal (Noise) - Time Adjusted');
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
