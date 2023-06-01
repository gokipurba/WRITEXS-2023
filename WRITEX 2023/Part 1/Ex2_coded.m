%% Copyright AICOMS WRITEXS 2023 
addpath(genpath('function'));
clc;
clear all;
N = 120;                    %Blocklength
R = 3;                      %repetition factor
SNR = 50;                   %[dB] SNR
snr = 10.^(SNR/10);         %SNR dalam numerik
sigma = sqrt(1/(snr));      %Variance
%% Transmitter 
u = randi([0,1],1,N);        %Generate random bits
c = func_repetition_encoder(u,R);   %Repetition Code
out_simbol = 1-2.*c;        %BPSK Modulation
x = out_simbol;             %Tx
%% Channel
noise = sigma/sqrt(2)*(randn(1,length(x))+(sqrt(-1)*randn(1,length(x))));   %AWGN
%h = 1;                     %AWGN Channel
h = (randn(1,1)+sqrt(-1)*randn(1,1))/sqrt(2);  %Rayleigh Fading Channel
%% Receiver
y = h*x+noise;              %Received signal
yeq = conj(h)*y;            %Simple Equalizer
for i=1:length(yeq)
    if yeq(i)>=0
        c_hat(i)=0;
    else
        c_hat(i)=1;
    end
end
u_hat = func_repetition_decoder(c_hat,R);
compare_bit = sum(u_hat~=u) %Compare Bit