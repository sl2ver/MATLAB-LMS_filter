% % 0 ~ 1 min max 정규화
% folderPath = "C:\Users\EMMA Lab\Desktop\3.26_실험";  % 원하는 경로로 수정
% fileList = dir(fullfile(folderPath, '*.csv'));
% 
% for k = 1:length(fileList)
%     fileName = fileList(k).name;
%     filePath = fullfile(folderPath, fileName);
% 
%     % 테이블 읽기
%     data = readtable(filePath);
% 
%     % 열 인덱스로 접근 (1열 = 시간, 2열 = 신호값)
%     time = data{:,1};         % 'time(s)' 열
%     amplitude = data{:,2};    % 'v' 열
% 
%     % Min-Max 정규화
%     normalized = (amplitude - min(amplitude)) / (max(amplitude) - min(amplitude));
% 
%     % 그래프 출력
%     figure;
%     plot(time, normalized, 'LineWidth', 1.5);
%     title(['Normalized Signal - ', fileName], 'Interpreter', 'none');
%     xlabel('Time (s)');
%     ylabel('Normalized Amplitude');
%     grid on;
% end
% 
% disp('정규화 및 그래프 출력 완료 (파일 저장은 생략)');




% 모든 csv 파일 헤더를 time(s), v로 변경
% 
% folderPath = "C:\Users\EMMA Lab\Desktop\3.26_실험";  % 수정 필요
% 
% fileList = dir(fullfile(folderPath, '*.csv'));
% 
% for k = 1:length(fileList)
%     % 각 파일 경로
%     fileName = fileList(k).name;
%     filePath = fullfile(folderPath, fileName);
% 
%     % 파일 내용을 줄 단위로 모두 읽기
%     lines = readlines(filePath);
% 
%     % 첫 줄을 수정
%     lines(1) = "time(s),v";
% 
%     % 수정된 내용을 같은 파일에 덮어쓰기
%     writelines(lines, filePath);
% end
% 
% disp('모든 CSV 파일의 첫 줄을 "time(s),v"로 수정 완료!');


% % CSV 파일들이 있는 폴더 경로
% folderPath = "C:\Users\EMMA Lab\Desktop\3.26_실험";  % 수정 필요
% fileList = dir(fullfile(folderPath, '*.csv'));
% 
% % 각 파일의 range 저장할 변수
% fileNames = strings(length(fileList), 1);
% amplitudeRanges = zeros(length(fileList), 1);
% 
% for k = 1:length(fileList)
%     fileName = fileList(k).name;
%     filePath = fullfile(folderPath, fileName);
% 
%     data = readtable(filePath);
% 
%     % 열 인덱스로 접근 (1열 = 시간, 2열 = 신호값)
%     time = data{:,1};         % 'time(s)'
%     amplitude = data{:,2};    % 'v'
% 
%     % Range 계산 (정규화 이전)
%     amplitudeRange = max(amplitude) - min(amplitude);
%     amplitudeRanges(k) = amplitudeRange;
%     fileNames(k) = fileName;
% 
%     % 정규화
%     normalized = (amplitude - min(amplitude)) / (max(amplitude) - min(amplitude));
% 
%     % 그래프 출력 (정규화된 데이터)
%     figure;
%     plot(time, normalized, 'LineWidth', 1.5);
%     title(['Normalized Signal - ', fileName], 'Interpreter', 'none');
%     xlabel('Time (s)');
%     ylabel('Normalized Amplitude');
%     grid on;
% end
% 
% % --- Range 바 그래프 그리기 ---
% figure;
% bar(amplitudeRanges);
% set(gca, 'XTick', 1:length(fileList), 'XTickLabel', fileNames, 'XTickLabelRotation', 45);
% ylabel('Original Amplitude Range (Max - Min)');
% title('Amplitude Range of Each Signal');
% grid on;
% 
% disp('정규화 + 개별 그래프 + Range 비교 바차트 출력 완료!');



%% max abs 정규화

% folderPath = "C:\Users\EMMA Lab\Desktop\3.26_실험" ;  % 경로 수정
% fileList = dir(fullfile(folderPath, '*.csv'));
% 
% fileNames = strings(length(fileList), 1);
% amplitudeRanges = zeros(length(fileList), 1);
% 
% for k = 1:length(fileList)
%     fileName = fileList(k).name;
%     filePath = fullfile(folderPath, fileName);
% 
%     data = readtable(filePath);
% 
%     time = data{:,1};         % 'time(s)' 열
%     amplitude = data{:,2};    % 'v' 열
% 
%     % 원본 amplitude range 계산
%     amplitudeRange = max(amplitude) - min(amplitude);
%     amplitudeRanges(k) = amplitudeRange;
%     fileNames(k) = fileName;
% 
%     % ✅ Max Abs 정규화
%     maxAbs = max(abs(amplitude));
%     normalized = amplitude / maxAbs;
% 
%     % 정규화된 그래프 그리기
%     figure;
%     plot(time, normalized, 'LineWidth', 1.5);
%     title(['Max Abs Normalized - ', fileName], 'Interpreter', 'none');
%     xlabel('Time (s)');
%     ylabel('Amplitude / Max|Amplitude|');
%     grid on;
% end
% 
% % --- Range 바 그래프 그리기 ---
% figure;
% bar(amplitudeRanges);
% set(gca, 'XTick', 1:length(fileList), 'XTickLabel', fileNames, 'XTickLabelRotation', 45);
% ylabel('Original Amplitude Range (Max - Min)');
% title('Amplitude Range of Each Signal');
% grid on;
% 
% disp('Max Abs 정규화 및 그래프 출력 완료!');




% 
% -1 ~ 1 min max 정규화
folderPath = "C:\Users\EMMA Lab\Desktop\3.26_실험";  % 경로 수정
fileList = dir(fullfile(folderPath, '*.csv'));

fileNames = strings(length(fileList), 1);
amplitudeRanges = zeros(length(fileList), 1);

for k = 1:length(fileList)
    fileName = fileList(k).name;
    filePath = fullfile(folderPath, fileName);

    data = readtable(filePath);

    %1열 = 시간, 2열 = 진폭
    time = data{:,1}; 
    amplitude = data{:,2};

    %원본 amplitude range 계산
    amplitudeRange = max(amplitude) - min(amplitude);
    amplitudeRanges(k) = amplitudeRange;
    fileNames(k) = fileName;

    %✅ -1 ~ 1 범위로 Min-Max 정규화
    minVal = min(amplitude);
    maxVal = max(amplitude);
    normalized = (amplitude - minVal) / (maxVal - minVal);  % 0 ~ 1
    scaled = 2 * normalized - 1;  % -1 ~ 1

    %정규화된 그래프 출력
    figure;
    plot(time, scaled, 'LineWidth', 1.5);
    title(['[-1 ~ 1] Normalized Signal - ', fileName], 'Interpreter', 'none');
    xlabel('Time (s)');
    ylabel('Normalized Amplitude [-1 ~ 1]');
    grid on;
end

% %%subplot 사용
% % -1 ~ 1 Min-Max 정규화 + Subplot 출력
% clc;  close all;
% folderPath = "C:\Users\EMMA Lab\Desktop\3.26_실험";
% fileList = dir(fullfile(folderPath, '*.csv'));
% 
% fileNames = strings(length(fileList), 1);
% amplitudeRanges = zeros(length(fileList), 1);
% 
% % subplot layout 설정 (20개 기준)
% numFiles = length(fileList);
% numRows = 5;
% numCols = 4;
% 
% figure;  % 한 figure에 subplot으로 다 넣기
% 
% for k = 1:numFiles
%     fileName = fileList(k).name;
%     filePath = fullfile(folderPath, fileName);
% 
%     data = readtable(filePath);
%     time = data{:,1};
%     amplitude = data{:,2};
% 
%     amplitudeRange = max(amplitude) - min(amplitude);
%     amplitudeRanges(k) = amplitudeRange;
%     fileNames(k) = fileName;
% 
%     % -1 ~ 1 정규화
%     minVal = min(amplitude);
%     maxVal = max(amplitude);
%     normalized = (amplitude - minVal) / (maxVal - minVal);
%     scaled = 2 * normalized - 1;
% 
%     % subplot에 그리기
%     subplot(numRows, numCols, k);
%     plot(time, scaled, 'LineWidth', 1);
%     title(fileName, 'Interpreter', 'none', 'FontSize', 8);
%     xlabel('', 'FontSize', 20);
%     ylabel('', 'FontSize', 20);
%     grid on;
% end
% 
% sgtitle('[-1 ~ 1] Normalized Signals (All Files)');







% %% 정규화 하기 전 그래프
% clc; close all;
% 
% folderPath = "C:\Users\EMMA Lab\Desktop\3.26_실험";  % 경로 수정
% fileList = dir(fullfile(folderPath, '*.csv'));
% 
% fileNames = strings(length(fileList), 1);
% amplitudeRanges = zeros(length(fileList), 1);
% 
% for k = 1:length(fileList)
%     fileName = fileList(k).name;
%     filePath = fullfile(folderPath, fileName);
% 
%     data = readtable(filePath);
% 
%     % 시간 및 진폭 데이터
%     time = data{:,1};
%     amplitude = data{:,2};
% 
%     % 원본 range 계산 및 저장
%     amplitudeRange = max(amplitude) - min(amplitude);
%     amplitudeRanges(k) = amplitudeRange;
%     fileNames(k) = fileName;
% 
%     % ✅ 1. 정규화 전 원본 신호 그래프
%     figure;
%     plot(time, amplitude, 'LineWidth', 1.5);
%     title(['Original Signal - ', fileName], 'Interpreter', 'none');
%     xlabel('Time (s)');
%     ylabel('Amplitude');
%     grid on;
% end

% %%(정규화 + Mean Abs + SNR 비교 그래프)
% folderPath = "C:\Users\EMMA Lab\Desktop\3.26_실험";
% fileList = dir(fullfile(folderPath, '*.csv'));
% 
% numFiles = length(fileList);
% fileNames = strings(numFiles, 1);
% meanAbsValues = zeros(numFiles, 1);
% snrValues_dB = zeros(numFiles, 1);
% 
% for k = 1:numFiles
%     fileName = fileList(k).name;
%     filePath = fullfile(folderPath, fileName);
% 
%     data = readtable(filePath);
%     time = data{:,1};
%     amplitude = data{:,2};
% 
%     % --- 정규화 [-1 ~ 1]
%     minVal = min(amplitude);
%     maxVal = max(amplitude);
%     normalized = (amplitude - minVal) / (maxVal - minVal);
%     scaled = 2 * normalized - 1;
% 
%     % --- 피크값 추출 (양/음 둘 다)
%     [pks_pos, ~] = findpeaks(scaled);        % 양의 피크
%     [pks_neg, ~] = findpeaks(-scaled);       % 음의 피크
%     pks_neg = -pks_neg;                      % 다시 원래 부호로
% 
%     allPeaks = [pks_pos; pks_neg];           % 모든 피크 (양/음)
%     
%     % --- 분석 1: Mean Absolute Value
%     meanAbsValues(k) = mean(abs(allPeaks));
% 
%     % --- 분석 2: SNR (피크 기준)
%     signalPower = mean(allPeaks .^ 2);
%     noisePower = mean((allPeaks - mean(allPeaks)) .^ 2);
%     snr_dB = 10 * log10(signalPower / noisePower);
%     snrValues_dB(k) = snr_dB;
% 
%     fileNames(k) = fileName;
% end
% 
% % --- 그래프 1: Mean Abs (피크 기반)
% figure;
% bar(meanAbsValues);
% set(gca, 'XTick', 1:numFiles, 'XTickLabel', fileNames, 'XTickLabelRotation', 45, 'FontSize', 10);
% ylabel('Mean |Peak Amplitude|', 'FontSize', 12);
% title('Mean Absolute Value of Peaks (Normalized Signals)', 'FontSize', 14);
% grid on;
% 
% % --- 그래프 2: SNR (피크 기반)
% figure;
% bar(snrValues_dB);
% set(gca, 'XTick', 1:numFiles, 'XTickLabel', fileNames, 'XTickLabelRotation', 45, 'FontSize', 10);
% ylabel('SNR (dB) based on Peaks', 'FontSize', 12);
% title('SNR of Peaks in Normalized Signals', 'FontSize', 14);
% grid on;



