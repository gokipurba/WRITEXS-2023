%% Copyright AICOMS WRITEXS 2023
addpath(genpath('function'));
m = 2;                      %index modulation
M = log2(m);                %length bits per symbol
N = 128;                    %Length of bits infromation
R = 1;                      %Code Rate
K = floor(N*R);             %BlockLength
SNR = 0:5:50;               %[dB] SNR
snr = 10.^(SNR/10);         %SNR dalam numerik
frame = 5000;
for i=1:length(SNR)
    fprintf('SNR: %d\n', SNR(i));
    ber = 0;
    sigma = sqrt(1/snr(i));     %Variance 
    for j = 1:frame
        %% Transmitter 
        u = randi([0,1],1,N);       %Generate random bits
        out_simbol = 1-2.*u;        %BPSK Modulation
        x = out_simbol;             %Tx
        %% Channel
        noise = sigma/sqrt(2)*(randn(1,N)+(sqrt(-1)*randn(1,N)));   %AWGN
        %h = 1;                      %AWGN Channel
        h = (randn+sqrt(-1)*randn)/sqrt(2);  %Rayleigh Fading Channel
        %% Receiver
        y = h*x+noise;               %Received signal
        yeq = conj(h)*y;        
        for k=1:length(y)
            if yeq(k)>=0
                u_hat(k)=0;
            else
                u_hat(k)=1;
            end
        end
        compare_bit = sum(u_hat~=u); %Compare Bit
        ber = ber+compare_bit;
    end
    %% Get average of BER
    BER(i) = ber/(frame*K);
end
fprintf('BER: %d\n', BER);
figure(1);
Figure1 = figure(1);
semilogy(SNR, BER, '--bo', 'linewidth', 1);
xlabel('Average SNR (dB)');
ylabel('Average BER');
legend('Uncoded')
grid on;
FigW = 6;
FigH = 5.6;
set(Figure1,'defaulttextinterpreter','tex',...
    'PaperUnits','inches','Papersize',[FigW,FigH],...
    'Paperposition',[0,0,FigW,FigH],'Units','Inches',...
    'Position',[0,0,FigW,FigH])
set(gca,...
    'FontSize',10,...
    'FontName','Arial');
hold on;
