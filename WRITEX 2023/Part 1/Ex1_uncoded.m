%% Copyright AICOMS WRITEXS 2023 
clc;
clear all;
N = 120;                    %Blocklength
R = 1;                      %Code Rate
SNR = 50;                   %[dB] SNR
snr = 10.^(SNR/10);         %SNR dalam numerik
sigma = sqrt(1/(snr));      %Variance
%% Transmitter 
u = randi([0,1],1,N);       %Generate random bits
out_simbol = 1-2.*u;        %BPSK Modulation
x = out_simbol;             %Tx
%% Channel
noise = sigma/sqrt(2)*(randn(1,N)+(sqrt(-1)*randn(1,N)));   %AWGN
%h = 1;                     %AWGN Channel
h = (randn(1,1)+(sqrt(-1)*randn(1,1)))/sqrt(2);  %Rayleigh Fading Channel
%% Receiver
y = h*x+noise;              %Received signal
yeq = conj(h)*y;            %Simple Equalizer
for i=1:N
    if yeq(i)>=0
        u_hat(i)=0;
    else
        u_hat(i)=1;
    end
end
compare_bit = sum(u_hat~=u) %Compare Bit