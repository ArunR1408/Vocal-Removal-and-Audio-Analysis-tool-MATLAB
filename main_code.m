% Topic: Vocal Removal and Audio Analysis
  

clear all
close all
clc

display('*****************************************************');
display('          Vocal Removal and Audio Analysis              ');
display('*****************************************************');
display(' ');
display('Reading Wave File');

% Music clip that is converted from mp3 to wav
[sample_data, sampling_rate] = audioread('E:/music.wav ');
pause(5);
display('Data sampled successfully. Reading completed.');
pause(1);
display(' ');
display('Playing original wav file');

% Playing Original WAV file using in-built player
sound(sample_data, sampling_rate);

% Separate both channel signals from sampled data 
samples = size(sample_data);        % calculating no. of sampled data
left_channel = sample_data(:, 1);   % store left channel data
right_channel = sample_data(:, 2);  % store right channel data

% Stereo Cancellation Technique
% Get Frequency Domain using Fast Fourier Transform for both channels
left_channel_fft = fft(left_channel); 
right_channel_fft = fft(right_channel); 

% Remove center spanned vocal from music
no_voice_sample_fft = left_channel_fft - right_channel_fft;

% Apply Inverse Fast Fourier Transform to get back music
no_voice_sample = ifft(no_voice_sample_fft);

display(' ');
display('press any key to continue...');
display(' ');
pause;
display('Playing wav file without vocal');
% Playing Removed vocal WAV Instrumental audio file using in-built player
sound(no_voice_sample, sampling_rate);

% Plotting the audio
t = (0:length(sample_data)-1) / sampling_rate;

figure;
subplot(2,1,1);
plot(t, sample_data);
title('Original Audio');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2,1,2);
plot(t, no_voice_sample);
title('Audio without Vocals');
xlabel('Time (s)');
ylabel('Amplitude');

% Spectrogram of audio
figure;
subplot(2,1,1);
spectrogram(sample_data(:,1), hamming(256), 128, 256, sampling_rate, 'yaxis');
title('Spectrogram of Original Audio');

subplot(2,1,2);
spectrogram(no_voice_sample, hamming(256), 128, 256, sampling_rate, 'yaxis');
title('Spectrogram of Audio without Vocals');

% Zero Crossing Rate
frame_length = 1024;
hop_length = 512;

zcr_original = zeros(floor((length(sample_data)-frame_length)/hop_length), 1);
zcr_no_voice = zeros(floor((length(no_voice_sample)-frame_length)/hop_length), 1);

for i = 1:length(zcr_original)
    frame_original = sample_data((i-1)*hop_length+1 : (i-1)*hop_length+frame_length, 1);
    frame_no_voice = no_voice_sample((i-1)*hop_length+1 : (i-1)*hop_length+frame_length);
    
    zcr_original(i) = sum(abs(diff(sign(frame_original)))) / (2 * frame_length);
    zcr_no_voice(i) = sum(abs(diff(sign(frame_no_voice)))) / (2 * frame_length);
end

figure;
subplot(2,1,1);
plot(zcr_original);
title('Zero Crossing Rate of Original Audio');
xlabel('Frame');
ylabel('ZCR');

subplot(2,1,2);
plot(zcr_no_voice);
title('Zero Crossing Rate of Audio without Vocals');
xlabel('Frame');
ylabel('ZCR');


% After obtaining no_voice_sample through stereo cancellation technique
% Save the audio without vocals
%audiowrite('audio_without_vocals.wav', no_voice_sample, sampling_rate);
%display('Audio without vocals saved as audio_without_vocals.wav');
