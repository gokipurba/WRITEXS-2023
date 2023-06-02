%% Copyright AICOMS WRITEX 2023
addpath(genpath('function'));
m = 2;                      %index modulation
M = log2(m);                %length bits per symbol
N = 128;                    %Length of bits infromation
R = 3;                      %repetition factor
K = floor(N*R);             %BlockLength
SNR = 0:5:50;               %[dB] SNR
snr = 10.^(SNR/10);         %SNR dalam numerik
frame =250;
for ii=1:length(SNR)
    fprintf('SNR: %d\n', SNR(ii));
    ber = 0;
    sigma = sqrt(1/snr(ii));     %Variance 
    for j = 1:frame
        %% Transmitter 
        u = randi([0,1],1,N);       %Generate random bits
        c = func_repetition_encoder(u,R);   %Repetition Code
        out_simbol = 1-2.*c;        %BPSK Modulation
        x = out_simbol;             %Tx
        %% Channel
        noise = sigma/sqrt(2)*(randn(1,length(x))+(sqrt(-1)*randn(1,length(x))));   %AWGN
        %h = 1;                      %AWGN Channel
        h = (randn+sqrt(-1)*randn)/sqrt(2);  %Rayleigh Fading Channel
        %% Receiver
        y = h*x+noise;               %Received signal
        yeq = conj(h)*y;        
        for iii=1:length(yeq)
            if yeq(iii)>=0
                c_hat(iii)=0;
            else
                c_hat(iii)=1;
            end
        end
        u_hat = func_repetition_decoder(c_hat,R);
        compare_bit = sum(u_hat~=u); %Compare Bit
        ber = ber+compare_bit;
    end
    %% Get average of BER
    BER(ii) = ber/(frame*K);
end
fprintf('BER: %d\n', BER);
figure(1);
Figure1 = figure(1);
semilogy(SNR, BER, '--ro', 'linewidth', 1);
xlabel('Average SNR (dB)');
ylabel('Average BER');
legend('Coded')
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
